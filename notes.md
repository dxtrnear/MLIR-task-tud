1) no enough space on the mac, so external ssd: mine is formatted exFAT so doesn't support symbolic links (which llvm build and install rely on), so I create an APFS disk image on the SSD. (single growing file on the exFAT drive) 
bash:
hdiutil create -size 40g -type SPARSEBUNDLE -fs APFS -volname mlirwork /Volumes/Transcend/mlir_task/mlirwork.sparsebundle
hdiutil attach /Volumes/Transcend/mlir_task/mlirwork.sparsebundle
sudo mdutil -i off /Volumes/mlirwork

2) to ensure reproductibility evtng will stay as dybamic variables on scripts (set jobs hardly to 6 but could be modified voa script)

3) adding this to gitignore (mac specific fil): .DS_Store (!remember to delete also .o ... )

4) to make it easier: export PATH=/Volumes/mlirwork/llvm-install/bin:$PATH

PART 1: 
using a pass:
func.func @matmul_named(%arg0: memref<?x?xf64>, %arg1: memref<?x?xf64>, %arg2: memref<?x?xf64>) {
    linalg.generic {indexing_maps = [#map, #map1, #map2], iterator_types = ["parallel", "parallel", "reduction"]} ins(%arg0, %arg1 : memref<?x?xf64>, memref<?x?xf64>) outs(%arg2 : memref<?x?xf64>) {
    ^bb0(%in: f64, %in_0: f64, %out: f64):
      %0 = arith.mulf %in, %in_0 : f64
      %1 = arith.addf %out, %0 : f64
      linalg.yield %1 : f64
    }
    return
  }
}


Q1 and Q2 see .mlir and paper report
Q3 mlir-opt only verifies if all good in syntax mapping operands... a bad iterator types doesnt raise an error

for finding passes: mlir.llvm.org/docs/Passes and mlir-opt --help with a grep (--canonicalize and --cse are two general cleanup passes)
commands:
mlir-opt part1/matmul.mlir --convert-linalg-to-affine-loops -o part1/IRs/generated/task3_affine.mlir


!! apparently the generated IRs after a pass could be ovverode if annotated so maybe putting generated appart

q6: matmul_named was ignored 
macbookair@Big-Yass-Macbook MLIR-task-tud % mlir-opt part1/matmul_interchange.mlir --transform-interpreter
#map = affine_map<(d0, d1, d2) -> (d0, d1)>
#map1 = affine_map<(d0, d1, d2) -> (d1, d2)>
#map2 = affine_map<(d0, d1, d2) -> (d0, d2)>
module {
  func.func @matmul_generic(%arg0: memref<?x?xf64>, %arg1: memref<?x?xf64>, %arg2: memref<?x?xf64>) {
    linalg.generic {indexing_maps = [#map, #map1, #map2], iterator_types = ["parallel", "reduction", "parallel"]} ins(%arg0, %arg1 : memref<?x?xf64>, memref<?x?xf64>) outs(%arg2 : memref<?x?xf64>) {
    ^bb0(%in: f64, %in_0: f64, %out: f64):
      %0 = arith.mulf %in, %in_0 : f64
      %1 = arith.addf %out, %0 : f64
      linalg.yield %1 : f64
    }
    return
  }
  func.func @matmul_named(%arg0: memref<?x?xf64>, %arg1: memref<?x?xf64>, %arg2: memref<?x?xf64>) {
    linalg.matmul ins(%arg0, %arg1 : memref<?x?xf64>, memref<?x?xf64>) outs(%arg2 : memref<?x?xf64>)
    return
  }
  module attributes {transform.with_named_sequence} {
    transform.named_sequence @__transform_main(%arg0: !transform.any_op {transform.readonly}) {
      %0 = transform.structured.match ops{["linalg.generic"]} in %arg0 : (!transform.any_op) -> !transform.any_op
      %1 = transform.structured.interchange %0 iterator_interchange = [0, 2, 1] : (!transform.any_op) -> !transform.any_op
      transform.yield 
    }
  }
  module attributes {transform.with_named_sequence} {
    transform.named_sequence @__transform_main(%arg0: !transform.any_op {transform.readonly}) {
      %0 = transform.structured.match ops{["linalg.matmul"]} in %arg0 : (!transform.any_op) -> !transform.any_op
      %1 = transform.structured.interchange %0 iterator_interchange = [0, 2, 1] : (!transform.any_op) -> !transform.any_op
      transform.yield 
    }
  }
}

part2 notes:
Q9: for jacobi we'rre computing additions on B buffer (for example) adding 5 values coming from A buffer at (i,j),(i,j-1),(i,j+1),(i+1,j),(i-1,j), the order in which the cells (i, j) are computed doesn’t matter since we're reading from A (where we write nothing) and writing in B 
parallel in linalg.generic promises that the loop can run in any order (or at the sae time) with the same result and since there is no dependance between iterations in this case, then parallel works here and won't compromise result
(the condition is A and B must be different buffers if stencil.apply is applies on ins(%a) outs(%a) the argument would break)

q10 for seindel: we're writing and reading on the same buffer 
to compute (i, j), we read the cells that iterations (i-1, j-1), (i-1, j), (i-1, j+1) and (i, j-1) wrote earlier in the same sweep what makes it a read-after-write, and a loop carried dependance so the paralllel in linalg.generic could for example run the cells in an order where all reads are before any write which will false the results (the other 4 neighboors will be read in their old values write-after-read)

for verifier, only implementing verify offset + making sure we cant pass the same buffer twice on apply (so parallel stay possible in jacobi)

naming constraints:
grep -n "MemRefRankOf\|class Arg" /Volumes/mlirwork/llvm-install/include/mlir/IR/CommonTypeConstraints.td /Volumes/mlirwork/llvm-install/include/mlir/IR/Constraints.td
grep -n "TypedArrayAttrBase\|def I64ArrayAttr\|def F64Attr" /Volumes/mlirwork/llvm-install/include/mlir/IR/CommonAttrConstraints.td

Sources:
https://www.stephendiehl.com/posts/mlir_linear_algebra/
https://github.com/AlexandreSinger/mlir-beginner-friendly-tutorial
https://llvm.org/devmtg/2021-02-28/slides/Vinay-MLIR-loopnest.pdf
llvm-project/mlir/test/Dialect/Linalg/transform-op-interchange.mlir
https://github.com/llvm/llvm-project/blob/main/mlir/docs/TargetLLVMIR.md