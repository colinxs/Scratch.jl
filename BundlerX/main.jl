module M

include("./src/BundlerX.jl")
using .BundlerX

function main2()
    script = 
    """
    #!/usr/bin/bash
    echo "YOO"
    """
    fd, path = BundlerX.create_fd()
    open(RawFD(fd)) do io
        write(io, script)
        seekstart(io)
        print(read(io, String))
    end

    run(`$path`)

    orig = take!(IOBuffer(script))
    enc = BundlerX.encode(IOBuffer(script))
    dec = BundlerX.decode(IOBuffer(enc))
    @assert orig == dec

    BundlerX.pack(joinpath(@__DIR__, "example"), "/tmp/foo")
end

function main()
    # src = "/nix/store/z4kq2snywp4wg654y0q438l7801lph71-ripgrep-13.0.0/bin/rg"
    src = "/tmp/exe"
    BundlerX.pack(src, "rgobs")
end

end


r = M.main()

