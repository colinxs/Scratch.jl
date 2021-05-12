using Bundler
using Test

@testset "Bundler.jl" begin
    mktempdir() do dir
        cd(dir) do
            src = joinpath(@__DIR__, "example")
            dst = cp(src, joinpath(pwd(), basename(src)))
            bundle(; path=dst, main="foo.sh")
            @info readdir()
            @test chomp(read(`./example.sh`, String)) == "hello"
        end
    end
end
