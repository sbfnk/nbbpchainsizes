##' Likelihood for the outcome of a branching process with negative
##' binomail offspring distribution
##'
##' @param chains vector of sizes to which to match the branching process
##' @param k dispersion of the offspring distribution
##' @param R mean of the offspring distribution
##' @param log hether to return log-likelihood
##' @return likelihood
##' @author Sebastian Funk
nbbpLikelihood <- function(chains, k, R, log = T) {
    if (log) {
      result <- sum(sapply(chains, function(x) {
        lgamma(k * x + x - 1) - (lgamma(k * x) + lgamma(x + 1)) + (x - 1) * log (R / k) - (k * x + x - 1) * log(1 + R / k)
      }))
    } else {
      result <- prod(sapply(chains, function(x) {
        gamma(k * x + x - 1) / (gamma(k * x) * gamma(x + 1)) * (R / k) ^ (x - 1) / (1 + R / k) ^ (k * x + x - 1)
      }))
    }
    return(result)
}

##' Likelihood for the outcome of a branching process with negative
##' binomail offspring distribution originating from a point source
##' (which itself is not being counted
##'
##' This is accounting for the fact that 0-size outbreaks are not being observed
##' @param chains vector of sizes to which to match the branching process
##' @param k dispersion of the offspring distribution
##' @param R mean of the offspring distribution
##' @param log hether to return log-likelihood
##' @return likelihood
##' @author Sebastian Funk
nbbpPointSourceLikelihood <- function(chains, k, R, log = F) {
  if (log) {
    result <- nbbpLikelihood(chains, k, R, log) - nbbpLikelihood(rep(0, length(chains)), k, R, log)
  } else {
    result <- nbbpLikelihood(chains, k, R, log) / nbbpLikelihood(rep(0, length(chains)), k, R, log)
  }
  return(result)
}

