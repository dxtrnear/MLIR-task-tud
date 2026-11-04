//just to test the verifier on offsets and same memeref on apply

func.func @bad(%A: memref<?x?xf64>, %B: memref<?x?xf64>) {
  stencil.apply ins(%A : memref<?x?xf64>) outs(%A : memref<?x?xf64>) offsets [[0, 0]] scale(0.2)
  return
}

// func.func @kernel_seidel_2d_bad(%tsteps: index, %A: memref<?x?xf64>) {
// %c0 = arith.constant 0 : index
// %c1 = arith.constant 1 : index
// scf.for %t = %c0 to %tsteps step %c1 {
// stencil.sweep %A offsets [[-1, -1], [-1, 0], [-1, 1],
// [ 0, -1], [ 0, 0], [ 0, 1, 1],
// [ 1, -1], [ 1, 0], [ 1, 1]]
// divisor(9.0) : memref<?x?xf64>
// }
// return
// }