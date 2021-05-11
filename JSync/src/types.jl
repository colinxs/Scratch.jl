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
    sync_period::Int
end

function TreeWatcher(root::String; sync_period::Int=5, sz::Int=1024)
    @assert isdir(root)
    @assert sync_period >= 0
    @assert sz > 0
    return TreeWatcher(
        sanitize_path(root),
        ReentrantLock(),
        Dict{String,Task}(),
        Set{String}(),
        Channel{TreeEvent}(sz),
        Threads.Atomic{Bool}(false),
        sync_period,
    )
end

@forward TreeWatcher.tree_events Base.take!, Base.wait
Base.isopen(tw::TreeWatcher) = isactive(tw) && isopen(tw.tree_events)
Base.isready(tw::TreeWatcher) = isactive(tw) && isready(tw.tree_events)
isactive(tw::TreeWatcher) = tw.isactive[]

function Base.close(tw::TreeWatcher)
    stop!(tw)
    @async begin
        @lock tw.lock begin
            for (_, task) in tw.watchlist
                wait(task)
            end
            close(tw.tree_events)
            empty!(tw.watchlist)
            empty!(tw.paths)
        end
    end
end

stop!(tw::TreeWatcher) = tw.isactive[] = false

function start!(tw::TreeWatcher)
    isopen(tw.tree_events) || error("Cannot start a closed TreeWatcher")
    tw.isactive[] = true
    ensure_watch_recursively!(tw, tw.root)
    # @async syncer(tw)
    return tw
end

# If something like `mkdir -p "/1/2/3/..../1000"`
# is done then TreeWatcher may fall out of sync
# because it's not able to add watchers for the subdirectories
# as fast as they are created
function syncer(tw::TreeWatcher)
    if tw.sync_period > 0
        # TODO watch for failed tasks
        t = time()
        while isactive(tw)
            if time() - t > tw.sync_period
                ensure_watch_recursively!(tw, tw.root)
                prune!(tw)
                t = time()
            end
            sleep(min(TIMEOUT_S, tw.sync_period))
        end
        @debug "Done syncing"
    end
end

function prune!(tw::TreeWatcher)
    @lock tw.lock begin
        watchlist = String[]
        tree = String[]
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
    @info "HERE: $path"
    path = sanitize_path(path)
    @info path
    @lock tw.lock begin
        unsafe_ensure_watch!(tw, path)
        try
            for child in recursive_children(path)
                unsafe_ensure_watch!(tw, child)
            end
        catch e
            e isa Base.IOError || rethrow()
        end
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
        while isopen(tw) && isdir(path)
            event = watch_folder(path, TIMEOUT_S)
            event.timedout && continue
            ispath(event.path) && @lock tw.lock push!(tw.tree, event.path)
            ensure_watch_recursively!(tw, event.path)
            if isopen(tw) 
                @async put!(tw.tree_events, event)
            end
        end
    finally
        @debug "Done watching $(path)" isdir(path) isactive(tw)
        unwatch_folder(path)
    end
end

# Is watching path, and task is still alive
function unsafe_iswatched(tw::TreeWatcher, path::String)
    return haskey(tw.watchlist, path) && !istaskdone(tw.watchlist[path])
end

# Keys of tw.watchlist should:
# end in trailing slash (i.e. paths to dirs)
# be a subpath of tw.root
# be an absolute path
function isvalid_watchpath(tw::TreeWatcher, path::String)
    return isdirpath(path) && issubpath(path, tw.root) && isabspath(path)
end

ischild(tw::TreeWatcher, path::String) = issubpath(path, tw.root)

# All children of tw.root are in tw.watchlist and being watched
function check_missing_children(tw::TreeWatcher)
    @lock tw.lock begin
        for child in recursive_children(tw.root)
            if !unsafe_haschild(tw, child)
                error("Missing child: $child  (dir: $(isdir(child)))")
            end
        end
    end
end

# All keys of tw.watchlist are valid (i.e. ischildlike)
function check_valid_children(tw::TreeWatcher)
    @lock tw.lock begin
        for (child, _) in tw.watchlist
            if !isvalid_watchpath(tw, child)
                error("Invalid child: $child")
            end
        end
    end
end

const Batch = Vector{TreeEvent}

struct BatchedTreeWatcher
    tw::TreeWatcher
    batch_events::Channel{Batch}
    max_delay::Float64
    max_events::Int
end

function BatchedTreeWatcher(root::String; max_delay=0, max_events=typemax(Int), sz=1024, kwargs...)
    tw = TreeWatcher(root; kwargs...)
    batch_events = Channel{Batch}(sz)
    return BatchedTreeWatcher(tw, batch_events, max_delay, max_events)
end

@forward BatchedTreeWatcher.batch_events Base.take!, Base.wait
Base.isopen(btw::BatchedTreeWatcher) = isopen(btw.batch_events) && isopen(btw.tw)
Base.isready(btw::BatchedTreeWatcher) = isready(btw.batch_events) && isready(btw.tw)
Base.close(btw::BatchedTreeWatcher) = (close(btw.batch_events); close(btw.tw))

@forward BatchedTreeWatcher.tw stop!, isactive
function start!(btw::BatchedTreeWatcher)
    start!(btw.tw)
    @async batcher(btw)
    return btw
end

function batcher(btw::BatchedTreeWatcher)
    buf = Dict{String,TreeEvent}()
    t = time()
    try
        while isopen(btw)
            event = take!(btw.tw)
            buf[event.path] = event
            if length(buf) > 0 && (time() - t > btw.max_delay || length(buf) > btw.max_events)
                batch = collect(values(buf))
                @async put!(btw.batch_events, batch)
                empty!(buf)
                t = time()
            end
        end
    finally
        close(btw)
    end
end
