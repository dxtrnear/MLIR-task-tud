#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

typedef struct {
  double *allocated;
  double *aligned;
  int64_t offset;
  int64_t sizes[2];
  int64_t strides[2];
} MemRef2D;


static double now_seconds(void) {
  struct timespec t;
  clock_gettime(CLOCK_MONOTONIC, &t);
  return t.tv_sec + t.tv_nsec * 1e-9;
}


//C wrappers wr got from mlir-opt --llvm-request-c-wrappers
void _mlir_ciface_matmul_generic(MemRef2D *A, MemRef2D *B, MemRef2D *C);
void _mlir_ciface_matmul_generic_interchanged(MemRef2D *A, MemRef2D *B, MemRef2D *C);

//function to turn a 2D array into a memref
static MemRef2D make_memref(double *data, int64_t rows, int64_t cols) {
  MemRef2D m = { data, data, 0, { rows, cols }, { cols,1} };
  return m;
}

int main(int argc, char **argv) {

  int64_t M = 1000, K = 1000, N = 1000;

  double *A    = malloc(M * K * sizeof(double));
  double *B    = malloc(K * N * sizeof(double));
  double *Cref = calloc(M * N, sizeof(double));  //c is initiated to 0 (q2)
  double *C1   = calloc(M * N, sizeof(double));
  double *C2   = calloc(M * N, sizeof(double));

  // fillling A & B with some values
    for (int i = 0; i < M; ++i){
        for (int j = 0; j < K; ++j){
        A[i * K + j] = 1.0 / (i + j + 1);
        }
        }

    for (int i = 0; i < K; ++i){
        for (int j = 0; j < N; ++j){
            B[i * N + j] = 1.0 / (i + j + 2);
        }
    }
// c reference 
for (int i = 0; i < M; i++){
    for (int j = 0; j < N; j++){
         for (int k = 0; k < K; k++){
            Cref[i * N + j] += A[i * K + k] * B[k * N + j];

         }
    }
       
}

  MemRef2D a  = make_memref(A,  M, K);
  MemRef2D b  = make_memref(B,  K, N);
  MemRef2D c1 = make_memref(C1, M, N);
  MemRef2D c2 = make_memref(C2, M, N);

double t0 = now_seconds();
_mlir_ciface_matmul_generic(&a, &b, &c1);
double t1 = now_seconds();
_mlir_ciface_matmul_generic_interchanged(&a, &b, &c2);
double t2 = now_seconds();

//function to compare c1 and c2 with Cref value per value
for (int i = 0; i < M; ++i) {
    for (int j = 0; j < N; ++j) {
        if (C1[i * N + j] != Cref[i * N + j]) {
            printf("C1 does not match Cref at (%d, %d): %.17g != %.17g\n", i, j, C1[i * N + j], Cref[i * N + j]);
            return 1;
        }
        if (C2[i * N + j] != Cref[i * N + j]) {
            printf("C2 does not match Cref at (%d, %d): %.17g != %.17g\n", i, j, C2[i * N + j], Cref[i * N + j]);
            return 1;
        }
    }
}
printf("original (i,j,k):     %.3f s\n", t1 - t0);
printf("interchanged (i,k,j): %.3f s\n", t2 - t1);

free(A); free(B); free(Cref); free(C1); free(C2);
return 0;


}