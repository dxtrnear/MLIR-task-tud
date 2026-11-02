module {
  func.func @matmul_generic(%arg0: memref<?x?xf64>, %arg1: memref<?x?xf64>, %arg2: memref<?x?xf64>) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %dim = memref.dim %arg0, %c0 : memref<?x?xf64>
    %dim_0 = memref.dim %arg0, %c1 : memref<?x?xf64>
    %dim_1 = memref.dim %arg1, %c1 : memref<?x?xf64>
    scf.for %arg3 = %c0 to %dim step %c1 {
      scf.for %arg4 = %c0 to %dim_1 step %c1 {
        scf.for %arg5 = %c0 to %dim_0 step %c1 {
          %0 = memref.load %arg0[%arg3, %arg5] : memref<?x?xf64>
          %1 = memref.load %arg1[%arg5, %arg4] : memref<?x?xf64>
          %2 = memref.load %arg2[%arg3, %arg4] : memref<?x?xf64>
          %3 = arith.mulf %0, %1 : f64
          %4 = arith.addf %2, %3 : f64
          memref.store %4, %arg2[%arg3, %arg4] : memref<?x?xf64>
        }
      }
    }
    return
  }
  func.func @matmul_named(%arg0: memref<?x?xf64>, %arg1: memref<?x?xf64>, %arg2: memref<?x?xf64>) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %dim = memref.dim %arg0, %c0 : memref<?x?xf64>
    %dim_0 = memref.dim %arg0, %c1 : memref<?x?xf64>
    %dim_1 = memref.dim %arg1, %c1 : memref<?x?xf64>
    scf.for %arg3 = %c0 to %dim step %c1 {
      scf.for %arg4 = %c0 to %dim_1 step %c1 {
        scf.for %arg5 = %c0 to %dim_0 step %c1 {
          %0 = memref.load %arg0[%arg3, %arg5] : memref<?x?xf64>
          %1 = memref.load %arg1[%arg5, %arg4] : memref<?x?xf64>
          %2 = memref.load %arg2[%arg3, %arg4] : memref<?x?xf64>
          %3 = arith.mulf %0, %1 : f64
          %4 = arith.addf %2, %3 : f64
          memref.store %4, %arg2[%arg3, %arg4] : memref<?x?xf64>
        }
      }
    }
    return
  }
}

