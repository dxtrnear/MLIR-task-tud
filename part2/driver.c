#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct {
  double *allocated;
  double *aligned;
  int64_t offset;
  int64_t sizes[2];
  int64_t strides[2];
} Memref2D;

static double now_seconds(void) {
  struct timespec t;
  clock_gettime(CLOCK_MONOTONIC, &t);
  return t.tv_sec + t.tv_nsec * 1e-9;
}

void _mlir_ciface_kernel_jacobi_2d(int64_t tsteps, Memref2D *A, Memref2D *B);
void _mlir_ciface_kernel_seidel_2d(int64_t tsteps, Memref2D *A);

static Memref2D make_desc(double *p, int64_t n) {
  Memref2D d = {p, p, 0, {n, n}, {n, 1}};
  return d;
}
#define IDX(i, j) ((i)*n + (j))

static void init(int n, double *A, double *B) {
    for (int i = 0; i < n; i++)
      for (int j = 0; j < n; j++) {
        A[IDX(i, j)] = ((double)i * (j + 2) + 2) / n;
     if (B)
        B[IDX(i, j)] = ((double)i * (j + 3) + 3) / n;
      }
  }

static void ref_jacobi_2d(int tsteps, int n, double *A, double *B) {
  for (int t = 0; t < tsteps; t++) {
    for (int i = 1; i < n - 1; i++)
      for (int j = 1; j < n - 1; j++)
        B[IDX(i, j)] = 0.2 * (A[IDX(i, j)] + A[IDX(i, j - 1)] + A[IDX(i, j + 1)] +
                              A[IDX(i + 1, j)] + A[IDX(i - 1, j)]);
    for (int i = 1; i < n - 1; i++)
      for (int j = 1; j < n - 1; j++)
        A[IDX(i, j)] = 0.2 * (B[IDX(i, j)] + B[IDX(i, j - 1)] + B[IDX(i, j + 1)] +
                              B[IDX(i + 1, j)] + B[IDX(i - 1, j)]);
  }
}

static void ref_seidel_2d(int tsteps, int n, double *A) {
  for (int t = 0; t <= tsteps - 1; t++)
    for (int i = 1; i <= n - 2; i++)
      for (int j = 1; j <= n - 2; j++)
        A[IDX(i, j)] = (A[IDX(i - 1, j - 1)] + A[IDX(i - 1, j)] + A[IDX(i - 1, j + 1)] +
                        A[IDX(i, j - 1)] + A[IDX(i, j)] + A[IDX(i, j + 1)] +
                        A[IDX(i + 1, j - 1)] + A[IDX(i + 1, j)] + A[IDX(i + 1, j + 1)]) / 9.0;
}

  static int compare(const char *name, int n, const double *x, const double *y) {
    int mismatches = 0;
    double max_diff = 0.0;
    for (int k = 0; k < n * n; k++)
      if (x[k] != y[k]) {
        mismatches++;
        double d = fabs(x[k] - y[k]);
        if (d > max_diff)
          max_diff = d;
      }
    printf("%-9s: %d / %d mismatches, with = %.3e difference\n", name, mismatches, n * n, max_diff);
    return mismatches;
  }

int main(void){
 
int n = 1000;
int tsteps = 100;
size_t bytes = (size_t)n * n * sizeof(double);

double *jA = malloc(bytes), *jB = malloc(bytes); // MLIR Jacoby
double *rA = malloc(bytes), *rB = malloc(bytes); // reference Jacoby
double *sA = malloc(bytes), *qA = malloc(bytes); // MLIR / reference Seidel

init(n, jA, jB);
init(n, rA, rB);
init(n, sA, NULL);
init(n, qA, NULL);
Memref2D dA = make_desc(jA, n), dB = make_desc(jB, n), dS = make_desc(sA, n);
double t0 = now_seconds();
_mlir_ciface_kernel_jacobi_2d(tsteps, &dA, &dB);
double t1 = now_seconds();
ref_jacobi_2d(tsteps, n, rA, rB);
double t2 = now_seconds();
_mlir_ciface_kernel_seidel_2d(tsteps, &dS);
double t3 = now_seconds();
ref_seidel_2d(tsteps, n, qA);
double t4 = now_seconds();

printf("N = %d, TSTEPS = %d\n", n, tsteps);
printf("Jacobi time: %f s\n", t1 - t0);
printf("Reference Jacobi time: %f s\n", t2 - t1);
printf("Seidel time: %f s\n", t3 - t2);
printf("Reference Seidel time: %f s\n", t4 - t3);
int bad = compare("jacobi A", n, jA, rA) + compare("jacobi B", n, jB, rB) + compare("seidel A", n, sA, qA);

free(jA); free(jB); free(rA); free(rB); free(sA); free(qA);
return bad != 0;

}