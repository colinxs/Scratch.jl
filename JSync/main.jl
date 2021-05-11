using JSync
using Random
using FileWatching

function randpath(parent, n=10; delay=0.001)
    cur = parent
    for i in 1:n
        dir = rand(Bool)
        path = joinpath(cur, randstring(3))
        if dir
            cur = mkdir(path)
        else
            touch(path)
        end
        sleep(delay)
    end
end

function randpathflat(parent, n=10; delay=0.001)
    for i in 1:n
        path = joinpath(parent, randstring(5))
        while ispath(path)
            path = joinpath(parent, randstring(5))
        end
        mkdir(path)
    end
end

function randdelete(parent, n=10; delay=0.001)
    del = []
    for (r, ds, fs) in walkdir(parent)
        for d in ds
            d = joinpath(r, d)
            if rand() > 0.5
                push!(del, d)
            end
        end
        for d in fs
            d = joinpath(r, d)
            if rand() > 0.5
                push!(del, d)
            end
        end
    end
    for x in del
        rm(x; recursive=true, force=true)
    end
end

function paths(path)
    x = String[]
    try
        for (r, ds, fs) in walkdir(path)
            for d in ds
                push!(x, JSync.sanitize_path(joinpath(r, d)))
            end
            for f in fs
                push!(x, JSync.sanitize_path(joinpath(r, f)))
            end
        end
    catch
    end
    return x
end

function reader(tw)
    known = Set()
    t = time()
    while !(JSync.isactive(tw) & isopen(tw))
        sleep(0.001)
    end

    n = 0
    # @async while true
    #     if time() - t > 1
    #     t = time()
    #     end
    # end
    while isopen(tw)
        try
            x = take!(tw)
            if x isa JSync.TreeEvent
                # println(x.path)
                push!(known, x.path)
                n = 1
            else
                n = length(x)
                for ev in x
                    push!(known, ev.path)
                end
            end
        catch e
            close(tw)
            e isa InvalidStateException || rethrow()
        end
    end
end

function writer(ch)
    while true
        x = JSync.watch_folder("/tmp/test/")
        @async put!(ch, x.path)
    end
end

# function reader(ch)
#     while true
#         x=take!(ch)
#         println(x)
#     end
# end

function main()
    rm("/tmp/test"; recursive=true, force=true)
    mkdir("/tmp/test")

    # tw = JSync.watch_tree("/tmp/test", max_delay=1)
    tw = JSync.watch_tree("/tmp/test"; max_events=50, max_delay=Inf)
    # Base.Experimental.@sync begin
    # tw = JSync.watch_tree("/tmp/test")
    # @info typeof(tw)
    reader(tw)
    #
    # ch = Channel{String}(Inf)
    # @async writer(ch)
    # reader(ch)
    return tw
end
