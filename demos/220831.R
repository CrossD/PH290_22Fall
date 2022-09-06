myMean <- function(x, na.rm=FALSE) {
  if (na.rm) {
    x <- x[!is.na(x)]
  }
  sum(x) / length(x)
}

library(testthat)

test_that("myMean works", {
  x <- 1:3
  y <- seq(-100, 100, by=0.1)
  z <- c(y, NA)
  expect_equal(myMean(x), 2)
  expect_equal(myMean(y), 0)
  expect_equal(myMean(z), NA_real_) # NA has types!
  expect_equal(myMean(z, na.rm=TRUE), 0)
})

test_that("myMean works for a scalar input", {
  x <- 1
  expect_equal(myMean(x), x)
})

GenSample <- function(n) {
  stopifnot(n >= 1)
  # ...generate sample
}

GenSample <- function(n) {
  if (n >= 1) {
    stop("sample size must be positive")
  }
}

GenSample(0)

x <- list(1:3, c(2, 5))
list(mean(1:3), mean(c(2, 5)))

library(purrr)     
map(x, mean)

standardize <- function(v) (v - mean(v)) / sd(v)
map(x, standardize)

function(v) 
  (v - mean(v)) / sd(v)
map(x, function(v) (v - mean(v)) / sd(v))

unlist(map(x, mean))

map_dbl(x, mean)
map_dbl(x, as.character)

map(x, summary)

do.call(cbind, list(a=1:3, b=4:6))
# same as cbind(a = 1:3, b = 4:6)
do.call(plot, list(1:10, col="red"))

# special functions
x
map(x, `+`, 1)
map(x, `+`, 1:3)
map(x, `[`, 2)

l <- list(c(1, 3, 5, 100),
          c(NA, 3, 5, 100),
          c(NA, 1:10, 100))
map(l, sum)
map_dbl(l, sum)
map_dbl(l, sum, na.rm=TRUE)

y <- list(c(1, 2, 3, 10), 1:3)
map(y, function(xx) {
  map_dbl(c(0, 0.3), function(trim) mean(xx, trim=trim))
})

imap(x, function(x, i) {
  paste0("Field ", i, " has mean ", mean(x))
})

map2(x, 
     c("Male", "Female"), 
     function(v, name) paste0(name, ": ", mean(v)))

l <- list(
  c(1, 6),
  c(4, 3),
  c(2, 5)
)
pmap(l, function(a, b, c) seq(a, b, length.out=c))

l1 <- list(1, 2, 3)
l2 <- list(1, 2, 3)
l3 <- list(1, 2, 3)

l1 * l2

map2(l1, l2, `*`)
map2(l1, l2, function(a, b) a * b)
pmap(list(l1, l2, l3), function(a, b, c) a * b * c)

sLenBySpecies <- split(iris, iris$Species)
summary(sLenBySpecies)

map(sLenBySpecies, summary)

library(gapminder)
library(dplyr)

str(gapminder)

nested <- gapminder %>%
  group_by(country, continent) %>%
  tidyr::nest()

dat1 <- nested %>%
  mutate(
    mod = map(data, function(dat) {
      lm(lifeExp ~ year, dat)
    }),
    beta = map_dbl(mod, function(m) coefficients(m)['year'])
  )
dat1$mod
dat1
