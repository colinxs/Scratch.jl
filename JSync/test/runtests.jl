module TestJSync

include("preamble.jl")

@testset ExtendedTestSet verbose = true "$(@sprintf "%-34s" "JSync.jl")" begin
    @testset "$(@sprintf "%-20s %4i %4i %6g" "TreeWatcher" N M delay)" for (N,M,delay) in  [
        (NM,0,MIN_SLEEP),
        (0,NM,MIN_SLEEP),
        (NM,NM,0),
    ]
        mktempdir() do dir
            seen = Set{String}()
            push!(seen, JSync.sanitize_path(dir))
            JSync.watch_tree(dir; sync_period = Inf) do tw
                sleep(1)
                @sync begin
                    @async begin
                        randpathdeep(dir, N; delay)
                        randpathflat(dir, M; delay)
                    end
                    @async try
                        while isopen(tw) 
                            ev = take!(tw)
                            push!(seen, ev.path)
                            @debug ev.path
                        end
                    catch e
                        e isa InvalidStateException || rethrow()
                    end
                    sleep((N + M) * max(MIN_SLEEP, delay) + 1)
                    close(tw)
                    ps = paths(dir)
                    @debug filter(p -> !(p in ps), seen)
                    @test all(p -> p in ps, seen)
                    @test isempty(tw.watchlist)
                    @test !any(istaskfailed, tw.watchlist)
                end
            end
        end
    end

    @testset "$(@sprintf "%-20s %4i %4i %6g" "BatchedTreeWatcher" N M delay)" for (N,M,delay) in  [
        (NM,0,MIN_SLEEP),
        (0,NM,MIN_SLEEP),
        (NM,NM,0),
    ]
        mktempdir() do dir
            seen = Set{String}()
            push!(seen, JSync.sanitize_path(dir))
            JSync.batched_watch_tree(dir; max_events=BATCH_SIZE, sync_period = Inf) do tw
                sleep(1)
                @sync begin
                    @async begin
                        randpathdeep(dir, N; delay)
                        randpathflat(dir, M; delay)
                    end
                    @async try
                        while isopen(tw) 
                            batch = take!(tw)
                            for ev in batch
                                push!(seen, ev.path)
                            end
                            @debug ev.path
                        end
                    catch e
                        e isa InvalidStateException || rethrow()
                    end
                    sleep((N + M) * max(MIN_SLEEP, delay) + 1)
                    close(tw)
                    ps = paths(dir)
                    @debug filter(p -> !(p in ps), seen)
                    @test all(p -> p in ps, seen)
                    @test isempty(tw.tw.watchlist)
                    @test !any(istaskfailed, tw.tw.watchlist)
                end
            end
        end
    end
end

end # module
