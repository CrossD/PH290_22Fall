# install.packages("lobstr")

library(lobstr)
ast(1 + 2 * 3)
ast(if (x > 1) print(y))

1 + 2 # infix
`+`(1, 2) # prefix form

?`%*%`

x <- 1:3
x[1]
`[`(x, 1)

`%rep%` <- function(string, times) rep(string, 3)
"ha" %rep% 3

class(x) <- "something special"
x

`class<-`

`myclass<-` <- function(x, value) {
  attr(x, "myclass") <- value
  x
}

myclass(x) <- "PH290"
x

typeof(`seq`)
typeof(`$`)

str(sleep)
sleep$ID

a <- "ID"
sleep$a # $ does not follow the standard evaluation rule, i.e., replace a symbol by its value

sleep[[a]]

typeof(`+`)

ast(
for (i in 1:10) {
  print(i)
  i + 1
}
)

`%+%` <- function(str1, str2) paste0(str1, str2)
"Hello" %+% "World"

?seq
seq(1, 3, length.out=5)
seq(to = 3, length=5, 1)

myplot <- function(x, ...) {
  ddd <- list(...)
  if (!is.null(ddd$col)) {
    # do something
  } 
  hist(x, ...)
  boxplot(x, ...)
}
myplot(cars$speed, main="car speed", col="red")


f1 <- function(x) return(x)
f2 <- function(x) invisible(x)

f1("BPH")
f2("BPH")
x <- f2("BPH")
x


myplot <- function(x) {
  par(mfrow=c(1, 2))
  hist(x)
  box(x)
}
myplot(1:10)  

plotAndReset <- function(x) {
  
  oldpar <- par(no.readonly = TRUE)
  on.exit(par(oldpar))
  
  
  par(mfrow=c(1, 2))
  hist(x)
  plot(x)
}
plot(1)

plotAndReset(sleep$extra)
plotAndReset(y)

f <- ecdf(sleep$extra)
typeof(f)
x <- seq(-5, 5, length.out=100)
plot(x, f(x))


getloglik <- function(X) {
  
  function(lam) {
    sum(dpois(X, lam, log=TRUE))
  }
  
}

f <- getloglik(c(0, 3, 1, 2, 0))
f(0.5)

x <- seq(0.01, 2, by=0.01)
plot(x, sapply(x, f))

pscl::prussian$y

loglik <- getloglik(pscl::prussian$y)
?optimize
res <- optimize(loglik, c(0.001, 100), maximum = TRUE)
res

factory <- function(a, b) {
  function(x) {
    a * x^2 + b * x
  }  
}

g <- factory(1, -2)
g(-2:2)

optimize(g, c(-100, 100), maximum = FALSE)


library(testthat)

expect_equal(mean(1:3), 2)

expect_equal(mean(seq(-100, 100, by=0.1)), 0, tolerance=0)

