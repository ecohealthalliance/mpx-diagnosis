#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param bas_train
#' @return
#' @author 'Noam Ross'
#' @export
fit_bas_dbarts <- function(bas_train_prepped, ncores = 4) {

  cv <- xbart(
    mpx_pcr_pos ~ .,
    data = bas_train_prepped,
    n.samples = 100, n.reps = 10,
    k = c(3,4,5),
    power = c(0.7, 0.9, 1.1, 1.3),
    base = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7),
    n.test = 10,
    loss = "log",
    n.threads = ncores)

  cvmean <- apply(cv, c(2,3,4), mean)

  priors <- which(cvmean==min(cvmean), arr.ind = TRUE)

  bas_dbarts_model <- bart2(
    mpx_pcr_pos ~ .,
    data = bas_train_prepped,
    k = c(1,2,3)[priors[1]],
    power = c(1.5, 1.6, 1.7, 1.8, 1.9, 2)[priors[2]],
    base = c(0.75, 0.8, 0.85, 0.9, 0.95)[priors[3]],
    keepTrees = TRUE)

  invisible(bas_dbarts_model$fit$state)
  bas_dbarts_model
}


