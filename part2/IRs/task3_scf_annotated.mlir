module { //untouched
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
    %c-1 = arith.constant -1 : index
    %cst = arith.constant 9.000000e+00 : f64
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg2 = %c0 to %arg0 step %c1 { 
      %dim = memref.dim %arg1, %c0 : memref<?x?xf64>
      %dim_0 = memref.dim %arg1, %c1 : memref<?x?xf64>
      %0 = arith.subi %dim, %c1 : index
      %1 = arith.subi %dim_0, %c1 : index
      scf.for %arg3 = %c1 to %0 step %c1 { //both from c1 to N-1 
        scf.for %arg4 = %c1 to %1 step %c1 {
          %2 = arith.addi %arg3, %c-1 : index
          %3 = arith.addi %arg4, %c-1 : index
          %4 = memref.load %arg1[%2, %3] : memref<?x?xf64>
          %5 = arith.addi %arg3, %c-1 : index
          %6 = memref.load %arg1[%5, %arg4] : memref<?x?xf64>
          %7 = arith.addf %4, %6 : f64
          %8 = arith.addi %arg3, %c-1 : index
          %9 = arith.addi %arg4, %c1 : index
          %10 = memref.load %arg1[%8, %9] : memref<?x?xf64>
          %11 = arith.addf %7, %10 : f64
          %12 = arith.addi %arg4, %c-1 : index
          %13 = memref.load %arg1[%arg3, %12] : memref<?x?xf64>
          %14 = arith.addf %11, %13 : f64
          %15 = memref.load %arg1[%arg3, %arg4] : memref<?x?xf64>
          %16 = arith.addf %14, %15 : f64
          %17 = arith.addi %arg4, %c1 : index
          %18 = memref.load %arg1[%arg3, %17] : memref<?x?xf64>
          %19 = arith.addf %16, %18 : f64
          %20 = arith.addi %arg3, %c1 : index
          %21 = arith.addi %arg4, %c-1 : index
          %22 = memref.load %arg1[%20, %21] : memref<?x?xf64>
          %23 = arith.addf %19, %22 : f64
          %24 = arith.addi %arg3, %c1 : index
          %25 = memref.load %arg1[%24, %arg4] : memref<?x?xf64> //loads follows same order 
          %26 = arith.addf %23, %25 : f64
          %27 = arith.addi %arg3, %c1 : index
          %28 = arith.addi %arg4, %c1 : index
          %29 = memref.load %arg1[%27, %28] : memref<?x?xf64> 
          %30 = arith.addf %26, %29 : f64
          %31 = arith.divf %30, %cst : f64
          memref.store %31, %arg1[%arg3, %arg4] : memref<?x?xf64> //store is at [%arg3, %arg4], in place in %arg1
        }
      }
    }
    return
  }
}

