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

Sources:
https://www.stephendiehl.com/posts/mlir_linear_algebra/
https://github.com/AlexandreSinger/mlir-beginner-friendly-tutorial