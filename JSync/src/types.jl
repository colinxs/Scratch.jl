struct TreeEvent
    kind::Symbol
    path::String
    changed::Bool
    renamed::Bool
    timedout::Bool
end

struct TreeWatcher
    root::String
    lock::ReentrantLock
    watchlist::Dict{String,Task}
    tree::Set{String}
    tree_events::Channel{TreeEvent}
    isactive::Threads.Atomic{Bool}
    sync_period::Float64
end

function TreeWatcher(root::String; sync_period::Number=MAX_DELAY_S, sz::Integer=MAX_EVENTS)
    @assert isdir(root)
    @assert sz > 0
    return TreeWatcher(
        sanitize_path(root),
        ReentrantLock(),
        Dict{String,Task}(),
        Set{String}(),
        Channel{TreeEvent}(clip(sz, MIN_EVENTS, MAX_EVENTS)),
        Threads.Atomic{Bool}(false),
        clip(sync_period, MIN_DELAY_S, MAX_DELAY_S),
    )
end

@forward TreeWatcher.tree_events Base.take!, Base.wait, Base.isopen, Base.isready

isactive(tw::TreeWatcher) = tw.isactive[]

function Base.close(tw::TreeWatcher)
    stop!(tw)
    tasts = @lock tw.lock begin
        collect(values(tw.watchlist))
    end
    for (_, task) in tw.watchlist
        wait(task)
        if istaskfailed(task)
            Base.show_task_exception(stderr, task)
        end
    end
    @lock tw.lock begin
        close(tw.tree_events)
        empty!(tw.watchlist)
        empty!(tw.tree)
    end
    return tw
end

stop!(tw::TreeWatcher) = tw.isactive[] = false

function start!(tw::TreeWatcher)
    isopen(tw) || error("Cannot start a closed TreeWatcher")
    tw.isactive[] = true
    ensure_watch_recursively!(tw, tw.root)
    @async watchdog(tw)
    @async poll(tw)
    return tw
end

function poll(tw::TreeWatcher)
    t = time()
    try
        while isactive(tw)
            if time() - t >= tw.sync_period
                ensure_watch_recursively!(tw, tw.root)
                t = time()
            end
            sleep(tw.sync_period)
        end
    catch
        close(tw)
        rethrow()
    end
    @debug "Done syncing"
end


function watchdog(tw::TreeWatcher)
    t = time()
    try
        while isactive(tw)
            if time() - t >= tw.sync_period
                check_failed(tw)
                check_missing_children(tw)
                check_valid_children(tw)
                prune!(tw)
                t = time()
            end
            sleep(WATCHDOG_S)
        end
    catch
        close(tw)
        rethrow()
    end
    @debug "Done syncing"
end

function prune!(tw::TreeWatcher)
    watchlist = String[]
    tree = String[]
    @lock tw.lock begin
        for (dir, task) in tw.watchlist
            (isdir(dir) && !istaskdone(task)) || push!(watchlist, dir)
        end
        for path in tw.tree
            ispath(path) || push!(tree, path)
        end

        for dir in watchlist
            delete!(tw.watchlist, dir)
        end
        for path in tree
            delete!(tw.tree, path)
        end
    end
    return tw
end

function ensure_watch_recursively!(tw::TreeWatcher, path::String)
    path = sanitize_path(path)
    @lock tw.lock begin unsafe_ensure_watch!(tw, path) end
    children = sizehint!(String[], length(tw.tree))
    try
        for (r, ds, fs) in walkdir(path)
            for d in ds
                push!(children, sanitize_path(joinpath(path, r, d)))
            end
            for f in fs
                push!(children, sanitize_path(joinpath(path, r, f)))
            end
        end
    catch e
        e isa Base.IOError || rethrow()
    end
    @lock tw.lock for child in children
        unsafe_ensure_watch!(tw, child)
    end
    return tw
end

function unsafe_ensure_watch!(tw::TreeWatcher, path::String)
    kind = isdirpath(path) ? :dir : :file
    if kind === :dir && !unsafe_iswatched(tw, path)
        tw.watchlist[path] = @async watch_indefinitely!(tw, path)
    end
    if !(path in tw.tree)
        push!(tw.tree, path)
        @async put!(tw.tree_events, TreeEvent(kind, path, false, true, false))
    end
