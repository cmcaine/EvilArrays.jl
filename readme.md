# EvilArrays.jl

`EvilArray` is an AbstractArray that will throw errors if you try to index it directly without using `eachindex`, `firstindex` or `lastindex`, `A[begin:end]` or similar.

`EvilArray`s will also throw errors if you try to broadcast with them and another array (scalars will work).

The intention is that you can use this array type in your tests to ensure that your code is not making assumptions about the indexes of your arrays.

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

@test sum_first_5(1:10) == sum_first_5(EvilArray(1:10))
```

If your function makes bad assumptions about the indices of arrays, then you will likely get a `BoundsError` or the output of your function will change depending on whether you use `EvilArray` or not.

Fix your functions by directly iterating the array, or using `eachindex` or `axes` or whatever:

```jl
function sum_first_5(A)
    @assert length(A) >= 5
    acc = 0
    for v in Iterators.take(A, 5)
        acc += v
    end
    acc
end

@test sum_first_5(1:10) == sum_first_5(EvilArray(1:10))
```

## Implementation

EvilArrays are implemented in one line using OffsetArrays.jl:

```jl
"""
   EvilArray(A)

Create a new array of the same size and contents as `A` but with each axis
starting at a random large negative offset.
"""
EvilArray(A) = OffsetArray(A, (rand(typemin(Int):typemin(Int)÷2) for _ in 1:ndims(A))...)
```
