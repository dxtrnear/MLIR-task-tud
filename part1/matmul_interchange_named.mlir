
func.func @matmul_named_interchanged(%A: memref<?x?xf64>, %B: memref<?x?xf64>, %C: memref<?x?xf64>) {
      linalg.matmul ins(%A, %B : memref<?x?xf64>, memref<?x?xf64>) outs(%C : memref<?x?xf64>)
  return
}



module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(%arg1: !transform.any_op {transform.readonly}) {
    %0 = transform.structured.match ops{["linalg.matmul"]} in %arg1 : (!transform.any_op) -> !transform.any_op
    transform.structured.interchange %0 iterator_interchange = [0, 2, 1] : (!transform.any_op) -> !transform.any_op
    transform.yield
  }
}

// error when trying to apply :
// part1/matmul_interchange_named.mlir:12:5: error: transform applied to the wrong op kind
//     transform.structured.interchange %0 iterator_interchange = [0, 2, 1] : (!transform.any_op) -> !transform.any_op
//     ^
// part1/matmul_interchange_named.mlir:3:7: note: when applied to this op
//       linalg.matmul ins(%A, %B : memref<?x?xf64>, memref<?x?xf64>) outs(%C : memref<?x?xf64>)
