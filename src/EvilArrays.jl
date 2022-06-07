module EvilArrays

export EvilArray

using OffsetArrays

# Create a new offset array of the same size but with each axis starting at a random large negative offset.
EvilArray(A) = OffsetArray(A, (rand(typemin(Int):typemin(Int)÷2) for _ in 1:ndims(A))...)

end
