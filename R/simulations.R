##' Generate chains from a branching process with negative binomial
##' offspring distribution
##'
##' @param R mean of the offspring distribution
##' @param k dispersion of the offspring distribution
##' @param n number of outbreaks to simulate
##' @param init number of individuals in the first generation
##' @return vector of samples
##' @author Sebastian Funk
nbbpChains <- function(R, k, n = 1, init = 1, max) {
    chains <- c()
    for (i in 1:n) {
    success <- FALSE
    while (!success) {
      newCases <- init
      chainSize <- newCases
      while (newCases > 0 & (missing(max) || (chainSize <= max))) {
        newCases <- sum(rnbinom(newCases, k, 1 / (1 + R / k)))
        chainSize <- chainSize + newCases
      }
      if (missing(max) || (chainSize <= max)) success <- TRUE
    }
    chains <- c(chains, chainSize)
  }
  chains
}

##' Generate chains from a branching process with mixed borel-gamma
##' offspring distribution
##'
##' @param mean mean of the offspring distribution
##' @param k dispersion of the offspring distribution
##' @param n number of outbreaks to simulate
##' @param init number of individuals in the first generation
##' @return vector of samples
##' @author Sebastian Funk
gborChains <- function(R, k, n = 1, init = 1, max) {
  chains <- c()
  for (i in 1:n) {
    success <- FALSE
    while (!success) {
      newCases <- init
      chainSize <- newCases
      currentR <- rgamma(newCases, shape = R * k / (R + k), scale = 1 + R / k)
      while (newCases > 0 & (missing(max) || (chainSize <= max))) {
        newCases <- sum(rpois(newCases, currentR))
        chainSize <- chainSize + newCases
      }
      if (missing(max) || (chainSize <= max)) success <- TRUE
    }
    chains <- c(chains, chainSize)
  }
  chains
}
