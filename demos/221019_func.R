
SIR_orig <- function(duration, dt, beta, gamma, initial) {
  res <- matrix(initial, nrow=1)
  len <- floor(duration / dt) + 1
  for (i in seq(2, len)) {
    # dS = -beta * S * I dt
    S <- res[i - 1, 1] - beta * res[i - 1, 1] * res[i - 1, 2] * dt
    # dI = (beta * S * I - gamma * I) dt
    I <- res[i - 1, 2] + (beta * res[i - 1, 1] * res[i - 1, 2] - 
                            gamma * res[i - 1, 2]) * dt
    # dR = gamma * I * dt
    R <- res[i - 1, 3] + gamma * res[i - 1, 2] * dt
    res <- rbind(res, c(S, I, R))
  }
  list(SIR=res, T=seq(0, duration, by=dt))
}

SIR_prealloc <- function(duration, dt, beta, gamma, initial=c(0.999, 0.001, 0)) {
  len <- floor(duration / dt) + 1
  res <- matrix(0, len, 3)
  res[1, ] <- initial
  for (i in seq(2, len)) {
    res[i, 1] <- res[i - 1, 1] - beta * res[i - 1, 1] * res[i - 1, 2] * dt
    res[i, 2] <- res[i - 1, 2] + (beta * res[i - 1, 1] * res[i - 1, 2] - 
                                    gamma * res[i - 1, 2]) * dt
    res[i, 3] <- res[i - 1, 3] + gamma * res[i - 1, 2] * dt
  }
  list(SIR=res, T=seq(0, duration, by=dt))
}
