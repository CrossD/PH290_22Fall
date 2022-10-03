## ----xaringan-tile-view, echo=FALSE---------------------------------------------------
xaringanExtra::use_tile_view()


## -------------------------------------------------------------------------------------
e <- quote(x + y)
str(e)


## -------------------------------------------------------------------------------------
x <- 0
e[[3]] <- 1
eval(e)


## ---- error=TRUE, message=FALSE-------------------------------------------------------
library(dplyr)
filterAtLeast5 <- function(col) {
    filter(sleep, col >= 5)
}
filterAtLeast5(extra)


## ---- eval=FALSE----------------------------------------------------------------------
## filter(sleep, extra >= 5) # works
## a <- extra >= 5; filter(sleep, a) # does not work


## -------------------------------------------------------------------------------------
e <- quote(x + y + 1)
e[[1]] <- quote(`*`)
e


## -------------------------------------------------------------------------------------
library(lobstr)
ast(x + y + 1) 


## -------------------------------------------------------------------------------------
parse(text="x + 
y + 1 # comment")[[1]]


## -------------------------------------------------------------------------------------
substitute(x + y)
substitute(x + y, list(x = 1))
substitute(x + y, list(`+` = quote(`*`)))


## -------------------------------------------------------------------------------------
g <- function(x) substitute(x) 
g(x+y)
# default env is the current evaluation environment
g2 <- function(x) {
  a <- 1
  substitute(x + a)
}
g2(x + y)


## ---- fig.height=5, fig.width=5-------------------------------------------------------
# Taken from ?substitute
myplot <- function(x, y)
     plot(x, y, xlab = deparse(substitute(x)),
                ylab = deparse(substitute(y)))
x <- seq(-pi, pi, length.out=100)
myplot(cos(x), sin(x))


## -------------------------------------------------------------------------------------
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
a <- a
fExpr <- substitute(function(x) a, list(a=a))
f <- eval(fExpr)
print(f, useSource=FALSE)


## -------------------------------------------------------------------------------------
# SE in its argument
plusToTimes <- function(expr) {
    do.call(substitute, list(expr, list(`+` = quote(`*`))))
}
e <- quote(1 + 2 + 3)
plusToTimes(e)


## -------------------------------------------------------------------------------------
library(rlang)
val <- 1
eval(quote(ID == val), envir=sleep, enclos=rlang::current_env())


## -------------------------------------------------------------------------------------
subset_base <- function(data, rows) {
  rows <- substitute(rows)
  rows_val <- eval(rows, data, caller_env())

  data[rows_val, , drop = FALSE]
}
my_df <- data.frame(x = 1:3, y = 3:1)
xval <- 1
subset_base(my_df, x == xval)


## ---- include=FALSE, eval=FALSE-------------------------------------------------------
## subset_base2 <- function(data, rows, col) {
##   col <- substitute(col)
##   col_val <- deparse1(col)
## 
##   rows <- substitute(rows)
##   rows_val <- eval(rows, data, caller_env())
## 
##   data[rows_val, col_val, drop = FALSE]
## }
## subset_base2(my_df, x == xval, y)


## -------------------------------------------------------------------------------------
f1 <- function(df, ...) {
  xval <- 3
  subset_base(df, ...) # same for subset()
}

f1(my_df, x == xval)


## -------------------------------------------------------------------------------------
fm <- ~ x + y
str(fm)


## -------------------------------------------------------------------------------------
# SE in the 2nd argument
subset_base2 <- function(data, rowsFm) {

  stopifnot(rlang::is_formula(rowsFm))
  rowsFm[[1]] <- quote(`(`) # remove `~`
  rows_val <- eval(rowsFm, data, environment(rowsFm))

  data[rows_val, , drop = FALSE]
}
f2 <- function(df, ...) {
  xval <- 3
  subset_base2(df, ...)
}

subset_base2(my_df, ~(x == xval))
f2(my_df, ~(x == xval))

