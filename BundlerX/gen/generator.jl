using Clang
using Clang.Generators
using Clang.LibClang.Clang_jll
using Suppressor

function system_include_path()
    paths = String[]
    # hack
    s = @capture_err @suppress_out run(`$(clang()) -x c -E -v /dev/null`)
    it = eachline(IOBuffer(s))
    line, state = iterate(it)
    while line != nothing && line != "#include <...> search starts here:"
        line, state = iterate(it, state)
    end
    line, state = iterate(it, state)
    while line != nothing && line != "End of search list."
        push!(paths, strip(line))
        line, state = iterate(it, state)
    end
    return paths
end

function find_header(header, dirs)
    if !isfile(header)
        for d in dirs
            h = joinpath(d, header)
            if isfile(h)
                return h
            end
        end
    end
    return header
end

function find_headers(header, dirs)
    headers = String[]
    if !isfile(header)
        for d in dirs
            h = joinpath(d, header)
            if isfile(h)
                push!(headers, h)
            end
        end
    end
    return headers
end


function main()
    cd(@__DIR__) do
        header_dirs = String[]

        # append!(header_dirs, Clang.JLLEnvs.get_system_dirs(get_triple()))
        append!(header_dirs, system_include_path())

        headers = String[]
        push!(headers, find_header("sys/mman.h", header_dirs))

        args = get_default_args()
        push!(args, "-D_GNU_SOURCE") # needed for memfd_create
        for dir in header_dirs
            push!(args, "-I$dir")
        end

        options = load_options(joinpath(@__DIR__, "generator.toml"))

        ctx = create_context(headers, args, options)

        build!(ctx)
    end
end

main()

