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

for the handwritten version :
macbookair@Big-Yass-Macbook MLIR-task-tud % mlir-opt part2/task2_target.mlir --convert-linalg-to-loops
module {
  func.func @apply_by_hand(%arg0: memref<?x?xf64>, %arg1: memref<?x?xf64>) {
    %cst = arith.constant 2.000000e-01 : f64
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c2 = arith.constant 2 : index
    %dim = memref.dim %arg1, %c0 : memref<?x?xf64>
    %dim_0 = memref.dim %arg1, %c1 : memref<?x?xf64>
    %0 = arith.subi %dim, %c2 : index
    %1 = arith.subi %dim_0, %c2 : index
    %subview = memref.subview %arg0[1, 1] [%0, %1] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
    %subview_1 = memref.subview %arg0[1, 0] [%0, %1] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
    %subview_2 = memref.subview %arg0[1, 2] [%0, %1] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
    %subview_3 = memref.subview %arg0[2, 1] [%0, %1] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
    %subview_4 = memref.subview %arg0[0, 1] [%0, %1] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: 1>>
    %subview_5 = memref.subview %arg1[1, 1] [%0, %1] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
    scf.for %arg2 = %c0 to %0 step %c1 {
      scf.for %arg3 = %c0 to %1 step %c1 {
        %2 = memref.load %subview[%arg2, %arg3] : memref<?x?xf64, strided<[?, 1], offset: ?>>
        %3 = memref.load %subview_1[%arg2, %arg3] : memref<?x?xf64, strided<[?, 1], offset: ?>>
        %4 = memref.load %subview_2[%arg2, %arg3] : memref<?x?xf64, strided<[?, 1], offset: ?>>
        %5 = memref.load %subview_3[%arg2, %arg3] : memref<?x?xf64, strided<[?, 1], offset: ?>>
        %6 = memref.load %subview_4[%arg2, %arg3] : memref<?x?xf64, strided<[?, 1], offset: 1>>
        %7 = arith.addf %2, %3 : f64
        %8 = arith.addf %7, %4 : f64
        %9 = arith.addf %8, %5 : f64
        %10 = arith.addf %9, %6 : f64
        %11 = arith.mulf %10, %cst : f64
        memref.store %11, %subview_5[%arg2, %arg3] : memref<?x?xf64, strided<[?, 1], offset: ?>>
      }
    }
    return
  }
}

T-he bounds are 0 to %0 (= N-2), not 1 to N-1. The loops run over window coordinates.
-Every load is at [%arg2, %arg3], the same index for all 5. No j-1, no i+1 anywhere. The shifts are hidden in the windows’ offsets: %subview_1 starts one column to the left, so its [i, j] is A’s [1+i, j].
-There’s no load of %o. Linalg saw that the body never uses the output’s old value, so it doesn’t read it. Only the store remains.

on task3 %arg3 + %c-1 is computed 3 times theres the -cse to delete common subexpression

for task4 we'll need --expand-strided-metadata (previous lowering still contains stride so this lowes it to arith ops)
Sources:
https://www.stephendiehl.com/posts/mlir_linear_algebra/
https://github.com/AlexandreSinger/mlir-beginner-friendly-tutorial
https://llvm.org/devmtg/2021-02-28/slides/Vinay-MLIR-loopnest.pdf
llvm-project/mlir/test/Dialect/Linalg/transform-op-interchange.mlir
https://github.com/llvm/llvm-project/blob/main/mlir/docs/TargetLLVMIR.md
https://github.com/IITH-Compilers/PolyBench-NN/blob/master/stencils/jacobi-2d/jacobi-2d.c