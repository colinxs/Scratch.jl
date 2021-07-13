using Tar
using TranscodingStreams
using CodecZstd

function create_fd(fdname="")
    fd = Mman.memfd_create(fdname, Mman.MFD_CLOEXEC)
    path = "/proc/$(getpid())/fd/$fd"
    return (; fd, path)
end

function main()
    open(@__FILE__) do io
        for l in eachline(io)
            l == MAGIC && break
        end
        
        fd, path = create_fd()
        open(RawFD(fd)) do mio
            write(mio, io)
        end

        open(path) do mio
            stream = ZstdDecompressorStream(mio)
        end
    end
end
