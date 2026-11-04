module {
  func.func @kernel_jacobi_2d(%arg0: index, %arg1: memref<?x?xf64>, %arg2: memref<?x?xf64>) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %arg0 step %c1 {
      stencil.apply ins(%arg1 : memref<?x?xf64>) outs(%arg2 : memref<?x?xf64>) offsets [[0, 0], [0, -1], [0, 1], [1, 0], [-1, 0]] scale(2.000000e-01)
      stencil.apply ins(%arg2 : memref<?x?xf64>) outs(%arg1 : memref<?x?xf64>) offsets [[0, 0], [0, -1], [0, 1], [1, 0], [-1, 0]] scale(2.000000e-01)
    }
    return
  }
  func.func @kernel_seidel_2d(%arg0: index, %arg1: memref<?x?xf64>) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg2 = %c0 to %arg0 step %c1 {
      stencil.sweep %arg1 offsets [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1]] divisor(9.000000e+00) : memref<?x?xf64>
    }
    return
  }
}

