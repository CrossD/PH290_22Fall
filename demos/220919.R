mod <- lm(extra ~ group, sleep)
class(mod)
typeof(mod)
attributes(mod)

X <- matrix(1:6, 2, 3)
attributes(X)
class(X) # implicit class

str(mod)
names(mod)

print
plot
sum
`[`

stats:::print.lm
print(mod)
modl <- unclass(mod)
class(modl)
print(modl)

gmod <- glm(extra ~ group, sleep, family=gaussian)
class(gmod)

p1 <- 312 # ID
attr(p1, "pname") <- "Max"
p1
class(p1)
class(p1) <- "patient"
p1
class(p1)

NewPatient <- function(ID, pname) {
  structure(
    ID, 
    pname = pname, 
    class = "patient"
  )
}
p2 <- NewPatient(123, "Nux")
p2

NewPatientWithCheck <- function(ID, pname) {
  stopifnot(Id > 0)
  stopifnot(is.character(pname))
  
  structure(
    ID, 
    pname = pname, 
    class = "patient"
  )
}

NewPatientWithCheck(-1, "Penny")


NewPatient2 <- function(ID, pname, ..., subclass=character()) {
  structure(
    ID, 
    pname = pname, 
    ..., 
    class = c(subclass, "patient")
  )
}
p3 <- NewPatient2(132, 
            "Novak",
            DOA = as.Date("1962-10-30"),
            subclass="in-patient")
p3

DaysInHospital <- function(x, ...) {
  stopifnot(x > 0)
  UseMethod("DaysInHospital")
  # stop()
}

library(sloop)
s3_dispatch(print(p3))
print(p3)

print.patient <- function(x, ...) {
  writeLines(sprintf("Patient ID is %d", x))
  writeLines(sprintf("Patient name is %s", 
                     attr(x, "pname")))
  invisible(x)
}
print(p3)
s3_dispatch(print(p3))

sprintf("this is %s I want to say", "hello world")

`DaysInHospital.in-patient` <- function(x) {
  Sys.Date() - attr(x, "DOA")
}
DaysInHospital(p3)

t.test(extra ~ group, sleep)
s3_dispatch(t.test(extra ~ group, sleep))

t.test(formula=extra ~ group, sleep)


`print.in-patient` <- function(x) {
  NextMethod()
  writeLines(sprintf("DOA is %s", attr(x, "DOA")))
  invisible(x)
}
print(p3)

p5 <- NewPatient2(555,
                  pname = "Jack",
                  DOA = as.Date("2022-06-01"),
                  reason = "stroke",
                  subclass = c("ICU-patient", "in-patient"))
p5
class(p5)
s3_dispatch(print(p5))

`print.ICU-patient` <- function(x) {
  NextMethod()
  writeLines(sprintf("Reason of admission is %s", attr(x, "reason")))
  invisible(x)
}
print(p5)


tm <- function(...) {
  res <- lm(...)
  class(res) <- c("tm", class(res))
  res
}
tmod1 <- tm(extra ~ group, sleep)
print(tmod1)
plot(tmod1)

print.tm <- function(x, ...) {
  cat(sprintf("Fitting: %s\n\n", deparse(x$terms)))
  cat("Coefficients:\n")
  print.default(coef(x))
  invisible(x)
}
tmod1

present <- function(x, ...) {
  UseMethod("present")
}

present.tm <- function(x, ...) {
  print(x)
  writeLines(praise::praise())
  invisible(x)
}
present(tmod1)