end

function watch_indefinitely!(tw::TreeWatcher, path::String)
    try
        while isactive(tw) && isopen(tw) && isdir(path)
            event = watch_folder(path, TIMEOUT_S)
            if !event.timedout && isopen(tw)
                if ispath(event.path)
                    @lock tw.lock push!(tw.tree, event.path)
                    ensure_watch_recursively!(tw, event.path)
                end
                @async put!(tw.tree_events, event)
            end
        end
    finally
        @debug "Done watching $(path)" isdir(path) isactive(tw)
        unwatch_folder(path)
    end
end

function unsafe_iswatched(tw::TreeWatcher, path::String)
    return haskey(tw.watchlist, path) && !istaskdone(tw.watchlist[path])
end

function isvalid_watchpath(tw::TreeWatcher, path::String)
    return isdirpath(path) && issubpath(path, tw.root) && isabspath(path)
end

ischild(tw::TreeWatcher, path::String) = issubpath(path, tw.root)

# All children of tw.root are in tw.watchlist and being watched
function check_missing_children(tw::TreeWatcher)
    @lock tw.lock begin
        for child in recursive_children(tw.root)
            if !unsafe_iswatched(tw, child)
                error("Missing child: $child  (dir: $(isdir(child)))")
            end
        end
    end
end

function check_valid_children(tw::TreeWatcher)
    @lock tw.lock begin
        for (child, _) in tw.watchlist
            if !isvalid_watchpath(tw, child)
                error("Invalid child: $child")
            end
        end
    end
end

function check_failed(tw::TreeWatcher)
    for task in values(tw.watchlist)
        istaskfailed(task) && throw(task.result)
    end
    return nothing
end

const Batch = Vector{TreeEvent}

struct BatchedTreeWatcher
    tw::TreeWatcher
    batch_events::Channel{Batch}
    buf::Dict{String,TreeEvent}
    lock::ReentrantLock
    max_delay::Float64
    max_events::Int
end

function BatchedTreeWatcher(
    root::String; max_delay=MAX_DELAY_S, max_events=MAX_EVENTS, sz=MAX_EVENTS, kwargs...
)
    tw = TreeWatcher(root; kwargs...)
    return BatchedTreeWatcher(
        tw,
        Channel{Batch}(clip(sz, MIN_EVENTS, MAX_EVENTS)),
        Dict{String,TreeEvent}(),
        ReentrantLock(),
        clip(max_delay, MIN_DELAY_S, MAX_DELAY_S),
        clip(max_events, MIN_EVENTS, MAX_EVENTS),
    )
end

@forward BatchedTreeWatcher.batch_events Base.take!, Base.wait
Base.isopen(btw::BatchedTreeWatcher) = isopen(btw.batch_events) && isopen(btw.tw)
Base.isready(btw::BatchedTreeWatcher) = isready(btw.batch_events) && isready(btw.tw)
Base.close(btw::BatchedTreeWatcher) = (close(btw.batch_events); close(btw.tw))

@forward BatchedTreeWatcher.tw stop!, isactive
function start!(btw::BatchedTreeWatcher)
    start!(btw.tw)
    @async reader(btw)
    @async writer(btw)
    return btw
end

function reader(btw::BatchedTreeWatcher)
    try
        while isopen(btw)
            event = take!(btw.tw)
            @lock btw.lock begin
                btw.buf[event.path] = event
            end
        end
    finally
        close(btw)
    end
end

function writer(btw::BatchedTreeWatcher)
    t = time()
    buf = btw.buf
    try
        while isopen(btw)
            @lock btw.lock begin
                if length(buf) > 0 && (time() - t >= btw.max_delay || length(buf) >= btw.max_events)
                    batch = collect(values(btw.buf))
                    @async put!(btw.batch_events, batch)
                    empty!(buf)
                    t = time()
                end
            end
            sleep(MIN_DELAY_S)
        end
    finally
        close(btw)
    end
end
