//===- StandaloneDialect.td - Standalone dialect -----------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef STANDALONE_DIALECT
#define STANDALONE_DIALECT

include "mlir/IR/OpBase.td"

//===----------------------------------------------------------------------===//
// Standalone dialect definition.
//===----------------------------------------------------------------------===//

def Standalone_Dialect : Dialect {
    let name = "stencil";
    let summary = "A stencil updates each grid point using a set of neighbooring values";
    let description = [{
        This dialect is defined for the task.
    }];
    let cppNamespace = "::mlir::standalone";
}

//===----------------------------------------------------------------------===//
// Base standalone operation definition.
//===----------------------------------------------------------------------===//

class Standalone_Op<string mnemonic, list<Trait> traits = []> :
        Op<Standalone_Dialect, mnemonic, traits>;

#endif // STANDALONE_DIALECT
