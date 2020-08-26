# FGLT.jl

Julia wrapper for the [Fast Graphlet Transform](https://github.com/fcdimitr/fglt) C++/Cilk implementation.

[![License: MPL-2.0](https://img.shields.io/github/license/NorthSailor/FGLT.jl)](https://www.mozilla.org/en-US/MPL/)

## Installation

This wrapper expects the FGLT shared library to be installed, wich means that you need to build FGLT with Meson as described [here](https://github.com/NorthSailor/fglt#building-with-meson).

Since this package is not in the Julia registry, you need to use the URL of this repository to add it to your Julia environment.
To add the package, open a Julia prompt, enter the `pkg` mode by pressing `]`, and type:

```julia
add https://github.com/NorthSailor/FGLT.jl
```

## Usage

To perform a fast graphlet transform, call the `fglt` function with the adjacency matrix for the graph, for instance:

```julia
julia> using FGLT

julia> using SparseArrays

julia> A = sparse([0 1 0 0 1 0; 1 0 1 1 1 0; 0 1 0 1 1 0; 0 1 1 0 1 1; 1 1 1 1 0 0; 0 0 0 1 0 0])
6×6 SparseMatrixCSC{Int64,Int64} with 18 stored entries:
 ⋅  1  ⋅  ⋅  1  ⋅
 1  ⋅  1  1  1  ⋅
 ⋅  1  ⋅  1  1  ⋅
 ⋅  1  1  ⋅  1  1
 1  1  1  1  ⋅  ⋅
 ⋅  ⋅  ⋅  1  ⋅  ⋅

julia> (f, fn) = fglt(A)
Total elapsed time: 0.0000 sec
([1.0 2.0 … 0.0 0.0; 1.0 4.0 … 5.0 1.0; … ; 1.0 4.0 … 5.0 1.0; 1.0 1.0 … 0.0 0.0], [1.0 2.0 … 0.0 0.0; 1.0 4.0 … 2.0 1.0; … ; 1.0 4.0 … 2.0 1.0; 1.0 1.0 … 0.0 0.0])

julia> f
6×16 Matrix{Float64}:
 1.0  2.0  6.0  1.0  1.0  14.0   4.0  6.0   0.0  6.0   4.0   0.0  2.0  2.0  0.0  0.0
 1.0  4.0  9.0  6.0  4.0  12.0  19.0  7.0   4.0  3.0  12.0   8.0  5.0  3.0  5.0  1.0
 1.0  3.0  9.0  3.0  3.0  14.0  12.0  9.0   1.0  5.0  12.0   3.0  4.0  4.0  3.0  1.0
 1.0  4.0  8.0  6.0  3.0  12.0  18.0  7.0   4.0  5.0  10.0   6.0  4.0  4.0  3.0  1.0
 1.0  4.0  9.0  6.0  4.0  12.0  19.0  7.0   4.0  3.0  12.0   8.0  5.0  3.0  5.0  1.0
 1.0  1.0  3.0  0.0  0.0   8.0   0.0  3.0  -0.0  3.0   0.0  -0.0  0.0  0.0  0.0  0.0

julia> fn
6×16 Matrix{Float64}:
 1.0  2.0  4.0  0.0  1.0  2.0  0.0  0.0  0.0  2.0  0.0  0.0  0.0  2.0  0.0  0.0
 1.0  4.0  1.0  2.0  4.0  0.0  1.0  0.0  0.0  0.0  2.0  1.0  0.0  0.0  2.0  1.0
 1.0  3.0  3.0  0.0  3.0  0.0  0.0  0.0  0.0  0.0  4.0  0.0  0.0  1.0  0.0  1.0
 1.0  4.0  2.0  3.0  3.0  0.0  2.0  0.0  0.0  0.0  2.0  3.0  0.0  1.0  0.0  1.0
 1.0  4.0  1.0  2.0  4.0  0.0  1.0  0.0  0.0  0.0  2.0  1.0  0.0  0.0  2.0  1.0
 1.0  1.0  3.0  0.0  0.0  2.0  0.0  0.0  0.0  3.0  0.0  0.0  0.0  0.0  0.0  0.0

```
