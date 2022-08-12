/* PANACEA.c
   C code from the R package NetPreProc
*/

#include <stdlib.h>

/*
  norm_lapl_graph: Normalized graph Laplacian.
  Given an adjacency matrix of a graph, it computes the corresponding Normalized graph Laplacian
  INPUT:
  W: pointer to a symmetric matrix
  diag: pointer to a vector representing the diagonal of the matrix D^-1/2, where
  D_ii = \sum_j W_ij and D_ij = 0 if i!=j
  n: dimension of the square matrix W
  OUTPUT
  W is the normalized matrix
*/
void  norm_lapl_graph(double * W, double * diag, int * n){
  register int i, j, k, m;
  double x;
  m = *n;
  for (i=0; i <m; i++) {
    x = diag[i];
    for (j=0; j <m; j++){
	   k = j*m + i;
	   W[k] = W[k] * x;
	}
  }

  for (i=0; i <m; i++) {
    for (j=0; j <m; j++){
	   x = diag[j];
	   k = j*m + i;
	   W[k] = W[k] * x;
	}
  }
}
