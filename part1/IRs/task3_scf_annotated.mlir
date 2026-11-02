module { // %arg0 = A (M x K), %arg1 = B (K x N), %arg2 = C (M x N) and sizes are read at run time

  func.func @matmul_generic(%arg0: memref<?x?xf64>, %arg1: memref<?x?xf64>, %arg2: memref<?x?xf64>) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %dim = memref.dim %arg0, %c0 : memref<?x?xf64> //M
    %dim_0 = memref.dim %arg0, %c1 : memref<?x?xf64> //K
    %dim_1 = memref.dim %arg1, %c1 : memref<?x?xf64> //N
    scf.for %arg3 = %c0 to %dim step %c1 { // i loop
      scf.for %arg4 = %c0 to %dim_1 step %c1 { // j loop
        scf.for %arg5 = %c0 to %dim_0 step %c1 { // k loop
          %0 = memref.load %arg0[%arg3, %arg5] : memref<?x?xf64> // A[i][k]
          %1 = memref.load %arg1[%arg5, %arg4] : memref<?x?xf64> // B[k][j]
          %2 = memref.load %arg2[%arg3, %arg4] : memref<?x?xf64> // C[i][j]
          %3 = arith.mulf %0, %1 : f64 // A[i][k] * B[k][j]
          %4 = arith.addf %2, %3 : f64 // C[i][j] += A[i][k] * B[k][j]
          memref.store %4, %arg2[%arg3, %arg4] : memref<?x?xf64> // store result back to C[i][j]
        }
      }
    }
    return
  }