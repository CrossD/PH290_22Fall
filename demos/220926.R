#### 22-09-21
# Direction example
setClass("Direction", 
         slots = c(theta = "numeric")) # theta in [0, 1)
a <- new("Direction", theta=c(0, 0.5))

setValidity("Direction", function(object) {
  if (all(object@theta >= 0 & object@theta < 1) ) {
    TRUE
  } else {
    "theta must lie in [0, 1)"
  }
})

eps <- sqrt(.Machine$double.eps)
d1 <- new("Direction", theta = seq(0, 1 - eps, length.out=4))

RUnifDirection <- function(n) {
  new("Direction", theta = runif(n, max = 1 - eps))
}
d2 <- RUnifDirection(3)

AddNumToDirection <- function(num, dir) {
  dir@theta <- (dir@theta + num) %% 1
  dir
}
setMethod(`+`, c("Direction", "numeric"),
          function(e1, e2) AddNumToDirection(e2, e1))
setMethod(`+`, c("numeric", "Direction"),
          function(e1, e2) AddNumToDirection(e1, e2))
setMethod(`+`, c("Direction", "Direction"),
          function(e1, e2) AddNumToDirection(e1@theta, e2))

setClass("Location", 
         slots = c(loc = "matrix"),
         prototype = list(loc=matrix(NA_real_, nrow=2, ncol=0)))

setClass("DirectionField",
         contains = c("Direction", "Location"))

l2 <- new("Location", loc= matrix(as.numeric(1:6), 2, 3))
dl2 <- new("DirectionField", d2, l2)
dl2

dl2 + dl2

