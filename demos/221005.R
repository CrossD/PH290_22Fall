library(rlang)

val <- 1
eval(quote(ID == val), 
     envir=sleep, 
     enclos=rlang::current_env())

subset_base <- function(data, rows) {
  rows <- substitute(rows)
  rows_val <- eval(rows, data, rlang::caller_env())
  data[rows_val, , drop = FALSE]
}

my_df <- data.frame(x = 1:3, y = 3:1)
xval <- 1
subset_base(my_df, x == xval)

subset_base <- function(data, rows, col) {
  rows <- substitute(rows)
  col <- substitute(col)
  rows_val <- eval(rows, data, rlang::caller_env())
  col_val <- deparse1(col)
  data[rows_val, col_val, drop = FALSE]
}
subset_base(my_df, x==xval, y)

fm <- ~poly(x, m)
fm
environment(fm)
environment(fm) <- env(m=2)
environment(fm)

evalFormula <- function(x) {
  do.call(substitute, list(x, env=environment(x)))
}
evalFormula(fm)
m <- 0
evalFormula(fm)


q <- new_quosure(expr(x + y), env(x = 1))
x <- 2
y <- 10
eval_tidy(q)

f <- function(x) {
  enquo(x)
}
q1 <- f(which(ID == xval))
q1
xval <- 1
eval_tidy(q1, data=sleep)

f2 <- function(x) {
  xval <- 3
  eval_tidy(enquo(x), data=sleep)
}
f2(which(ID == xval))

group <- 1
q2 <- expr(.data$group == .env$group)
eval_tidy(q2, data=sleep)

eval_tidy(expr(group == group), data=sleep) # doesn't work

library(dplyr)
dplyr::filter(sleep, .data$group == .env$group)

filter1 <- function(v) {
  dplyr::filter(sleep, .data[[v]] > mean(.data[[v]]))
}
filter1("extra")

x <- expr(y + z)
expr(x + x)
expr(!!x + !!x)
expr(!!x + y)

y <- as.symbol("anotherVar")
expr(!!x + !!y)

v <- as.symbol("group")
dplyr::filter(sleep, !!v == (!!v)[1])

# SE, inputs a column name
filter2 <- function(v) {
  dplyr::filter(sleep, !!as.symbol(v) == (!!as.symbol(v))[1])
}
filter2("group")

# NSE, inputs a column in code
filter2_NSE <- function(v) {
  v1 <- enquo(v)
  dplyr::filter(sleep, !!v1 == (!!v1)[1]) 
}
filter2_NSE(group)

# NSE, inputs a column in code
filter3 <- function(v) {
  dplyr::filter(sleep, {{v}} == {{v}}[1])
}
filter3(group)

# NSE, inputs many columns in code
# Takes out records that has the same value as the first record in all specified columns
filter2_2 <- function(...) {
  vs <- enquos(...)
  vs <- purrr::map(vs, function(e) expr(!!(e) == (!!e)[1]))
  dplyr::filter(sleep, !!!vs)
}
filter2_2(group, ID)
