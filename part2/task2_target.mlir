#id = affine_map<(d0, d1) -> (d0, d1)>

func.func @apply_by_hand(%A: memref<?x?xf64>, %B: memref<?x?xf64>) {
%c0 = arith.constant 0 : index
%c1 = arith.constant 1 : index
%c2 = arith.constant 2 : index
%N = memref.dim %B, %c0 : memref<?x?xf64>   // number of rows
%M = memref.dim %B, %c1 : memref<?x?xf64>   // number of columns
%n = arith.subi %N, %c2 : index             // interior rows    = N - 2
%m = arith.subi %M, %c2 : index             // interior columns = M - 2
// One shifted view of A per neighbour, each the size of the interior.
%v0 = memref.subview %A[1, 1] [%n, %m] [1, 1] :memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>> // A[i][j]
%v1 = memref.subview %A[1, 0] [%n, %m] [1, 1] :memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>> // A[i][j-1]
%v2 = memref.subview %A[1, 2] [%n, %m] [1, 1] :memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>> // A[i][j+1]
%v3 = memref.subview %A[2, 1] [%n, %m] [1, 1] :memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>> // A[i+1][j]
%v4 = memref.subview %A[0, 1] [%n, %m] [1, 1] :memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: 1>>  // A[i-1][j]   offset known at compile time
%out = memref.subview %B[1, 1] [%n, %m] [1, 1] :memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>> // interior of B
%cst = arith.constant 2.000000e-01 : f64
linalg.generic {indexing_maps = [#id, #id, #id, #id, #id, #id],
iterator_types = ["parallel", "parallel"]}
ins(%v0, %v1, %v2, %v3, %v4 : memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: 1>>) outs(%out : memref<?x?xf64, strided<[?, 1], offset: ?>>) {
^bb0(%x0: f64, %x1: f64, %x2: f64, %x3: f64, %x4: f64, %o: f64):
%s1 = arith.addf %x0, %x1 : f64
%s2 = arith.addf %s1, %x2 : f64
%s3 = arith.addf %s2, %x3 : f64
%s4 = arith.addf %s3, %x4 : f64
%r  = arith.mulf %s4, %cst : f64 // %cst = 0.2
linalg.yield %r : f64
}
  return
}

