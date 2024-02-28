import numpy as np
from scipy.sparse import isspmatrix_csc, isspmatrix_coo
from juliacall import Main as jl

def fglt(A):
    if isspmatrix_coo(A):
        array_jl = jl.SparseArrays.sparse(jl.Array(A.row+1), jl.Array(A.col+1), jl.Array(A.data), A.shape[0], A.shape[1])
    elif isspmatrix_csc(A):
        # TODO: better way to do this, without duplicating the matrix
        A = A.tocoo()
        array_jl = jl.SparseArrays.sparse(jl.Array(A.row+1), jl.Array(A.col+1), jl.Array(A.data), A.shape[0], A.shape[1])
    else:
        raise ValueError('Input must be a sparse matrix in CSC or COO format')
    
    # Check that input is symmetric matrix
    if (A != A.T).nnz != 0:
        raise ValueError('Input graph must be undirected, i.e., the adjacency matrix must be symmetric')

    # Check that input matrix is binary(only 1s and 0s)
    if not all(A.data == 1):
        raise ValueError('Input graph must be unweighted, i.e., the adjacency matrix must be binary')

    # Check that input matrix is zero in the diagonal
    if A.diagonal().any():
        raise ValueError('We do not allow self loops, i.e., the adjacency matrix must be zero in the diagonal')

    f1, f2 = jl.fglt(array_jl)
    f1 = np.array( f1, dtype=np.int64 )
    f2 = np.array( f2, dtype=np.int64 )

    return f1, f2
