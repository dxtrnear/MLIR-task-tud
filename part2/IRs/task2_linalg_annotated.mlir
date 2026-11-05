//Same blocks against handwritten one, same order (dim, subi, 6 subviews, linalg.generic with 6 maps)

#map = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @kernel_jacobi_2d(%arg0: index, %arg1: memref<?x?xf64>, %arg2: memref<?x?xf64>) {
    %cst = arith.constant 2.000000e-01 : f64 //constatnnts moved at the top
    %c2 = arith.constant 2 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %arg0 step %c1 {
      %dim = memref.dim %arg2, %c0 : memref<?x?xf64>
      %dim_0 = memref.dim %arg2, %c1 : memref<?x?xf64>
      %0 = arith.subi %dim, %c2 : index
      %1 = arith.subi %dim_0, %c2 : index
      %subview = memref.subview %arg1[1, 1] [%0, %1] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_1 = memref.subview %arg1[1, 0] [%0, %1] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_2 = memref.subview %arg1[1, 2] [%0, %1] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_3 = memref.subview %arg1[2, 1] [%0, %1] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_4 = memref.subview %arg1[0, 1] [%0, %1] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: 1>>
      %subview_5 = memref.subview %arg2[1, 1] [%0, %1] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      linalg.generic {indexing_maps = [#map, #map, #map, #map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%subview, %subview_1, %subview_2, %subview_3, %subview_4 : memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: 1>>) outs(%subview_5 : memref<?x?xf64, strided<[?, 1], offset: ?>>) {
      //first one reads A and writes to B, second one reads B and writes to A
      ^bb0(%in: f64, %in_14: f64, %in_15: f64, %in_16: f64, %in_17: f64, %out: f64):
        %4 = arith.addf %in, %in_14 : f64
        %5 = arith.addf %4, %in_15 : f64
        %6 = arith.addf %5, %in_16 : f64
        %7 = arith.addf %6, %in_17 : f64 //adds in correct order
        %8 = arith.mulf %7, %cst : f64 //then multiplies by constant
        linalg.yield %8 : f64
      }
      %dim_6 = memref.dim %arg1, %c0 : memref<?x?xf64>
      %dim_7 = memref.dim %arg1, %c1 : memref<?x?xf64>
      %2 = arith.subi %dim_6, %c2 : index
      %3 = arith.subi %dim_7, %c2 : index
      %subview_8 = memref.subview %arg2[1, 1] [%2, %3] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_9 = memref.subview %arg2[1, 0] [%2, %3] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_10 = memref.subview %arg2[1, 2] [%2, %3] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_11 = memref.subview %arg2[2, 1] [%2, %3] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_12 = memref.subview %arg2[0, 1] [%2, %3] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: 1>>
      %subview_13 = memref.subview %arg1[1, 1] [%2, %3] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      linalg.generic {indexing_maps = [#map, #map, #map, #map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%subview_8, %subview_9, %subview_10, %subview_11, %subview_12 : memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: 1>>) outs(%subview_13 : memref<?x?xf64, strided<[?, 1], offset: ?>>) {
      ^bb0(%in: f64, %in_14: f64, %in_15: f64, %in_16: f64, %in_17: f64, %out: f64):
        %4 = arith.addf %in, %in_14 : f64
        %5 = arith.addf %4, %in_15 : f64
        %6 = arith.addf %5, %in_16 : f64
        %7 = arith.addf %6, %in_17 : f64
        %8 = arith.mulf %7, %cst : f64
        linalg.yield %8 : f64
      }
    }
    return
  }
  //untouched 
  func.func @kernel_seidel_2d(%arg0: index, %arg1: memref<?x?xf64>) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg2 = %c0 to %arg0 step %c1 {
      stencil.sweep %arg1 offsets [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1]] divisor(9.000000e+00) : memref<?x?xf64>
    }
    return
  }
}

