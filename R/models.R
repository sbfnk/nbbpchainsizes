##' Compare models for two sets of chain sizes, based on branching
##' processes with negative binomail offspring distributions
##'
##' This compares models where
##'   1) the two sets of chain sizes have different R and different k
##'   2) the two sets of chain sizes have different R and the same k
##'   3) the two sets of chain sizes have different R and the same k = 1
##'   4) the two sets of chain sizes have the same R and different k
##'   5) the two sets of chain sizes have the same R and the same k
##'   6) the two sets of chain sizes have the same R and the same k = 1
##' @param chains1 first vector of sizes to which to match the branching process
##' @param chains2 second vector of sizes to which to match the branching process
##' @return a list of the best fitting parameters, likelihoods and AIC
##' scores of the different models
##' @author Sebastian Funk
nbbpCompareModels <- function(chains1, chains2) {
    ret <- list()

    R.1 <- 1 - 1 / mean(chains1)
    R.2 <- 1 - 1 / mean(chains2)
    R.all <- 1 - 1 / mean(c(chains1, chains2))

    if (R.1 < 1e-9) { R.1 <- 1e-9 }
    if (R.2 < 1e-9) { R.2 <- 1e-9 }
    if (R.all < 1e-9) { R.all <- 1e-9 }

    ret[[1]] <- list()
    ret[[1]]$restriction <- "None"
    temp <- optim(par = c(0.1, 0.1),
                  lower = c(1e-9, 1e-9),
                  fn = function(x) {
                      -nbbpLikelihood(chains1, x[1], R.1) -
                          nbbpLikelihood(chains2, x[2], R.2)
                  },
                  method = "L-BFGS-B")
    ret[[1]]$par <- temp$par
    ret[[1]]$likelihood <- 0
    ret[[1]]$aic <- 2 * (length(temp$par) + 2) + 2 * temp$value
    norest <- temp$value

    ret[[2]] <- list()
    ret[[2]]$restriction <- "same k"
    temp <- optim(par = c(0.1),
                  lower = c(1e-9),
                  fn = function(x) {
                      -nbbpLikelihood(chains1, x[1], R.1) -
                          nbbpLikelihood(chains2, x[1], R.2)
                  },
                  method = "L-BFGS-B")
    ret[[2]]$par <- temp$par
    ret[[2]]$likelihood <- norest - temp$value
    ret[[2]]$aic <- 2 * (length(temp$par) + 2) + 2 * temp$value

    ret[[3]] <- list()
    ret[[3]]$restriction <- "same R"
    temp <- optim(par = c(0.1, 0.1, 0.5),
                  lower = c(1e-9, 1e-9, 1e-9),
                  fn = function(x) {
                      -nbbpLikelihood(chains1, x[1], x[3]) -
                          nbbpLikelihood(chains2, x[2], x[3])
                  },
                  method = "L-BFGS-B")
    ret[[3]]$par <- temp$par
    ret[[3]]$likelihood <- norest - temp$value
    ret[[3]]$aic <- 2 * (length(temp$par)) + 2 * temp$value

    ret[[4]] <- list()
    ret[[4]]$restriction <- "k = 1"
    temp <- list(
        value = -nbbpLikelihood(chains1, 1, R.1) -
                   nbbpLikelihood(chains2, 1, R.2),
        par = c()
        )
    ret[[4]]$par <- temp$par
    ret[[4]]$likelihood <- norest - temp$value
    ret[[4]]$aic <- 2 * (length(temp$par) + 2) + 2 * temp$value

    ret[[5]] <- list()
    ret[[5]]$restriction <- "same R, same k"
    temp <- optim(par = c(0.1),
                  lower = c(1e-9),
                  fn = function(x) {
                      -nbbpLikelihood(chains1, x[1], R.all) -
                          nbbpLikelihood(chains2, x[1], R.all)
                  },
                  method = "L-BFGS-B")
    ret[[5]]$par <- temp$par
    ret[[5]]$likelihood <- norest - temp$value
    ret[[5]]$aic <- 2 * (length(temp$par) + 1) + 2 * temp$value

    ret[[6]] <- list()
    ret[[6]]$restriction <- "same R, k = 1"
    temp <- list(
        value = -nbbpLikelihood(chains1, 1, R.all) -
                   nbbpLikelihood(chains2, 1, R.all),
        par = c()
        )
    ret[[6]]$par <- temp$par
    ret[[6]]$likelihood <- norest - temp$value
    ret[[6]]$aic <- 2 * (length(temp$par) + 1) + 2 * temp$value

    ret[[7]] <- list()
    ret[[7]]$likelihoods <- c(ret[[1]]$likelihood, ret[[2]]$likelihood, ret[[3]]$likelihood, ret[[4]]$likelihood, ret[[5]]$likelihood, ret[[6]]$likelihood)
    ret[[7]]$aic <- c(ret[[1]]$aic, ret[[2]]$aic, ret[[3]]$aic, ret[[4]]$aic, ret[[5]]$aic, ret[[6]]$aic)
    ret[[7]]$information.loss <- exp((min(ret[[7]]$aic) - ret[[7]]$aic)/2)
    ret[[7]]$best <- ret[[which(ret[[7]]$aic == min(ret[[7]]$aic))]]$restriction

    return (ret)
}

##' Compare models for sets of chain sizes constructed from
##' simulations with different values of R
##'
##' This is to test type I and II error of the model. It increases the
##' number of (simulated and) observed chains step by step and
##' compares the models on these data a number of times.
##' @param R1 R_\mathrm{eff} of the first set of chains
##' @param R2 R_\mathrm{eff} of the second set of chains
##' @param k dispersion (assumed to be the same)
##' @param n number of times to repeat the simulations for each number of chains
##' @param max maximal number of chains
##' @param fixn1 whether to fix the number of chains in the first set
##' (if > 0) and, if, yes, to which number
##' @param fixn1 whether to fix the number of chains in the second set
##' (if > 0) and, if, yes, to which number
##' @param chains1 whether to compare simulations to an existing set of chains (if not NULL) -- if not NULL, a vector of that set of chains
##' @return a data frame with likelihoods for the different models for
##' each simulation run
##' @author Sebastian Funk
nbbpCompareSims <- function(R1, R2, k, n = 100, max = 100, fixn1 = 0, fixn2 = 0,
                            chains1 = NULL) {
    res <- NULL
    if (fixn2 > 0) {
        max = fixn2
    }
    i <- 0
    while (i < max) {
        i <- ceiling(i + i/10)
        if (i == 0) { i <- 1 }
        if (fixn1 == 0) {
          n1 <- i
        } else {
          n1 <- fixn1
        }
        if (fixn2 > 0) {
            i <- max
        }
        current.res <- t(sapply(seq(1, n), function(x) {
            if (length(chains1) > 0) {
                ll <- nbbpCompareModels(chains1,
                                    nbbpChains(k=k, R=R2, n=i))[[7]]$likelihoods
            } else {
                ll <- nbbpCompareModels(outbreakChain(k=k, R=R1, n=n1),
                                    nbbpChains(k=k, R=R2, n=i))[[7]]$likelihoods
            }
            names(ll) <- c("none", "same.k", "same.R", "k.1", "same.R.same.k",
                           "same.R.k.1")
            c(R1 = R1, R2 = R2, k = k, nb.clusters = i, ll)
        }))
        if (is.null(res)) {
            res <- current.res
        } else {
            res <- rbind(res, current.res)
        }
    }

    return(res)
}
