// C reference: slowest/most naive method
// for (i = 0; i < M; i++)
//   for (j = 0; j < N; j++)
//     for (k = 0; k < K; k++)
//       C[i][j] += A[i][k] * B[k][j];

#map_A = affine_map<(d0, d1, d2) -> (d0, d2)>   // A[i][k]
#map_B = affine_map<(d0, d1, d2) -> (d2, d1)>       // B[k][j]
#map_C = affine_map<(d0, d1, d2) -> (d0,d1)>       // C[i][j]

func.func @matmul_generic(%A: memref<?x?xf64>, %B: memref<?x?xf64>, %C: memref<?x?xf64>) {
  linalg.generic {indexing_maps = [#map_A, #map_B, #map_C], 
                  iterator_types = ["parallel", "parallel", "reduction"]} //["parallel", "parallel", "parallel"]
      ins(%A, %B : memref<?x?xf64>, memref<?x?xf64>)
      outs(%C : memref<?x?xf64>) {
  ^bb0(%a: f64, %b: f64, %c: f64):
    %p = arith.mulf %a, %b : f64
    %s = arith.addf %c, %p : f64
    linalg.yield %s : f64
  }
  return
}

func.func @matmul_named(%A: memref<?x?xf64>, %B: memref<?x?xf64>, %C: memref<?x?xf64>) {
      linalg.matmul ins(%A, %B : memref<?x?xf64>, memref<?x?xf64>) outs(%C : memref<?x?xf64>)
  return
}
