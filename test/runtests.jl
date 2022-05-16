using EvilArrays
using Test

@testset begin
    A = EvilArray([42])

    @test_throws KeyError A[1]
    @test collect(A) == [42]

    @test first(A) == 42
    @test A[firstindex(A)] == 42
    @test A[lastindex(A)] == 42

    @test [A[k] for k in keys(A)] == [42]

    # Don't know why broadcasting is broken and don't know how to fix it.
    @test_broken EvilArray(1:10) .+ 1
end
