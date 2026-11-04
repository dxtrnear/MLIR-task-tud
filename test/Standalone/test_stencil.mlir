// RUN: standalone-opt %s | standalone-opt | FileCheck %s


// CHECK-LABEL: func.func @kernel_jacobi_2d
func.func @kernel_jacobi_2d(%tsteps: index, %A: memref<?x?xf64>, %B: memref<?x?xf64>) {
%c0 = arith.constant 0 : index
%c1 = arith.constant 1 : index
// CHECK: scf.for
scf.for %t = %c0 to %tsteps step %c1 {
// CHECK: stencil.apply ins(%{{.*}} : memref<?x?xf64>) outs(%{{.*}} : memref<?x?xf64>) offsets {{\[\[}}0, 0], [0, -1], [0, 1], [1, 0], [-1, 0]] scale(2.000000e-01)
stencil.apply ins(%A : memref<?x?xf64>) outs(%B : memref<?x?xf64>)
offsets [[0, 0], [0, -1], [0, 1], [1, 0], [-1, 0]] scale(0.2)
// CHECK: stencil.apply ins(%{{.*}} : memref<?x?xf64>) outs(%{{.*}} : memref<?x?xf64>) offsets {{\[\[}}0, 0], [0, -1], [0, 1], [1, 0], [-1, 0]] scale(2.000000e-01)
stencil.apply ins(%B : memref<?x?xf64>) outs(%A : memref<?x?xf64>)
offsets [[0, 0], [0, -1], [0, 1], [1, 0], [-1, 0]] scale(0.2)

}
return
}
// CHECK-LABEL: func.func @kernel_seidel_2d
func.func @kernel_seidel_2d(%tsteps: index, %A: memref<?x?xf64>) {
%c0 = arith.constant 0 : index
%c1 = arith.constant 1 : index
// CHECK: scf.for
scf.for %t = %c0 to %tsteps step %c1 {
// CHECK: stencil.sweep %{{.*}} offsets {{\[\[}}-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1]] divisor(9.000000e+00) : memref<?x?xf64>
stencil.sweep %A offsets [[-1, -1], [-1, 0], [-1, 1],
[ 0, -1], [ 0, 0], [ 0, 1],
[ 1, -1], [ 1, 0], [ 1, 1]]
divisor(9.0) : memref<?x?xf64>
}
return
}
