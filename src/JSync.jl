module JSync

const KeyType = Union{String,Symbol}
const ValueType = Any

function fswatch(path::String, args::Union{KeyType,Pair{KeyType,ValueType}}...)
    parsed = String[]
    for arg in args
        if arg isa KeyType 
            push!(parsed, string(arg))
        else
            k, v = arg
            push!(parsed, string(k))
            push!(parsed, string(v))
        end
    end
    cmd = `fswatch $path $parsed`
    ch = Channel(Inf)
    @async worker(cmd, ch)
    return ch
end

function worker(cmd::Cmd, ch::Channel)
    p = open(cmd, "r")
    try
        while isopen(ch)
            event = readline(p)
            put!(ch, event)
        end
    finally
        kill(p)
        wait(p)
    end
    return nothing
end

end # module
