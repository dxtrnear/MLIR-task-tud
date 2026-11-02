#!/usr/bin/env bash

# Task1: building latest version of llvm configured with cmake with mlir enabled in a seperate directory
set -euo pipefail

REPO_DIR="$(realpath "$(dirname "$0")/..")"
WORK_DIR="$(dirname "$REPO_DIR")"

LLVM_SRC="$WORK_DIR/llvm-project"
LLVM_BUILD="$WORK_DIR/llvm-build"
LLVM_PREFIX="$WORK_DIR/llvm-install"

JOBS=6 
LINK_JOBS=1

cmake -S "$LLVM_SRC/llvm" -B "$LLVM_BUILD" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_ENABLE_PROJECTS=mlir \
  -DLLVM_TARGETS_TO_BUILD=host \
  -DLLVM_INSTALL_UTILS=ON \
  -DLLVM_BUILD_EXAMPLES=OFF \
  -DLLVM_ENABLE_BINDINGS=OFF \
  -DLLVM_PARALLEL_LINK_JOBS="$LINK_JOBS" \
  -DCMAKE_INSTALL_PREFIX="$LLVM_PREFIX"

ninja -C "$LLVM_BUILD" -j"$JOBS" install
