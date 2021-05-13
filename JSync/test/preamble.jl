using JSync
using JSync: @catchall
using Test
using Random
using Printf
using Dev.TestExtensions: ExtendedTestSet

const MIN_SLEEP = 0.001
const NM = 1000
const BATCH_SIZE = 10

function randpathdeep(parent, n=10; delay=MIN_SLEEP)
    cur = parent
    for i in 1:n
        dir = rand(Bool)
        path = joinpath(cur, randstring(3))
        if dir
            cur = mkdir(path)
        else
            touch(path)
        end
        delay > 0 && sleep(delay)
    end
end

function randpathflat(parent, n=10; delay=MIN_SLEEP)
    for i in 1:n
        path = joinpath(parent, randstring(10))
        if ispath(path)
            while ispath(path)
                path = joinpath(parent, randstring(10))
            end
        end
        dir = rand(Bool)
        if dir
            mkdir(path)
        else
            touch(path)
        end
        delay > 0 && sleep(delay)
    end
end

function randdelete(parent, n=10; delay=MIN_SLEEP)
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
        delay > 0 && sleep(delay)
    end
    for x in del
        rm(x; recursive=true, force=true)
    end
end

function paths(path)
    x = String[]
    push!(x, JSync.sanitize_path(path))
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
    try
        while isopen(tw)
            x = take!(tw)
            println(x)
        end
    catch
        e isa InvalidStateException || rethrow()
    end
end


