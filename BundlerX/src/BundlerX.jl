module BundlerX

using TranscodingStreams
using CodecZstd
using Tar

include("../gen/Mman.jl")
using .Mman

include("util.jl")

const MAGIC = "bb67f070-18d4-46be-b03c-54d1684c06d7"

function pack(
        path, dir; entrypoint::Union{String,Nothing}=nothing, compression_level::Int = 1 
)
    open(path, "w") do io
        open(joinpath(@__DIR__, "../gen/Mman.jl")) do f
            writeln(io, f)
        end
        writeln(io, read(joinpath(@__DIR__, "../scripts/stub.jl")))

        write(io, "const ENTRY_POINT = ")
        if entrypoint === nothing 
            writeln(io, "nothing") 
        else
            isexecutable(joinpath(dir, entrypoint)) || error("Not an executable: $entrypoint")
            writeln(io, '"', entrypoint, '"')
        end

        writeln(io, "const MAGIC = ", '"', MAGIC, '"')

        writeln(io, "main()")
        writeln(io, "exit()")

        writeln(io, MAGIC)
    end

    open(path, "a") do io
        stream = TranscodingStream(ZstdCompressor(level=compression_level), io)
        Tar.create(dir, stream)
        close(stream)
    end
end

end
