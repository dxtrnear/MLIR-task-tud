func.func @sweep_by_hand(%A: memref<?x?xf64>) {
%c0 = arith.constant 0 : index
%c1 = arith.constant 1 : index
%c9 = arith.constant 9.000000e+00 : f64
%rows = memref.dim %A, %c0 : memref<?x?xf64>
%cols = memref.dim %A, %c1 : memref<?x?xf64>
%rows_minus_1 = arith.subi %rows, %c1 :index
%cols_minus_1 = arith.subi %cols, %c1 : index
scf.for %i = %c1 to %rows_minus_1 step %c1 {
  %i_minus_1 = arith.subi %i, %c1 : index
  %i_plus_1 = arith.addi %i, %c1 : index

scf.for %j = %c1 to %cols_minus_1 step %c1 {
%j_minus_1 = arith.subi %j, %c1 : index
%j_plus_1 = arith.addi %j, %c1 : index

%v0 = memref.load %A[%i_minus_1, %j_minus_1] : memref<?x?xf64>
%v1 = memref.load %A[%i_minus_1, %j] : memref<?x?xf64>
%s1 = arith.addf %v0, %v1 : f64
%v2 = memref.load %A[%i_minus_1, %j_plus_1] : memref<?x?xf64>
%s2 = arith.addf %s1, %v2 : f64
%v3 = memref.load %A[%i, %j_minus_1] : memref<?x?xf64>
%s3 = arith.addf %s2, %v3 : f64
%v4 = memref.load %A[%i, %j] : memref<?x?xf64>
%s4 = arith.addf %s3, %v4 : f64
%v5 = memref.load %A[%i, %j_plus_1] : memref<?x?xf64>
%s5 = arith.addf %s4, %v5 : f64
%v6 = memref.load %A[%i_plus_1, %j_minus_1] : memref<?x?xf64>
%s6 = arith.addf %s5, %v6 : f64
%v7 = memref.load %A[%i_plus_1, %j] : memref<?x?xf64>
%s7 = arith.addf %s6, %v7 : f64
%v8 = memref.load %A[%i_plus_1, %j_plus_1] : memref<?x?xf64>
%s8 = arith.addf %s7, %v8 : f64
// the remaining seven neighbours
%r = arith.divf %s8, %c9 : f64
memref.store %r, %A[%i, %j] : memref<?x?xf64>
}
}

  return
}
  
