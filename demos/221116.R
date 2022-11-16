n <- 1e2
m <- 1e7
l <- lapply(seq_len(n), function(i) rep(1, m))
system.time(lapply(l, sum))                      # 1.562s, single core

library(future)
future::plan(sequential)
system.time(future.apply::future_lapply(l, sum)) # 1.565s, single core

future::plan(multisession, workers=2)
system.time(future.apply::future_lapply(l, sum)) # 7.738s on my mac

future::plan(multicore, workers=2)
system.time(future.apply::future_lapply(l, sum)) #


library(future.apply)
system.time(future_lapply(l, sum))# Static schedule    1.093s
system.time(future_lapply(l, sum,                 #   Dynamic
                          future.chunk.size = 1))    # 1.849s

system.time(future_lapply(c(.1, .1, 1, 1),          # Static
                          function(x) Sys.sleep(x))) # 2.030s
system.time(future_lapply(c(.1, .1, 1, 1), 
                          function(x) Sys.sleep(x), # Dynamic
                          future.chunk.size = 1))    # 1.162s

library(future)
plan(multisession, workers=2)
f1 <- future({
  Sys.sleep(10)
  lm(extra ~ group, data=sleep)
})

library(future)
plan(multisession, workers=2)
f2 <- future({
  Sys.sleep(5)
  lm(extra ~ group, data=sleep)
})
f1
m1 <- value(f1)
summary(m1)
value(f2)


x <- 1
value(future({
  y <- get("x")
  print(y)
}))

value(future({
  y <- get("x")
  print(y)
}, globals = list(x = x)))
