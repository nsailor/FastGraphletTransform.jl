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

julia> A = sparse([2, 4, 1, 3, 2, 4, 1, 3], [1, 1, 2, 2, 3, 3, 4, 4], [1 for i = 1:8])
4×4 SparseMatrixCSC{Int64,Int64} with 8 stored entries:
 ⋅  1  ⋅  1
 1  ⋅  1  ⋅
 ⋅  1  ⋅  1
 1  ⋅  1  ⋅

julia> (f, fn) = fglt(A)
Total elapsed time: 0.0000 sec
([1.0 2.0 … 0.0 0.0; 1.0 1.8446744073709552e19 … 0.0 0.0; 1.0 2.0 … 0.0 0.0; 1.0 1.8446744073709552e19 … 0.0 0.0], [1.0 2.0 … 0.0 0.0; 1.0 1.8446744073709552e19 … 0.0 0.0; 1.0 2.0 … 0.0 0.0; 1.0 1.8446744073709552e19 … 0.0 0.0])

julia> f
4×16 Matrix{Float64}:
 1.0  2.0         -2.0         1.0         0.0  …  0.0         6.89921e-310  0.0  0.0  0.0  0.0  0.0  0.0
 1.0  1.84467e19  -1.84467e19  1.70141e38  0.0     1.04618e57  0.0           0.0  0.0  0.0  0.0  0.0  0.0
 1.0  2.0          1.84467e19  1.0         0.0     0.0         6.89921e-310  0.0  0.0  0.0  0.0  0.0  0.0
 1.0  1.84467e19  -1.84467e19  1.70141e38  0.0     1.04618e57  0.0           0.0  0.0  0.0  0.0  0.0  0.0

julia> fn
4×16 Matrix{Float64}:
 1.0  2.0         -2.0         1.0         0.0  …  0.0         6.89921e-310  0.0  0.0  0.0  0.0  0.0  0.0
 1.0  1.84467e19  -1.84467e19  1.70141e38  0.0     1.04618e57  0.0           0.0  0.0  0.0  0.0  0.0  0.0
 1.0  2.0          1.84467e19  1.0         0.0     0.0         6.89921e-310  0.0  0.0  0.0  0.0  0.0  0.0
 1.0  1.84467e19  -1.84467e19  1.70141e38  0.0     1.04618e57  0.0           0.0  0.0  0.0  0.0  0.0  0.0
 ```

