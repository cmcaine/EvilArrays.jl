# EvilArrays.jl

Arrays in Julia can start at offsets other than 1. This package provides `EvilArray`, an array type that you can use to make your tests fail if your code makes unsafe assumptions about what its indexes are.

You may be able to fix your code by [following the advice here](https://docs.julialang.org/en/v1/devdocs/offset-arrays/), or by using [`OffsetArrays.no_offset_view`](https://juliaarrays.github.io/OffsetArrays.jl/stable/reference/#OffsetArrays.no_offset_view).

## Usage

Use EvilArrays in your test files, something like this:

```jl
# Function to test
function sum_first_5(A)
    @assert length(A) >= 5
    acc = 0
    for idx in 1:5
        acc += A[idx]
    end
    acc
end

# This test will throw an exception!
@test sum_first_5(1:10) == sum_first_5(EvilArray(1:10))
```

If your function makes bad assumptions about the indices of arrays, then you will likely get a `BoundsError` or the output of your function will change depending on whether you use `EvilArray` or not.

Fix your functions by iterating the array, or using `eachindex` or `axes` or whatever:

```jl
function sum_first_5(A)
    @assert length(A) >= 5
    acc = 0
    for v in Iterators.take(A, 5)
        acc += v
    end
    acc
end

# This test will pass
@test sum_first_5(1:10) == sum_first_5(EvilArray(1:10))
```

## Implementation

EvilArrays are implemented in one line using [OffsetArrays.jl](https://juliaarrays.github.io/OffsetArrays.jl/):

```jl
"""
   EvilArray(A)

Returns a wrapper around an array `A`. The wrapper has the same size and
contents as `A`, but each axis starts at a random large negative offset.

It is intended that these actions will throw an error:

- Indexing with any index that you're likely to see in conventional code
- Broadcasting an `EvilArray` with another array (unless you have taken care to
  match the axes)

Some other indexing mistakes may cause logic errors without throwing an error.
"""
EvilArray(A) = OffsetArray(A, (rand(typemin(Int):typemin(Int)÷2) for _ in 1:ndims(A))...)
```
