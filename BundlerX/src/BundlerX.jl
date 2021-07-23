module BundlerX

using TranscodingStreams
using CodecZstd
using Tar

include("../gen/Mman.jl")
using .Mman

include("util.jl")

const MAGIC = "bb67f070-18d4-46be-b03c-54d1684c06d7"

function pack(
        src, dst = joinpath(dirname(src), "$(basename(src))-obs"); compression_level::Int = 1 
)
    open(dst, "w") do io
        open(joinpath(@__DIR__, "../gen/Mman.jl")) do f
            writeln(io, f)
        end
        writeln(io, read(joinpath(@__DIR__, "../scripts/stub.jl")))

        writeln(io, "const MAGIC = ", '"', MAGIC, '"')

        writeln(io, "main()")
        writeln(io, "exit()")

        writeln(io, MAGIC)
    end

    open(dst, "a") do dstio
        open(src, "r") do srcio
            stream = TranscodingStream(ZstdCompressor(level=compression_level), dstio)
            write(stream, srcio)
            close(stream)
        end
    end
end

end
