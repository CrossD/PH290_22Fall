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

setGeneric("length")
setMethod("length", "Direction", function(x) length(x@theta))
setMethod("length", "Location", function(x) length(x@loc))
length(l2)
length(dl2)
showClass("DirectionField")

# getter
setGeneric("degree", function(object) standardGeneric("degree"))
setMethod("degree", "Direction", 
          function(object) object@theta * 360)

# setter
setGeneric("degree<-", 
           function(object, value) standardGeneric("degree<-"))
setMethod("degree<-", "Direction", function(object, value) {
  object@theta <- value / 360
  validObject(object)
  object
})

degree(d1)

d2 <- d1
degree(d2) <- degree(d2) / 3
d2



library(R6)
Logger <- R6Class("Logger", 
  public = list(
    filepath = character(),
    log = function(text) {
      writeLines(text, private$con)
      private$nlines <- private$nlines + length(text)
      invisible(self)
    },
    initialize = function(name="log.txt") {
      self$filepath <- name
      private$con <- file(name, open="w")
    },
    finalize = function() {
      close(private$con)
      message(sprintf("Logged %d lines", private$nlines))
    }
  ),
  private = list(
    nlines = 0,
    con = NULL
  )
)

log1 <- Logger$new()
log1$log(c("data cleaning...", "training..."))
log1

log2 <- log1
log2$log("fitting model")
log2
log1

f <- function(logger) {
  logger$log("your model is phenomenal")
}
f(log1)
log1  

rm(log1)
rm(log2)
gc()


## packages
setwd("~/Downloads/PH290")
usethis::create_package("myPackage")


devtools::load_all("myPackage")

mod1 <- lm(lifeExp ~ year, gapminder::gapminder)
mod2 <- lm(lifeExp ~ year + gdpPercap, gapminder::gapminder)
CompModels(mod1, mod2)







