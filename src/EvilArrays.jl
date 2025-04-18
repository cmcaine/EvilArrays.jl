module EvilArrays

export EvilArray

using OffsetArrays

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

end
