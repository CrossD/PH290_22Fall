x <- seq(0, 1, length.out=100)
tracemem(x)

y <- x
y[1] <- 1

z <- seq(0, 1, length.out=99)
tracemem(z)
z[1] <- 1.1
