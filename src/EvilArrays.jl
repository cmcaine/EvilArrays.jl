module EvilArrays

export EvilArray

import Base: size, length, getindex, eachindex, show, iterate, lastindex, keys, IndexStyle

struct EvilArray{T, N, P<:AbstractArray{T, N}} <: AbstractArray{T, N}
    a::P
end

struct EvilArrayIndex{T}
    i::T
end

## Methods documented to be part of the interface

size(a::EvilArray) = size(a.a)

getindex(a::EvilArray, inds...) = throw(KeyError(inds))
getindex(a::EvilArray, inds::EvilArrayIndex...) = getindex(a.a, (i.i for i in inds)...)

setindex!(a::EvilArray, v, inds...) = throw(KeyError(inds))
setindex!(a::EvilArray, v, inds::EvilArrayIndex...) = setindex!(a.a, v, (i.i for i in inds)...)

## Methods required to actually iterate the thing

# IndexStyle doesn't work, dunno why.
# IndexStyle(::Type{<:EvilArray{T, N, P}}) where {T, N, P} = IndexStyle(P)
eachindex(a::EvilArray) = [EvilArrayIndex(i) for i in eachindex(a.a)]
eachindex(::IndexLinear, a::EvilArray) = [EvilArrayIndex(i) for i in eachindex(IndexLinear(), a.a)]
eachindex(::IndexCartesian, a::EvilArray) = [EvilArrayIndex(i) for i in eachindex(IndexCartesian(), a.a)]

# default firstindex method works.
lastindex(a::EvilArray) = EvilArrayIndex(lastindex(a.a))

## Other methods that AbstractArray defines in ways incompatible with us

keys(a::EvilArray) = eachindex(a)
# broadcasting is broken too, idk how to fix.

# AbstractArray show methods try to index at 1
show(io::IO, a::EvilArray) = print(io, "EvilArray(", a.a, ")")
show(io::IO, mime::MIME"text/plain", a::EvilArray) = print(io, "EvilArray(", a.a, ")")

end # module
