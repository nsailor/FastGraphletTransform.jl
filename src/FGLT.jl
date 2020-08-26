module FGLT

using SparseArrays

export fglt

"""
    FGLT.workers()

Get the number of workers available to the FGLT implementation.
"""
workers() = ccall((:getWorkers, "libfglt"), Cint, ())

"""
    fglt(A::SparseMatrixCSC{F, I})

Perform the Fast Graphlet Transform (FGLT) on a graph described by the given adjacency
matrix `A` and return a tuple with the raw and net frequency matrices (`f` and `fnet` of size `n` by 16),
where `n` is the number of nodes in the graph.

The computed frequencies correspond to the following graphlets:

| sigma | Description |
|:---:|:---|
| 0 | singleton |
| 1 | 1-path, at an end |
| 2 | 2-path, at an end |
| 3 | bi-fork, at the root |
| 4 | 3-clique, at any node |
| 5 | 3-path, at an end |
| 6 | 3-path, at an interior node |
| 7 | claw, at a leaf |
| 8 | claw, at the root |
| 9 | dipper, at the handle tip |
| 10 | dipper, at a base node |
| 11 | dipper, at the center |
| 12 | 4-cycle, at any node |
| 13 | diamond, at an off-cord node |
| 14 | diamond, at an on-cord node 14 |
| 15 | 4-clique, at any node |
"""
function fglt(A::SparseMatrixCSC)
    (n, m) = size(A)

    (n == m) || error("The adjacency matrix A must be square.")

    # Allocate the output matrices as arrays-of-pointers.
    f = [zeros(n) for i = 1:16]
    fn = copy(f)

    ii = A.colptr
    jStart = A.rowval

    # The number of edges is half the number of non-zero entries.
    m = div(nnz(A), 2)

    np = workers()

    ccall((:compute, "libfglt"), Cvoid,
          (Ptr{Ptr{Cdouble}},
           Ptr{Ptr{Cdouble}},
           Ptr{Csize_t},
           Ptr{Csize_t},
           Csize_t,
           Csize_t,
           Csize_t),
          f, fn, ii, jStart, m, n, np)

    # Convert the arrays-of-pointers into dense Julia matrices
    f = foldl(hcat, f)
    fn = foldl(hcat, fn)

    (f, fn)
end

end # module
