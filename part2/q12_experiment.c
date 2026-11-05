// experimenting if multiplication by it's reciprocal can replace a division by a constant
/*
runned with cc -O2 -ffp-contract=off part2/q12_experiment.c
output:
seidel A : 993513 / 1000000 mismatches, with = 5.912e-12 difference
division vs multiplication: 357060 mismatches
division vs multiplication: 0 mismatches
*/
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#define STEPS 1000000
#define IDX(i, j) ((i)*n + (j))


//seidel ref but with division by /9.0 replaced by multiplication (1.0/9.0)
static void ref_seidel_div(int tsteps, int n, double *A) {
  for (int t = 0; t <= tsteps - 1; t++)
    for (int i = 1; i <= n - 2; i++)
      for (int j = 1; j <= n - 2; j++)
        A[IDX(i, j)] = (A[IDX(i - 1, j - 1)] + A[IDX(i - 1, j)] + A[IDX(i - 1, j + 1)] +
                        A[IDX(i, j - 1)] + A[IDX(i, j)] + A[IDX(i, j + 1)] +
                        A[IDX(i + 1, j - 1)] + A[IDX(i + 1, j)] + A[IDX(i + 1, j + 1)]) / 9.0;

}
static void ref_seidel_mul(int tsteps, int n, double *A) {
  for (int t = 0; t <= tsteps - 1; t++)
    for (int i = 1; i <= n - 2; i++)
      for (int j = 1; j <= n - 2; j++)
        A[IDX(i, j)] = (A[IDX(i - 1, j - 1)] + A[IDX(i - 1, j)] + A[IDX(i - 1, j + 1)] +
                        A[IDX(i, j - 1)] + A[IDX(i, j)] + A[IDX(i, j + 1)] +
                        A[IDX(i + 1, j - 1)] + A[IDX(i + 1, j)] + A[IDX(i + 1, j + 1)]) * (1.0 / 9.0);
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

static void init(int n, double *A, double *B) {
    for (int i = 0; i < n; i++)
      for (int j = 0; j < n; j++) {
        A[IDX(i, j)] = ((double)i * (j + 2) + 2) / n;
     if (B)
        B[IDX(i, j)] = ((double)i * (j + 3) + 3) / n;
      }
  }

static int division_vs_multiplication(int n, double d) {
    double result_division = 0.0;
    double result_multiplication = 0.0;
    int count_mismatch = 0;

    for(int i=0; i < n; i++) {
        result_division = i / d;

        result_multiplication = i * (1.0 / d);

        if(result_division != result_multiplication) {
            count_mismatch++;
        }
    }

    return count_mismatch;
}

int main() {
int tsteps = 100; int n = 1000;

size_t bytes = (size_t)n * n * sizeof(double);
double *rA = malloc(bytes), *mA = malloc(bytes);
init(n, rA, NULL);
init(n, mA, NULL);

ref_seidel_div(tsteps, n, rA);
ref_seidel_mul(tsteps, n, mA);
int bad = compare("seidel A", n, mA, rA);
int msim_9 = division_vs_multiplication(STEPS, 9.0);
int msim_8 = division_vs_multiplication(STEPS, 8.0);
printf("division vs multiplication: %d mismatches\n", msim_9);
printf("division vs multiplication: %d mismatches\n", msim_8);

    return 0;
}