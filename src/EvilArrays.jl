module EvilArrays

export EvilArray

using OffsetArrays

"""
   EvilArray(A)

Create a new array of the same size and contents as `A` but with each axis
starting at a random large negative offset.
"""
EvilArray(A) = OffsetArray(A, (rand(typemin(Int):typemin(Int)÷2) for _ in 1:ndims(A))...)

end
