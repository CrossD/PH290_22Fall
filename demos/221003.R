x + y
e <- quote(x + y)

as.list(e)
e[[1]] <- quote(`*`)
e

x <- 1
y <- 2
eval(e)

library(dplyr)
filterAtLeast5 <- function(col) {
  filter(sleep, col >= 5)
}
filterAtLeast5(extra)

str("x+y")
str(quote(x + y))
eval(quote(x + y))
eval("x + y")

parse(text="x + y")
e
deparse(e)
deparse1(e)

x <- sleep
filter(x, extra >= 5) # works
a <- extra >= 5; filter(sleep, a) # does not work
a <- quote(extra >= 5)
filter(sleep, a) # does not work. NSE in 2nd argument


x <- "hahaha"
quote(x) # NSE

class(quote(x + y))
class(quote(x))
as.symbol("x")
class(quote(2.2))
class(quote(2.2 + 1.2))

class(formals(seq.default))
typeof(formals(seq.default)$by)

e <- quote(x + y + 1)
as.list(e)

text <- "x +
y + 1"
cat(text)
e2 <- parse(text=text)
length(e2)
e2[[1]]

library(lobstr)
ast(x + y + 1) # NSE
e3 <- e2[[1]]
e3
ast(e3)
ast(!!e3)

quote(f(x, -y))
ast(f(x, -y))
e <- quote(f(x, -y))
ast(!!e)

ast(x + y * z)

e
as.list(e)
e[[1]] <- select
e
e[[1]] <- quote(select)
e
source("func.R")
local({
  aa <- 1
})
aa

substitute(x + y)
substitute(x + y, list(x = 1, y = quote(z)))
substitute(x + y, list(`+` = quote(`*`))) 

# promise
g <- function(x) {
  list(sub=substitute(x),
       quo = quote(x))
}
g(x + y)

f2 <- function(x) {
  a <- 1
  substitute(x + a)
}
f2(x + y)

myplot <- function(x, y)
  plot(x, y, xlab = deparse(substitute(x)),
             ylab = deparse(substitute(y)))
x <- seq(-pi, pi, length.out=100)
myplot(cos(x), sin(x))


aVec <- c(5, -2, 3)
exprList <- purrr::map(seq_along(aVec), function(j) {
  a <- aVec[j]
  power <- j - 1
  substitute(a * x ^ power)
})

a <- purrr::reduce(exprList, function(e1, e2) {
  e1 <- e1
  e2 <- e2
  substitute(e1 + e2)
})

plus <- function(e1, e2) { # SE in both inputs
  e1 <- e1
  e2 <- e2
  substitute(e1 + e2)
}

plus(quote(x), quote(y))

fExpr <- substitute(function(x) a, list(a=a))
f <- eval(fExpr)
print(f, useSource=FALSE)
f(1:4)

e <- quote(x + y + z)
substitute(e)
do.call(substitute, list(e, list(`+` = quote(`*`)))) # Turn on SE for the 1st argument

library(rlang)
val <- 1
eval(quote(ID == val), envir=sleep, enclos=rlang::current_env())






