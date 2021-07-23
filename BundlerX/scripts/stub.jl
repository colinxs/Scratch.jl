using Tar
using TranscodingStreams
using CodecZstd

function create_fd(fdname="")
    # fd = Mman.memfd_create(fdname, Mman.MFD_CLOEXEC)
    fd = Mman.memfd_create(fdname, 0) 
    path = "/proc/$(getpid())/fd/$fd"
    return (; fd, path)
end

function main()
    open(@__FILE__) do io
        for l in eachline(io)
            l == MAGIC && break
        end
        
        fd, path = create_fd()
        # open(RawFD(fd)) do mio
        #     write(mio, io)
        # end


        stream = ZstdDecompressorStream(io)
        mio = open(RawFD(fd))
        write(mio, stream)
        close(stream)
        flush(mio)

        child = ccall(:fork, Cint, ())
        if child > 1
            exit()
        else
            return
        end
        @info child

        ccall(:umask, Cint, (Cint, ), 0)
        ccall(:setsid, Cint, ())
        cd("/")

        f = open("/dev/null", "w")
        Libc.dup(fd(f), fd(stdin))
        close(f)

        ccall(:execv, Cint, (Cstring, Ptr{Ptr{UInt8}}), path, ARGS)
        @info path
    end
end
