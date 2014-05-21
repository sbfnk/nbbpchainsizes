##' Generate chains from a branching process with negative binomial
##' offspring distribution
##'
##' @param R mean of the offspring distribution
##' @param k dispersion of the offspring distribution
##' @param n number of outbreaks to simulato
##' @param init number of individuals in the first generation
##' @return vector of samples
##' @author Sebastian Funk
nbbpChains <- function(R, k, n = 1, init = 1) {
  chains <- c()
  for (i in 1:n) {
    newCases <- init
    chainSize <- newCases
    while (newCases > 0) {
      newCases <- sum(rnbinom(newCases, k, 1 / (1 + R / k)))
      chainSize <- chainSize + newCases
    }
    chains <- c(chains, chainSize)
  }
  chains
}
