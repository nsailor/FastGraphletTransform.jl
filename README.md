# FGLT.jl

Julia wrapper for the [Fast Graphlet Transform](https://github.com/fcdimitr/fglt) C++/Cilk implementation.

[![Build Status](https://github.com/fcdimitr/FGLT.jl/workflows/CI/badge.svg)](https://github.com/nsailor/FGLT.jl/actions)
[![Coverage](https://codecov.io/gh/fcdimitr/FGLT.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/nsailor/FGLT.jl)
[![License: MPL-2.0](https://img.shields.io/badge/License-MPLv2-blue)](https://www.mozilla.org/en-US/MPL/)

## Installation

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

julia> f # Raw frequencies (n x 16)
6×16 Matrix{Int64}:
 1  2  6  1  1  14   4  6  0  6   4  0  2  2  0  0
 1  4  9  6  4  12  19  7  4  3  12  8  5  3  5  1
 1  3  9  3  3  14  12  9  1  5  12  3  4  4  3  1
 1  4  8  6  3  12  18  7  4  5  10  6  4  4  3  1
 1  4  9  6  4  12  19  7  4  3  12  8  5  3  5  1
 1  1  3  0  0   8   0  3  0  3   0  0  0  0  0  0

julia> fn # Net frequencies (n x 16)
6×16 Matrix{Int64}:
 1  2  4  0  1  2  0  0  0  2  0  0  0  2  0  0
 1  4  1  2  4  0  1  0  0  0  2  1  0  0  2  1
 1  3  3  0  3  0  0  0  0  0  4  0  0  1  0  1
 1  4  2  3  3  0  2  0  0  0  2  3  0  1  0  1
 1  4  1  2  4  0  1  0  0  0  2  1  0  0  2  1
 1  1  3  0  0  2  0  0  0  3  0  0  0  0  0  0
```
