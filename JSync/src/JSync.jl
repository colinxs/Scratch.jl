module JSync

using Random
using Base: @lock
using FileWatching: FileWatching, unwatch_folder
using Dev: @exportall
using MacroTools: @forward 

include("types.jl")
include("util.jl")

const TIMEOUT_S = 10

# Main entry point
function watch_tree(args...; max_delay= 0, max_events = typemax(Int), kwargs...)
    if max_delay > 0 || max_events != typemax(Int)
        watcher = BatchedTreeWatcher(args...; max_delay, max_events, kwargs...)
    else
        watcher = TreeWatcher(args...; kwargs...)
    end
    # Threads.@spawn start!(watcher)
    start!(watcher)
    watcher
end

@exportall

end # module
