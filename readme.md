# EvilArrays.jl

`EvilArray` is an AbstractArray that will throw errors if you try to index it directly without using `eachindex`, `firstindex` or `lastindex`, `A[begin:end]` or similar.

`EvilArray`s will also throw errors if you try to broadcast with them and another array (scalars will work).

The intention is that you can use this array type in your tests to ensure that your code is not making assumptions about the indexes of your arrays.

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
