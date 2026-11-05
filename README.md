# MLIR tasks — TU Dresden

Solutions to the MLIR exercise sheet: **Part 1** lowers and optimises a matrix multiplication with upstream MLIR passes; **Part 2** adds a small `stencil` dialect (Jacobi-2D, Seidel-2D) with its own lowering passes.

Fork of [h4midf/MLIR-task-tud](https://github.com/h4midf/MLIR-task-tud), built against LLVM/MLIR **`llvmorg-23.1.3`**.

- Answers to the questions (Q1–Q12): [`REPORT.md`](REPORT.md)
- Every result is reproduced by one `make` target (see [Reproducing the results](#reproducing-the-results)).

---

## Environment used

| | |
|---|---|
| Machine | MacBook Air M1 (arm64), 8 GB RAM |
| OS | macOS |
| C/C++ compiler | AppleClang 17 |
| Build tools | CMake 4.4.5, Ninja 1.13.2 |
| LLVM/MLIR | `llvmorg-23.1.3`, Release + assertions (options in `REPORT.md`, Task 1) |

Nothing is macOS-specific in the sources or the Makefile; the same commands should work on Linux.

---

## Expected directory layout

The scripts and the Makefile assume LLVM sits **next to** this repository:

```
<workdir>/
├── llvm-project/     LLVM sources (tag llvmorg-23.1.3)
├── llvm-build/       LLVM build tree (needed for llvm-lit)
├── llvm-install/     LLVM install prefix (mlir-opt, mlir-translate, llc, FileCheck, CMake configs)
└── MLIR-task-tud/    this repository
```

Other locations work by overriding two variables (see below).

---

## Building

**1. LLVM/MLIR (Part 1, Task 1.1)**

```bash
cd <workdir>
git clone --depth 1 --branch llvmorg-23.1.3 https://github.com/llvm/llvm-project.git
MLIR-task-tud/scripts/llvm_build.sh
```

`llvm_build.sh` configures `llvm-build/`, builds and installs into `llvm-install/` (6 compile jobs, 1 link job, chosen for 8 GB of RAM; edit `JOBS` / `LINK_JOBS` in the script for a bigger machine).

**2. The starter project / stencil dialect (Part 1, Task 1.2)**

```bash
MLIR-task-tud/scripts/project_build.sh
```

This configures `build/`, builds `standalone-opt` and runs the lit test (`Passed: 1`). The Part 2 `make` targets also do this automatically when `build/` does not exist yet.

---

## Reproducing the results

From the repository root:

| Target | Sheet task | What it does | Output (`partN/IRs/generated/`) |
|---|---|---|---|
| `make task2` | P1 Task 2 | `--linalg-generalize-named-ops` on `part1/matmul.mlir` | `task2_generalized.mlir` |
| `make task3` | P1 Task 3 | lowering to `scf` loops and to `affine` loops | `task3_scf.mlir`, `task3_affine.mlir` |
| `make task4` | P1 Task 4 | loop interchange with the transform dialect, then loops | `task4_interchanged_scf.mlir` |
| `make task5` | P1 Task 5 | both versions → `llvm` dialect → LLVM IR → objects, linked with `part1/driver.c`, **then runs the test** | `task5*.mlir`, `task5*.ll`, `matmul_test` |
| `make part2_task1` | P2 Task 1 | builds `standalone-opt`, runs the lit test, parses and prints `part2/stencil.mlir` | `task1_part2.mlir` |
| `make part2_task2` | P2 Task 2 | `--stencil-apply-to-linalg` | `task2_linalg.mlir` |
| `make part2_task3` | P2 Task 3 | `--stencil-sweep-to-scf` | `task3_scf.mlir` |
| `make part2_task4` | P2 Task 4 | full lowering to LLVM, object file, linked with `part2/driver.c`, **then runs the comparison** against the PolyBench/C reference kernels | `task4_llvm.mlir`, `task4.ll`, `stencil_test` |

If LLVM is installed elsewhere:

```bash
make part2_task4 LLVM_PREFIX=/path/to/llvm-install LLVM_BUILD=/path/to/llvm-build
```

The Q12 experiment is a standalone C program, not a `make` target:

```bash
cc -O2 -ffp-contract=off part2/q12_experiment.c -o q12 && ./q12
```

**Expected output**

- `make task5`: both matmul kernels match the C reference exactly.
- `make part2_task4`: `0 / 1000000 mismatches` for Jacobi `A`, Jacobi `B` and Seidel `A` (N = 1000, TSTEPS = 100), plus timings.

Note: C code is compiled with `-ffp-contract=off`. Apple clang contracts `a*b + c` into FMA by default, which changes the last bits of the matmul reference (see `REPORT.md`, Task 5).

---

## Repository structure

```
.
├── Makefile                  one target per task (table above)
├── REPORT.md                 answers to Q1–Q12
├── pipeline_part1.drawio.png diagram of the Part 1 lowering pipeline
├── scripts/                  llvm_build.sh, project_build.sh (Task 1)
│
├── part1/
│   ├── matmul.mlir                   @matmul_named and @matmul_generic
│   ├── matmul_interchange.mlir       generic matmul + transform script for the interchange
│   ├── matmul_interchange_named.mlir same transform applied to linalg.matmul (Q6)
│   ├── driver.c                      C driver for Task 5
│   └── IRs/
│       ├── *_annotated.mlir          hand-annotated IR (Tasks 3 and 4)
│       └── generated/                raw output of the make targets
│
├── part2/
│   ├── stencil.mlir          the two kernels written with the stencil dialect (input of every Part 2 target)
│   ├── task2_target.mlir     hand-written expected result of one stencil.apply lowering
│   ├── task3_target.mlir     hand-written expected result of one stencil.sweep lowering
│   ├── invalid.mlir          verifier demo, fails on purpose (not used by make)
│   ├── driver.c              C driver for Task 4 (MLIR kernels vs PolyBench/C reference)
│   ├── q12_experiment.c      Q12: division vs multiplication by the reciprocal
│   └── IRs/
│       ├── *_annotated.mlir  hand-annotated IR (Tasks 2 and 3)
│       └── generated/        raw output of the make targets
│
├── include/Standalone/
│   ├── StandaloneDialect.td  dialect definition (name: stencil)
│   ├── StandaloneOps.td      stencil.apply and stencil.sweep (ODS)
│   └── StencilPasses.h       pass registration
├── lib/Standalone/
│   ├── StandaloneOps.cpp     verifiers (offset shape, apply input ≠ output)
│   └── StencilLowering.cpp   --stencil-apply-to-linalg and --stencil-sweep-to-scf
├── standalone-opt/           the opt-like driver (registers the dialect and the passes)
└── test/Standalone/          lit round-trip test of the dialect
```

**Naming.** The starter's file names, CMake targets, the `standalone-opt` tool and the C++ namespace (`mlir::standalone`) are kept; only the dialect name was changed to `stencil`, so the IR reads `stencil.apply` / `stencil.sweep` as in the sheet.

---

## License

Based on the MLIR out-of-tree template; Apache License 2.0 with LLVM Exceptions (see `LICENSE.txt`).