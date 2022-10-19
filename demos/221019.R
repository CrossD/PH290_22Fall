system.time(lm(price ~ ., data = ggplot2::diamonds))

library(bench)
n <- 1e3
x <- rnorm(n)
bench::mark(mean(x))

bench::mark(var(x),
            n / (n - 1) * (mean(x^2) - mean(x)^2))

res <- bench::press(
  n = c(1e3, 1e6),
  {
    x <- rnorm(n)
    bench::mark(var(x),
                n / (n - 1) * (mean(x^2) - mean(x)^2))
  }
)

ggplot2::autoplot(res)

Rprof()
for (i in 1:10) lm(price ~ ., data = ggplot2::diamonds)
Rprof(NULL)
summaryRprof()

profvis::profvis(
  for (i in 1:10) lm(price ~ ., data = ggplot2::diamonds),
  simplify=FALSE
)

profvis::profvis({
  for (i in 1:10) {
    m <- lm(price ~ ., data = ggplot2::diamonds)
    summary(m)
  }
}, simplify = FALSE)


X <- matrix(rnorm(200 * 2), 200, 2)
y <- rnorm(200)
mark(lm(y~X), 
     lm.fit(X,y), 
     .lm.fit(X,y), 
     check=FALSE)

bench::mark(
  t(X) %*% X,
  crossprod(X)
)

bench::mark(
  solve(t(X) %*% X) %*% t(X) %*% y, 
  solve(t(X) %*% X) %*% (t(X) %*% y), 
  check=FALSE)

library(dplyr)
library(memoise)

f <- function(col) {
  nycflights13::flights %>%
    group_by(year, month, day, !!as.symbol(col)) %>%
    summarize(mean=mean(arr_delay, na.rm=TRUE))
}

mf <- memoise(f)
system.time(mf("carrier"))
system.time(mf("carrier"))

vals <- seq(0, 1, by=0.01)
mark(forloop={
  sum <- 0
  for (x in vals) {
    for (y in vals) {
      sum <- sum + sin(x * y^2)
    }
  }
  sum
}, vectorized={
  len <- length(vals)
  X <- matrix(vals, len, len)
  Y <- t(X)
  sum(sin(X * Y^2))
}
)

source("221019_func.R")

beta <- 1/2
gamma <- 1/3
duration <- 100
dt <- 0.005
initial <- c(0.999, 0.001, 0)
s <- SIR_orig(duration, dt, beta, gamma, initial)
matplot(s$T, s$SIR, type='l')

profvis::profvis(SIR_orig(duration, dt, beta, gamma, initial))


bench::mark(SIR_orig(duration, dt, beta, gamma, initial),
                 SIR_prealloc(duration, dt, beta, gamma, initial))

profvis::profvis(for (i in 1:1000) SIR_prealloc(duration, dt, beta, gamma, initial))
