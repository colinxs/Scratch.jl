using Clang.Generators

cd(@__DIR__) do

header_dirs = [
    "/usr/lib/gcc/x86_64-linux-gnu/10/include"
    "/usr/local/include"
    "/usr/include/x86_64-linux-gnu"
    "/usr/include"
]

headers = [
    "/usr/include/x86_64-linux-gnu/sys/fanotify.h",
    # "/usr/include/x86_64-linux-gnu/sys/errno.h",
    # "/usr/include/x86_64-linux-gnu/sys/stat.h",
    "/usr/include/fcntl.h"
]

options = load_options(joinpath(@__DIR__, "generator.toml"))

# add compiler flags, e.g. "-DXXXXXXXXX"
args = get_default_args()
for dir in header_dirs
    @info dir
    push!(args, "-I$dir")
end

# create context
ctx = create_context(headers, args, options)

# run generator
build!(ctx)

end
