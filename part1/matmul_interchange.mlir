#map_A = affine_map<(d0, d1, d2) -> (d0, d2)>   // A[i][k]
#map_B = affine_map<(d0, d1, d2) -> (d2, d1)>       // B[k][j]
#map_C = affine_map<(d0, d1, d2) -> (d0,d1)>       // C[i][j]

func.func @matmul_generic_interchanged(%A: memref<?x?xf64>, %B: memref<?x?xf64>, %C: memref<?x?xf64>) {
  linalg.generic {indexing_maps = [#map_A, #map_B, #map_C], 
                  iterator_types = ["parallel", "parallel", "reduction"]} //?? 
      ins(%A, %B : memref<?x?xf64>, memref<?x?xf64>)
      outs(%C : memref<?x?xf64>) {
  ^bb0(%a: f64, %b: f64, %c: f64):
    %p = arith.mulf %a, %b : f64
    %s = arith.addf %c, %p : f64
    linalg.yield %s : f64
  }
  return
}

module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(%arg1: !transform.any_op {transform.readonly}) {
    %0 = transform.structured.match ops{["linalg.generic"]} in %arg1 : (!transform.any_op) -> !transform.any_op
    transform.structured.interchange %0 iterator_interchange = [0, 2, 1] : (!transform.any_op) -> !transform.any_op
    transform.yield
  }
}

