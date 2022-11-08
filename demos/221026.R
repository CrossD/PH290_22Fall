
dyn.load("SIR_C.so")

res <- matrix(0.0, 100001, 3)
tmp <- .C("SIR_c",
         as.double(1/100),
         as.double(1/2),
         as.double(1/3),
         c(0.999, 0.001, 0),
         res, 
         dim(res))
str(tmp)
str(tmp[[5]])

system("R CMD SHLIB SIR_c.cpp")
dyn.load("SIR_c.so")
SIR_c_R <- function(duration, dt, beta, gamma, 
                    initial=c(0.999, 0.001, 0)) {
  res <- matrix(0.0, 1 + floor(duration / dt), 3)
  a <- .C("SIR_c", 
          dt      = as.double(dt),
          beta    = as.double(beta),
          gamma   = as.double(gamma),
          initial = as.double(initial),
          res     = res,
          dim     = dim(res))
  a$res
}

system("R CMD SHLIB SIR_call.cpp")
dyn.load("SIR_call.so")
SIR_call_R <- function(duration, dt, beta, gamma, initial=c(0.999, 0.001, 0)) {
  .Call("SIR_call", 
        as.double(duration), 
        as.double(dt), 
        as.double(beta),
        as.double(gamma),
        as.double(initial))
}

duration <- 100
dt <- 1/100
beta <- 1/2
gamma <- 1/3
initial <- c(0.999, 0.001, 0)
bench::mark(
  SIR_c_R(duration, dt, beta, gamma, initial),
  SIR_call_R(duration, dt, beta, gamma, initial)
)


Rcpp::cppFunction("
int whichExceeds(NumericVector x, double thresh) {
    for (int i = 0; i < x.length(); i++) {
        if (x[i] > thresh) {
            return(i + 1); // R index
        } 
    }
    return(0); // If not found
}
")

whichExceeds(c(1, 5, 2), 4)

src <- "
NumericVector movingAverage(NumericVector x, IntegerVector lag) {
  int ll = lag[0], start, stop, n = x.length();
  NumericVector y = NumericVector(n, 0.0);
  for (int i = 0; i < n; i++) {
    start = std::max(i - ll, 0);
    stop = std::min(i + ll, n);
    for (int l = start; l <= stop; l++) {
      y[i] += x[l];
    }
    y[i] /= (double) (stop - start + 1);
  }
  return y;
}"

Rcpp::cppFunction(src)
movingAverage(c(6, 1, 2, 2.5), 1)

Rcpp::cppFunction(depends = "RcppArmadillo", "
arma::vec invDiag(arma::vec v) {
  return arma::diagvec(arma::inv(arma::diagmat(v)));
}")

v <- rnorm(1e3)
bench::mark(invDiag(v),
            diag(solve(diag(v))),
            check=FALSE)
