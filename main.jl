using Random

include("./src/JSync.jl")

function randpath(parent, n=10; delay=0.001)
    cur = parent
    for i=1:n
        dir = rand(Bool)
        path = joinpath(cur, randstring(5))
        if dir
            cur = mkdir(path)
        else
            touch(path)
        end
        sleep(delay)
    end
end

M=JSync

# rm("/tmp/fswatch", force=true, recursive=true)
# mkdir("/tmp/fswatch")
function main()
    ch = M.fswatch("/tmp/fswatch", "--recursive", "--event-flags")
    @async begin
        try
            while isopen(ch)
                x = take!(ch)
                println(x)
            end
        finally
            close(ch)
        end
    end
end


