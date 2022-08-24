getwd()

x <- read.csv("../documents/input.csv")
str(x)


# Data types

str(1.2)
str(1)
1L
str(1L)

identical(1, 1L)

"ha"
'ma'

c(TRUE, FALSE)

x <- list(1, "ha", list(TRUE))
x[1]
class(x[1])
x[[1]]
class(x[[1]])

x <- c(5, 10)
names(x) <- c("cat", "dog")
class(x) <- "PetCounts"
x

attributes(x)
typeof(x)

c(x)


y <- factor(letters)
typeof(y)
attributes(y)

str(y)

z <- 1L:26L
class(z) <- "factor"
levels(z) <- letters
z
identical(z, y)

?lm
ctl <- c(4.17,5.58,5.18,6.11,4.50,4.61,5.17,4.53,5.33,5.14)
trt <- c(4.81,4.17,4.41,3.59,5.87,3.83,6.03,4.89,4.32,4.69)
group <- gl(2, 10, 20, labels = c("Ctl","Trt"))
weight <- c(ctl, trt)
lm.D9 <- lm(weight ~ group)

lm.D9
str(lm.D9)
class(lm.D9)

attr(lm.D9, "class") <- NULL
lm.D9


x
attr(x, "legs") <- c(4, 4)
x

x  <- matrix(1:6, 2, 3)

attributes(x)
typeof(x)

y <- 1L:6L
y
attr(y, "dim") <- c(2, 3)
y

z <- 1L:6L

attributes(y)

.GlobalEnv$x

class(y ~ x)
typeof(y~x)
