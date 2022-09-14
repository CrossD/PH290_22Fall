x <- c(1, 2, 3)
y <- x
y[[3]] <- 4
x
y

library(rlang)
e1 <- rlang::env(a = 1, b = 2, c = 3)
e2 <- e1

e1$c <- 4
e1$c
e2$c

f <- function(e) {
  e$a <- 100
  stop("Don't return")
}
f(e1) # on the other hand, if you input a list, it gets copied
e1$a

env_print(e1)

e3 <- env(e1, d=1)
env_print(e3)

get("d", envir=e3)
get("a", envir=e3)
get("aVarThatExistsNoWhere", envir=e3)

e1$anEnv <- e3
env_print(e1$anEnv)
env_print(e3)
env_parent(e3)
env_parent(e1$anEnv)

e3 <- env(a=1, a=2) # Not useful
env_print(e3)
e3$a
ls(e3)

e3[[1]]


env1 <- env(a=1, b="ha", c=TRUE)
env_print(env1)

env2 <- env(env1, a=2)
env_print(env2)
env1$b <- NULL
env_print(env1)
env_unbind(env1, "b")
env_print(env1)
env_print(env2)
get("a", envir=env2)
get("c", envir=env2)


getFunWithCounter <- function() {
  counter <- 0
  function() {
    counter <<- counter + 1
    counter
  }
}
f <- getFunWithCounter()
f()

plus <- function(x) {
  function(y) x + y
}
plus_one <- plus(1)
plus_one(2)

plus <- function(x) {
  function(y) x + y
}
a <- 2
plus_two <- plus(a)
a <- -2

plus_two(2)

plus_v2 <- function(x) {
  force(x)
  function(y) x + y
}
a <- 2
plus_two <- plus_v2(a)
a <- -2
plus_two(2)


var <- function(x) stop()
sd(1:3)
