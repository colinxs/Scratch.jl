function create_fd(fdname="")
    fd = Mman.memfd_create(fdname, Mman.MFD_CLOEXEC)
    path = "/proc/$(getpid())/fd/$fd"
    return (; fd, path)
end

function encode(io::IO)
    buf = IOBuffer()
    stream = ZstdCompressorStream(buf)
    write(stream, io, TranscodingStreams.TOKEN_END)
    flush(stream)
    bytes = take!(buf)
    close(stream)
    return bytes
end

function decode(io::IO)
    stream = ZstdDecompressorStream(io)
    bytes = read(stream) 
    close(stream)
    return bytes
end

function writeln(io::IO, xs...)
    write(io, xs..., '\n')
end

padto(s, l) = s * repeat(PAD_CHAR, l - length(s))

isexecutable(path) = Bool(uperm(path) & 0x01)
