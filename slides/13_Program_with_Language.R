## ----xaringan-tile-view, echo=FALSE-------------------------------------------
xaringanExtra::use_tile_view()


## -----------------------------------------------------------------------------
e <- quote(x + y)
str(e)


## -----------------------------------------------------------------------------
x <- 0
e[[3]] <- 1
eval(e)


## ---- error=TRUE, message=FALSE-----------------------------------------------
library(dplyr)
filterAtLeast5 <- function(col) {
    filter(sleep, col >= 5)
}
filterAtLeast5(extra)


## ---- eval=FALSE--------------------------------------------------------------
## filter(sleep, extra >= 5) # works
## a <- extra >= 5; filter(sleep, a) # does not work


## -----------------------------------------------------------------------------
e <- quote(x + y + 1)
e[[1]] <- quote(`*`)
e


## -----------------------------------------------------------------------------
library(lobstr)
ast(x + y + 1) 


## -----------------------------------------------------------------------------
parse(text="x + 
y + 1 # comment")[[1]]


## -----------------------------------------------------------------------------
substitute(x + y)
substitute(x + y, list(x = 1))
substitute(x + y, list(`+` = quote(`*`)))


## -----------------------------------------------------------------------------
g <- function(x) substitute(x) 
g(x+y)
# default env is the current evaluation environment
g2 <- function(x) {
  a <- 1
  substitute(x + a)
}
g2(x + y)


## ---- fig.height=5, fig.width=5-----------------------------------------------
# Taken from ?substitute
myplot <- function(x, y)
     plot(x, y, xlab = deparse(substitute(x)),
                ylab = deparse(substitute(y)))
x <- seq(-pi, pi, length.out=100)
myplot(cos(x), sin(x))


## -----------------------------------------------------------------------------
aVec <- c(5, -2, 3)
exprList <- purrr::map(seq_along(aVec), function(j) {
    a <- aVec[j]
    power <- j - 1
    substitute(a * x ^ power)
})
a <- purrr::reduce(exprList, function(e1, e2) {
    e1 <- e1 # e1 should be a local variable, 
    e2 <- e2 # not to be used as a promise
    substitute(e1 + e2)
})
fExpr <- substitute(function(x) a, list(a=a))
f <- eval(fExpr)
print(f, useSource=FALSE)


## -----------------------------------------------------------------------------
# SE in its argument
plusToTimes <- function(expr) {
    do.call(substitute, list(expr, list(`+` = quote(`*`))))
}
e <- quote(1 + 2 + 3)
plusToTimes(e)


## -----------------------------------------------------------------------------
library(rlang)
val <- 1
eval(quote(ID == val), envir=sleep, enclos=rlang::current_env())


## -----------------------------------------------------------------------------
subset_base <- function(data, rows) {
  rows <- substitute(rows)
  rows_val <- eval(rows, data, caller_env())

  data[rows_val, , drop = FALSE]
}
my_df <- data.frame(x = 1:3, y = 3:1)
xval <- 1
subset_base(my_df, x == xval)


## ---- include=FALSE, eval=FALSE-----------------------------------------------
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


## -----------------------------------------------------------------------------
f1 <- function(df, ...) {
  xval <- 3
  subset_base(df, ...) # same for subset()
}

f1(my_df, x == xval)


## -----------------------------------------------------------------------------
fm <- ~ poly(x, m)
environment(fm) <- env(m=2)
str(fm)


## -----------------------------------------------------------------------------
evalFormula <- function(x) {
    m <- 0
    do.call(substitute, list(x, env=environment(x)))
}
evalFormula(fm)


## -----------------------------------------------------------------------------
# SE in the 2nd argument (a formula object)
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


## -----------------------------------------------------------------------------
q <- new_quosure(expr(x + y), env(x = 1))
x <- 2
y <- 10
eval_tidy(q)


## -----------------------------------------------------------------------------
f <- function(x) {
  enquo(x)
}
q1 <- f(which(ID == xval))
q1
xval <- 1
eval_tidy(q1, data=sleep) 


## -----------------------------------------------------------------------------
f2 <- function(x) {
  xval <- 3
  eval_tidy(enquo(x), data=sleep)
}
f2(which(ID == xval))


## -----------------------------------------------------------------------------
ID <- 10
group <- 1
q2 <- expr(.data$group == .env$group)
eval_tidy(q2, data=sleep)


## -----------------------------------------------------------------------------
library(dplyr)
dplyr::filter(sleep, .data$group == .env$group)


## -----------------------------------------------------------------------------
# A function that take out records that has the same value 
# as the 1st observation in a specified column
filter1 <- function(v) {
  dplyr::filter(sleep, .data[[v]] == .data[[v]][1])
}
filter1("group")


## -----------------------------------------------------------------------------
x <- expr(y + z)
expr(!!x + !!x)


## -----------------------------------------------------------------------------
v <- as.symbol("group")
dplyr::filter(sleep, !!v == (!!v)[1])


## -----------------------------------------------------------------------------
# SE, inputs a column name
filter2 <- function(v) {
  dplyr::filter(sleep, !!as.symbol(v) == (!!as.symbol(v))[1])
}
filter2("group")


## -----------------------------------------------------------------------------
# NSE, inputs a column in code
filter2_1 <- function(v) {
  v1 <- enquo(v)
  dplyr::filter(sleep, !!v1 == (!!v1)[1])
}
filter2_1(group)


## -----------------------------------------------------------------------------
# NSE, inputs many columns in code
filter2_2 <- function(...) {
  vs <- enquos(...)
  vs <- purrr::map(vs, function(e) expr(!!(e) == (!!e)[1]))
  dplyr::filter(sleep, !!!vs)
}
filter2_2(group, ID)

