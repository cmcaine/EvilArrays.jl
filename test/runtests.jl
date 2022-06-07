using EvilArrays
using Test

@testset begin
    A = EvilArray([42])

    # Indexing with 1 should break, so 1:length(A) will break.
    @test_throws BoundsError A[1]
    @test_throws BoundsError @inbounds A[1]
    @test collect(A) == [42]

    @test first(A) == 42
    @test A[firstindex(A)] == 42
    @test A[lastindex(A)] == 42

    @test first([A[k] for k in keys(A)]) == 42

    # firstindex(A):lastindex(A) should be legit
    A2 = EvilArray(5:10)
    @test [A2[idx] for idx in firstindex(A2):lastindex(A2)] == 5:10
    @test A2[begin:end] == 5:10

    # Broadcasting works with a scalar
    @test collect(EvilArray(1:10) .+ 1) == 2:11
    # But not with an array with differing indices
    @test_throws DimensionMismatch EvilArray(1:10) .+ (1:10)
    @test_throws DimensionMismatch EvilArray(1:10) .+ EvilArray(1:10)
    @test_throws DimensionMismatch EvilArray(1:10) .+ ones(10,10)
    @test_throws DimensionMismatch EvilArray(1:10) .+ EvilArray(ones(10,10))

    # If you use `similar` or `axes`, then broadcasting should work:
    @test A2 .+ zeros(axes(A2)) == A2
    @test (A2 .+ similar(A2); true) # testing that this does not throw an error
end
