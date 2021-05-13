module TestExtensions

export ExtendedTestSet

using Test: Test, AbstractTestSet, DefaultTestSet, Result, Pass, Fail, Error, Broken
using Test: record, finish, get_testset_depth, get_testset
using Base: @lock
using MacroTools: @forward
using ..ANSI

const ROOT_LOCK = ReentrantLock()

mutable struct ExtendedTestSet <: AbstractTestSet
    wrapped::DefaultTestSet
    set::Int
    pass::Int
    fail::Int
    error::Int
    broken::Int
    function ExtendedTestSet(args...; kwargs...)
        return new(DefaultTestSet(args...; kwargs...), 0, 0, 0, 0, 0)
    end
end

get_root() = get(task_local_storage(), :__BASETESTNEXT__, AbstractTestSet[])[begin]

function Test.record(ts::ExtendedTestSet, t::T) where {T}
    @lock ROOT_LOCK begin
        #! format: off
        root = get_root()
        T <: AbstractTestSet && (root.set    += 1)
        T <: Pass            && (root.pass   += 1)
        T <: Fail            && (root.fail   += 1)
        T <: Error           && (root.error  += 1)
        T <: Broken          && (root.broken += 1)
        #! format: on
    end
    show_progress()
    if (T <: Fail || T <: Error)
        println(stderr, clearline())
    end
    return record(ts.wrapped, t)
end

function Test.finish(ts::ExtendedTestSet)
    get_testset_depth() == 0 && end_progress()
    return finish(ts.wrapped)
end

function show_progress()
    set, pass, fail, error, broken = @lock ROOT_LOCK begin
        root = get_root()
        root.set, root.pass, root.fail, root.error, root.broken
    end
    str = sprint(; context=IOContext(stderr, :color => true)) do io
        print(io, cursor_disable(), clearline(), cursor_move_col())
        for (name, count, color) in (
            #! format: off
            ("Set",    set,    Base.warn_color()),
            ("Pass",   pass,   :green),
            ("Fail",   fail,   Base.error_color()),
            ("Error",  error,  Base.error_color()),
            ("Broken", broken, Base.warn_color()),
            #! format: on
        )
            printstyled(io, string(name), ": "; bold=true, color)
            printstyled(io, count; bold=true, color)
            name != "Broken" && print(io, " | ")
        end
    end
    print(stderr, str)
    return nothing
end

end_progress() = println(stderr, clearline(), cursor_enable())

end # module
