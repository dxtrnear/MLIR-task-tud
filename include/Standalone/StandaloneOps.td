//===- StandaloneOps.td - Standalone dialect ops -----------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef STANDALONE_OPS
#define STANDALONE_OPS

include "StandaloneDialect.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

def Stencil_ApplyOp : Standalone_Op<"apply", []> {
    let summary = "Computes one our of place pass";
    let description = [{
        ```mlir
stencil.apply ins(%A : memref<?x?xf64>) outs(%B : memref<?x?xf64>)
offsets [[0, 0], [0, -1], [0, 1], [1, 0], [-1, 0]] scale(0.2)
        ```
    }];

    let arguments = (ins
    Arg<MemRefRankOf<[F64], [2]>, "grid read", [MemRead]>:$input,
    Arg<MemRefRankOf<[F64], [2]>, "grid written", [MemWrite]>:$output,
    TypedArrayAttrBase<I64ArrayAttr, "list of 2D offsets">:$offsets,
    F64Attr:$scale
    );
    let assemblyFormat = [{
        `ins` `(` $input `:` type($input) `)`
        `outs` `(` $output `:` type($output) `)`
        `offsets` $offsets `scale` `(` $scale `)` attr-dict
    }];

    let hasVerifier = 1;
}

def Stencil_SweepOp : Standalone_Op<"sweep", []> {
    let summary = "Computes one in place pass in lexographic order, with the first dimension outermost";
    let description = [{
        ```mlir
stencil.sweep %A offsets [[-1, -1], [-1, 0], [-1, 1],
[ 0, -1], [ 0, 0], [ 0, 1],
[ 1, -1], [ 1, 0], [ 1, 1]]
divisor(9.0) : memref<?x?xf64>
        ```
    }];

    let arguments = (ins
        Arg<MemRefRankOf<[F64], [2]>, "grid read and written in place", [MemRead, MemWrite]>:$grid,
        TypedArrayAttrBase<I64ArrayAttr, "list of 2D offsets">:$offsets,
        F64Attr:$divisor
    );

    let assemblyFormat = [{
        $grid `offsets` $offsets `divisor` `(` $divisor `)` attr-dict `:` type($grid)
    }];
    let hasVerifier = 1;

}

/*
def Standalone_FooOp : Standalone_Op<"foo", [Pure,
                                             SameOperandsAndResultType]> {
    let summary = "Illustrates how to define an operation.";
    let description = [{
        The `standalone.foo` operation illustrates how to define a new
        operation in a dialect. It uses an operation trait to declare that it
        has no side effects.

        This operation takes an integer argument and returns an integer.

        Example:

        ```mlir
        %0 = arith.constant 2 : i32
        // Apply the foo operation to %0
        %1 = standalone.foo %0 : i32
        ```
    }];

    let arguments = (ins I32:$input);
    let results = (outs I32:$res);

    let assemblyFormat = [{
        $input attr-dict `:` type($input)
    }];
}
*/
#endif // STANDALONE_OPS
