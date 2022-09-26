NewPatient2 <- function(ID, pname, ..., subclass=character()) {
  structure(ID, 
            pname = pname,
            ..., 
            class = c(subclass, "patient")
  )
}

p1 <- NewPatient2(1, "Mary")
p1p2 <- NewPatient2(1:2, c("Mary", "Jack"))
p1p2

`[.patient` <- function(x, i) {
  x[i] # won't work
}
p1p2[1]

`[.patient` <- function(x, i) {
  res <- NewPatient2(NextMethod(), pname=attr(x, "pname")[i])
  res
}

setClass("Patient",
         slots = c(ID = "integer", pname = "character"),
         prototype = list(ID = integer(), pname = character()))
showClass("Patient")

new("Patient")
p1 <- new("Patient", ID = 312, pname = "Max")
p1 <- new("Patient", ID = 312L, pname = "Max")

NewPatient3 <- function(ID, pname, ..., Class="Patient") {
  ID <- as.integer(ID)
  #new(Class, ID=ID, pname=pname)
  do.call(new, list(Class, ID=ID, pname=pname, ...))
}
p1 <- NewPatient3(312, "Max")

p1@ID
cars[['speed']]
slot(p1, "ID")
slotNames(p1)
getSlots("Patient")

setValidity("Patient", function(object) {
  msg <- character()
  if (object@ID < 0L) {
    msg <- c(msg, "ID should be positive integer")
  }
  if (nchar(object@pname) > 20) {
    msg <- c(msg, "pname cannot exceed 20 characters")
  }
  
  if (length(msg) > 0) {
    msg
  } else {
    TRUE
  }
})
p2 <- NewPatient3(2, "Nux")
NewPatient3(-100, "abcdefghijklmnopqrstuvwxyz")
validObject(p2)

p1
show(p1)

setMethod("show",
          signature = "Patient", 
          function(object) {
            writeLines(sprintf("Patient %d is %s", 
                               object@ID, object@pname))
          }
)
p1

setClass("In-patient", 
         contains = "Patient",
         slots = c(DOA = "Date"),
         prototype = list(DOA = as.Date(NA)))
showClass("In-patient")
p3 <- NewPatient3(3, "Kate", DOA=Sys.Date(), Class="In-patient")
p3
str(p3)

showMethods("show")
showMethods(class="Patient")

is(p3)
class(p3)

is(p3, "Patient")
is(p1, "In-patient")

p4 <- as(p1, "In-patient")
str(p4)
as.character(p4)

setAs("Patient", "character", 
      function(from) from@pname)
a <- as(p4, "character")
str(a)

setGeneric("DaysInHospital", 
           function(object, ...) standardGeneric("DaysInHospital"))
setMethod("DaysInHospital", "In-patient",
          function(object) Sys.Date() - object@DOA)
DaysInHospital(p3)

show(p3)
setMethod("show",
          "In-patient",
          function(object) {
            callNextMethod()
            writeLines(sprintf("DOA is %s", object@DOA))
          })
p3

setClass("ICU-patient",
         contains = "In-patient",
         slots = c(reason = "character"),
         prototype = list(reason = character()))
p5 <- NewPatient3(333, "Jenny", 
                  DOA=as.Date("2022-09-20"), 
                  reason="stroke", 
                  Class="ICU-patient")
p5
str(p5)
is(p5)
is(p5, "In-patient")


# Direction example
setClass("Direction", 
         slots = c(theta = "numeric")) # theta in [0, 1)
a <- new("Direction", theta=c(0, 0.5))
a

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
AddNumToDirection(1.5, d2)

setMethod(`+`, c("Direction", "numeric"),
          function(e1, e2) AddNumToDirection(e2, e1))
setMethod(`+`, c("numeric", "Direction"),
          function(e1, e2) AddNumToDirection(e1, e2))

d1 + 0.5
0.5 + d1

setMethod(`+`, c("Direction", "Direction"),
          function(e1, e2) AddNumToDirection(e1@theta, e2))
d1 + d1

setClass("Location", 
         slots = c(loc = "matrix"),
         prototype = list(loc=matrix(NA_real_, nrow=2, ncol=0)))
l1 <- new("Location")
l2 <- new("Location", loc= matrix(as.numeric(1:6), 2, 3))

setClass("DirectionField",
         contains = c("Direction", "Location"))
dl2 <- new("DirectionField", d2, l2)
dl2

dl2 + dl2

