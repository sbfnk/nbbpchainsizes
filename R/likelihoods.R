  log.sum.exp<- function(x) {
    ## Computes log(sum(exp(x))
    ## Uses offset trick to avoid numeric overflow: https://stat.ethz.ch/pipermail/r-help/2011-February/269205.html
    
    xmax <- which.max(x)
    log1p(sum(exp(x[-xmax]-x[xmax])))+x[xmax]
  }

##' Likelihood for the outcome of a branching process with negative
##' binomial offspring distribution
##'
##' @param chains vector of sizes to which to match the branching process
##' @param k dispersion of the offspring distribution
##' @param R mean of the offspring distribution
##' @param log hether to return log-likelihood
##' @return likelihood
##' @author Sebastian Funk
nbbpLikelihood <- function(chains, k, R, log = TRUE, exclude.1 = FALSE, infinite = Inf)
{
  nb.likelihood <- function(x)
  {
    if (log) {
      lgamma(k * x + (x - 1)) - (lgamma(k * x) + lgamma(x + 1)) +
        (x - 1) * log (R / k) -
        (k * x + (x - 1)) * log(1 + R / k)
    } else {
      gamma(k * x + (x - 1)) / (gamma(k * x) * gamma(x + 1)) * (R / k) ^ (x - 1) / (1 + R / k) ^ (k * x + (x - 1))
    }
  }

  if (any(chains >= infinite)) {
    calc_sizes <- seq_len(infinite)
  } else {
    calc_sizes <- unique(c(1, chains))
  }

  likelihoods <- c()
  likelihoods[calc_sizes] <- sapply(calc_sizes, nb.likelihood)

  if (exclude.1) {
    if (log) {
      likelihoods <- likelihoods - log(-expm1(likelihoods[1]))
      likelihoods[1] <- -Inf
    } else {
      likelihoods <- likelihoods / (1 - likelihoods[1])
      likelihoods[1] <- 0
    }
  }

  if (log) {
    sexpl <- sum(exp(likelihoods))
    if (sexpl < 1) {
      maxl <- log(1 - sum(exp(likelihoods)))
    } else {
      maxl <- -Inf
    }
  } else {
    sl <- sum(likelihoods)
    if (sl < 1) {
      maxl <- 1 - sum(likelihoods)
    } else {
      maxl <- 0
    }

  }
  likelihoods <- c(likelihoods, maxl)

  chains[chains > infinite] <- infinite + 1
  chain_likelihoods <- likelihoods[chains]

  if (log) {
    result <- sum(chain_likelihoods)
  } else {
    result <- prod(chain_likelihoods)
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
nbbpPointSourceLikelihood <- function(chains, lik, log = TRUE, ...) {
  if (log) {
      result <- lik(chains, log = log, ...) -
          lik(rep(0, length(chains)), log = log, ...)
  } else {
      result <- lik(chains, log = log, ...) /
          lik(rep(0, length(chains)), log = log, ...)
  }
  return(result)
}

##' Likelihood for the outcome of a branching process with mixed
##' gamma-borel outbreak distribution
##'
##' @param chains vector of sizes to which to match the branching process
##' @param alpha alpha parameter of the gamma distribution
##' @param beta beta parameter of the gamma distribution
##' @param log hether to return log-likelihood
##' @return likelihood
##' @author Sebastian Funk
gborLikelihood <- function(chains, k, R, log = T, exclude.1 = FALSE, infinite = Inf) {
    point.likelihood <- function(x, log = TRUE) {
      if (log) {
        ret <- -Inf
        if (x >= infinite) {
          ret <- log1p(-exp(log.sum.exp(sapply(seq_len(infinite - 1), function(x) {
            lgamma(k + x - 1) - (lgamma(x + 1) + lgamma(k)) - k * log(R / k) + (x-1) * log(x) - (k + x - 1) * log(x + k / R)
          }))))
        }
        if (!is.finite(ret)) {
          ret <- lgamma(k + x - 1) - (lgamma(x + 1) + lgamma(k)) - k * log(R / k) + (x-1) * log(x) - (k + x - 1) * log(x + k / R)
        }
      } else {
        ret <- gamma(k + x - 1) / (gamma(x + 1) * gamma(k)) * x ^ (x - 1) / (((R / k) ^ k) * (x + k / R)^(k + x - 1))
      }
      return(ret)
    }
    chain.likelihoods <- sapply(chains, point.likelihood)
    if (log) {
      result <- sum(chain.likelihoods)
      if (exclude.1) {
          result <- result - point.likelihood(1) 
      }
    } else {
      result <- prod(chain.likelihoods)
      if (exclude.1) {
          result <- result / point.likelihood(1) 
      }
    }
    return(result)
}
