#include <Rcpp.h>
using namespace Rcpp;

// Cholesky decomposition to solve XtX*beta = Xty in Rcpp

NumericVector choleskySolve(const NumericMatrix& XtX, const NumericVector& Xty) {
  // XtX is a p x p symmetric positive-definite matrix
  int p = XtX.nrow();

  // lower-triangular matrix from Cholesky decomposition,XtX = LLT
  NumericMatrix L(p, p);

  // intermediate vector, Lz = Xty
  NumericVector z(p);

  // final vector, LTbeta = z
  NumericVector beta(p);

  // Cholesky Decomposition (XtX = LLT)
  for (int i = 0; i < p; ++i) {
    for (int j = 0; j <= i; ++j) {
      double sum = 0.0;
      for (int k = 0; k < j; ++k) {
        sum += L(i, k) * L(j, k);
      }
      if (i == j)
        L(i, j) = sqrt(XtX(i, j) - sum);
      else
        L(i, j) = (XtX(i, j) - sum) / L(j, j);
    }
  }

  // solve Lz = Xty
  for (int i = 0; i < p; ++i) {
    double sum = 0.0;
    for (int j = 0; j < i; ++j) {
      sum += L(i, j) * z[j];
    }
    z[i] = (Xty[i] - sum) / L(i, i);
  }

  // solve LTbeta = z
  for (int i = p - 1; i >= 0; --i) {
    double sum = 0.0;
    for (int j = i + 1; j < p; ++j) {
      sum += L(j, i) * beta[j];
    }
    beta[i] = (z[i] - sum) / L(i, i);
  }

  return beta;
}

// [[Rcpp::export]]
NumericVector rcpp_lm(NumericMatrix X, NumericVector y) {
  int n = X.nrow();
  int p = X.ncol();

  NumericMatrix XtX(p, p);
  NumericVector Xty(p);

  // Compute XtX and Xty
  for (int i = 0; i < p; ++i) {
    for (int j = 0; j < p; ++j) {
      double sum = 0.0;
      for (int k = 0; k < n; ++k)
        sum += X(k, i) * X(k, j);
      XtX(i, j) = sum;
    }

    double sum2 = 0.0;
    for (int k = 0; k < n; ++k)
      sum2 += X(k, i) * y[k];
    Xty[i] = sum2;
  }

  // Solve for beta using Cholesky decomposition
  NumericVector beta = choleskySolve(XtX, Xty);

  return beta;
}
