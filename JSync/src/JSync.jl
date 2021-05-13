module JSync

using Base: @lock
using FileWatching: FileWatching, unwatch_folder
using MacroTools: @forward

export watch_tree, batched_watch_tree

include("types.jl")
include("util.jl")

const TIMEOUT_S = 1
const WATCHDOG_S = 10

const MIN_DELAY_S = 0.020
const MAX_DELAY_S = 3600

const MIN_EVENTS = 1
const MAX_EVENTS = 2^32

# Main entry point
function watch_tree(args...; kwargs...)
    watcher = TreeWatcher(args...; kwargs...)
    start!(watcher)
    return watcher
end

function batched_watch_tree(args...; kwargs...)
    watcher = BatchedTreeWatcher(args...; kwargs...)
    start!(watcher)
    return watcher
end

function watch_tree(f::Function, args...; kwargs...)
    tw = watch_tree(args...; kwargs...)
    try
        f(tw)
    catch
        close(tw)
        rethrow()
    end
end

function batched_watch_tree(f::Function, args...; kwargs...)
    tw = batched_watch_tree(args...; kwargs...)
    try
        f(tw)
    catch
        close(tw)
        rethrow()
    end
end

end # module
