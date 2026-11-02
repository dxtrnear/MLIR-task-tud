#!/usr/bin/env bash

# Task1: building project 
set -euo pipefail

REPO_DIR="$(realpath "$(dirname "$0")/..")"
WORK_DIR="$(dirname "$REPO_DIR")"

LLVM_BUILD="$WORK_DIR/llvm-build"
LLVM_PREFIX="$WORK_DIR/llvm-install"



cmake -G Ninja -S "$REPO_DIR" -B "$REPO_DIR/build" \
 -DMLIR_DIR="$LLVM_PREFIX/lib/cmake/mlir" \
 -DLLVM_EXTERNAL_LIT="$LLVM_BUILD/bin/llvm-lit" \

ninja -C "$REPO_DIR/build" check-standalone-opt 