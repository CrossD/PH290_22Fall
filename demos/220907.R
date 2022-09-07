p <- 3
f <- function(x) {
  toPower(x)
}
toPower <- function(x) {
  x ^ p
}
f(2)
rm(p)
f(2)
traceback()

options(error=recover)

f(2)

woiwoeiaf
options(error=stop)

options(error=dump.frames)
f(2)
last.dump
debugger(last.dump)


squareIt <- function(x) {
  x^2
}
squareAll <- function(vec) {
  browser()
  for (i in 1:length(vec)) {
    res <- squareIt(vec[i])
    print(res)
  }
  return()
}
squareAll(1:2)
a <- numeric(0)

squareAll(a)

squareAll <- function(vec) {
  for (i in 1:length(vec)) {
    # browser()
    res <- squareIt(vec[i])
    print(res)
  }
  return()
}
squareAll(a)

debug(glm)
debug(toPower)
toPower(3)
undebug(toPower)

debugonce(toPower)