LLVM_PREFIX ?= $(abspath $(CURDIR)/../llvm-install)
MLIR_OPT    := $(LLVM_PREFIX)/bin/mlir-opt
OUT         := part1/IRs/generated
MLIR_TRANSLATE := $(LLVM_PREFIX)/bin/mlir-translate
LLC := $(LLVM_PREFIX)/bin/llc


LLVM_BUILD     ?= $(abspath $(CURDIR)/../llvm-build)
BUILD          := $(CURDIR)/build
STANDALONE_OPT := $(BUILD)/bin/standalone-opt
OUT2           := part2/IRs/generated

.PHONY: task2 task3 task4 task5 part2_task1 part2_task2 pzart2_task3

task2:
	mkdir -p $(OUT)
	$(MLIR_OPT) part1/matmul.mlir --linalg-generalize-named-ops -o $(OUT)/task2_generalized.mlir

task3:
	mkdir -p $(OUT)
	$(MLIR_OPT) part1/matmul.mlir --convert-linalg-to-loops -o $(OUT)/task3_scf.mlir
	$(MLIR_OPT) part1/matmul.mlir --convert-linalg-to-affine-loops -o $(OUT)/task3_affine.mlir

task4:
	mkdir -p $(OUT)
	$(MLIR_OPT) part1/matmul_interchange.mlir --transform-interpreter --test-transform-dialect-erase-schedule --convert-linalg-to-loops -o $(OUT)/task4_interchanged_scf.mlir

task5: task3 task4
	mkdir -p $(OUT)
	$(MLIR_OPT) $(OUT)/task3_scf.mlir --llvm-request-c-wrappers --convert-scf-to-cf  --convert-cf-to-llvm --convert-arith-to-llvm --finalize-memref-to-llvm --convert-func-to-llvm --reconcile-unrealized-casts -o $(OUT)/task5_llvm.mlir
	$(MLIR_TRANSLATE) $(OUT)/task5_llvm.mlir -mlir-to-llvmir -o $(OUT)/task5.ll
	$(LLC) -filetype=obj $(OUT)/task5.ll -o $(OUT)/task5.o

	$(MLIR_OPT) $(OUT)/task4_interchanged_scf.mlir  --llvm-request-c-wrappers --convert-scf-to-cf  --convert-cf-to-llvm --convert-arith-to-llvm --finalize-memref-to-llvm --convert-func-to-llvm --reconcile-unrealized-casts -o $(OUT)/task5_llvm_interchanged.mlir
	$(MLIR_TRANSLATE) $(OUT)/task5_llvm_interchanged.mlir -mlir-to-llvmir -o $(OUT)/task5_interchanged.ll
	$(LLC) -filetype=obj $(OUT)/task5_interchanged.ll -o $(OUT)/task5_interchanged.o

	$(CC) -ffp-contract=off part1/driver.c $(OUT)/task5.o $(OUT)/task5_interchanged.o -o $(OUT)/matmul_test

$(BUILD)/build.ninja:
	cmake -G Ninja -S . -B $(BUILD) -DMLIR_DIR=$(LLVM_PREFIX)/lib/cmake/mlir -DLLVM_EXTERNAL_LIT=$(LLVM_BUILD)/bin/llvm-lit

part2_task1: $(BUILD)/build.ninja
	ninja -C $(BUILD) check-standalone-opt
	mkdir -p $(OUT2)
	$(STANDALONE_OPT) part2/stencil.mlir -o $(OUT2)/task1_part2.mlir 

part2_task2: $(BUILD)/build.ninja
	ninja -C $(BUILD) check-standalone-opt
	mkdir -p $(OUT2)
	$(STANDALONE_OPT) part2/stencil.mlir --stencil-apply-to-linalg -o $(OUT2)/task2_linalg.mlir

part2_task3: $(BUILD)/build.ninja
	ninja -C $(BUILD) check-standalone-opt
	mkdir -p $(OUT2)
	$(STANDALONE_OPT) part2/stencil.mlir --stencil-sweep-to-scf -o $(OUT2)/task3_scf.mlir