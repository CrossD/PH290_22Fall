x <- 1
f1 <- function() {
  x <- 2
  print(x)
}
f1()

x <- 1
f1_1 <- function() {
  print(x)
}
f1_1()


times <- 1
f_pkg <- function() rep(0, times)
times <- 3

g_usr <- function() {
  times <- 2
  f_pkg()
}
g_usr()

f1_2 <- function() {
  x <- 1
  g <- function() {
    y <- 2
    c(x, y)
  }
  g()
}
f1_2()


x <- 3
g <- function() {
  y <- 2
  c(x, y)
}

f1_3 <- function() {
  x <- 1
  g()
}
f1_3()


f1_pkg <- function() print(1)
f2_pkg <- function() f1_pkg()

g2_usr <- function() {
  f1_pkg <- function() print(2)
  f2_pkg()
}
g2_usr()

f3 <- function() {
  if (!exists("a")) {
    a <- 1
  } else {
    a <- a + 1
  }
  a
}
f3()


x <- 1
f_4 <- function() x
x <- 2
f_4()

rm(x)
f_4()


myMap <- function(.l, .f, ...) {
  len <- length(.l)
  for (i in seq_len(len)) {
    print( .f(.l[[i]], ...) )
  }
}
len <- 5
myMap(list(3, 2), function(x) rep(x, len))

power1 <- function(exp) {
  function(x) {
    x ^ exp
  }
}
square <- power1(2)
exp <- 3
square(2)


getDefTime <- function() {
  time <- Sys.time()
  function() time
}
definitionTime <- getDefTime()
definitionTime()


runTime <- Sys.time
runTime()


h <- function(x) {
  10
}
h(stop("an error here"))

double <- function(x) { 
  message("Calculating...")
  x * 2
}
h2 <- function(x) {
  c(x, x)
}
h2(double(20))

h3 <- function(x) {
  y <- 100
  x
}
y <- 1
h3(print(y))

a <- print(y)
a

h4 <- function(x = 2 * y, y) {
  c(x, y)
}

h4(y=1)

f <- function(x=g(y)) {
  y <- 1
  print(x)
}
y <- 2
g <- identity
f()
f(g(y))

h5 <- function(x) {
  if (missing(x)) {
    x <- "my default"
  }
  x
}
h5()

myX <- 1:10
plot(myX, sin(myX))
a <- myX
plot(a, sin(a))