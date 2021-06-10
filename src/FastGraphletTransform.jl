module FastGraphletTransform

using SparseArrays, FGlT_jll

export fglt

"""
    FastGraphletTransform.workers()

Get the number of workers available to the FGLT implementation.
"""
workers() = ccall((:getWorkers, libfglt), Cint, ())

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
    (A.n == A.m) || error("The adjacency matrix A must be square.")
    n = A.n

    f = zeros(Cdouble, n, 16)
    fn = zeros(Cdouble, n, 16)

    ii = A.rowval .- 1
    jStart = A.colptr .- 1

    # The number of edges is the number of non-zero entries
    m = nnz(A)

    np = workers()

    GC.@preserve f fn ii jStart begin
        ccall((:compute, libfglt), Cvoid,
              (Ptr{Ptr{Cdouble}},
               Ptr{Ptr{Cdouble}},
               Ptr{Csize_t},
               Ptr{Csize_t},
               Csize_t,
               Csize_t,
               Csize_t),
              f, fn, ii, jStart, n, m, np)
    end

    # Frequencies can only be integers.
    # Will throw an InexactError if we somehow get a decimal.
    (convert.(Int, f), convert.(Int, fn))
end

# See: https://stackoverflow.com/questions/33003174/calling-a-c-function-from-julia-and-passing-a-2d-array-as-a-pointer-of-pointers
Base.cconvert(::Type{Ptr{Ptr{Cdouble}}},xx2::Matrix{Cdouble})=Ref{Ptr{Cdouble}}([Ref(xx2,i) for i=1:size(xx2,1):length(xx2)])

end # module
