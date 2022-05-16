# EvilArrays.jl

`EvilArray` is an AbstractArray that will throw errors if you try to index it without using `eachindex`, `firstindex` or `lastindex`.

The intention is that you can use this array type in your tests to ensure that your code is not making assumptions about the indexes of your arrays.

## Major missing features

Broadcasting doesn't work. Please contribute a PR if you know how to make it work.

## Potentially questionable choices

`similar(EvilArray([1, 2]))` will return a regular array (same as `OffsetArrays`).
