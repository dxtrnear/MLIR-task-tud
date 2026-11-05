//===- StandaloneOps.cpp - Standalone dialect ops ---------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Standalone/StandaloneOps.h"
#include "Standalone/StandaloneDialect.h"
#include "mlir/IR/OpImplementation.h"

#define GET_OP_CLASSES
#include "Standalone/StandaloneOps.cpp.inc"

using namespace mlir;
using namespace mlir::standalone;
/*
We will only write offset verification here (since shared) and that input and output buffer differs (for q9) , the rest to verify will be:
- verify that the divisor is not zero
-offsets not empty
-values in [-1, 1]
...
*/

//shared by both ops
static LogicalResult verifyOffsets(Operation *op, ArrayAttr offsets) {
  for (Attribute a : offsets) {
    auto pair = llvm::cast<ArrayAttr>(a);
    if (pair.size() != 2)
      return op->emitOpError("each offset must have 2 entries, got ")<< pair.size();
  }
  return success();
}

LogicalResult ApplyOp::verify() {
  if (getInput() == getOutput()) return emitOpError("input and output must be different buffers");
  return verifyOffsets(*this, getOffsets());
}

LogicalResult SweepOp::verify() {
  return verifyOffsets(*this, getOffsets());
}

