LLVM_PREFIX ?= $(abspath $(CURDIR)/../llvm-install)
MLIR_OPT    := $(LLVM_PREFIX)/bin/mlir-opt
OUT         := part1/IRs/generated

.PHONY: task2 task3

task2:
	mkdir -p $(OUT)
	$(MLIR_OPT) part1/matmul.mlir --linalg-generalize-named-ops -o $(OUT)/task2_generalized.mlir

task3:
	mkdir -p $(OUT)
	$(MLIR_OPT) part1/matmul.mlir --convert-linalg-to-loops -o $(OUT)/task3_scf.mlir
	$(MLIR_OPT) part1/matmul.mlir --convert-linalg-to-affine-loops -o $(OUT)/task3_affine.mlir