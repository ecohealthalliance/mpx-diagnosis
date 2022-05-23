#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param bas_train
#' @return
#' @author 'Noam Ross'
#' @export
fit_bas_linear <- function(bas_train_prepped, nproc = 4) {

  frm <- bf(
    as.formula(paste("mpx_pcr_pos ~ ", paste(names(bas_train_prepped |> select(-mpx_pcr_pos)), collapse = " + ")))
  )
  #n_vars <- 20
  #pratio <- n_vars / (ncol(bas_train_prepped - 1) - n_vars)
  #pri <- prior_string(paste0("horseshoe(par_ratio = ", pratio, ", scale_slab = 999)"), class = "b")
  pri <- prior(student_t(3, 0, 2.5), class= "b")
  bas_linear_model <- brm(
    formula = frm, data = bas_train_prepped, prior = pri, family = bernoulli(),
    iter = 4000, warmup = 2000,
    control = list(adapt_delta = 0.99, max_treedepth = 12),
    sample_prior = "yes",
    chains = 4, backend = "cmdstanr", cores = nproc,
  )
  bas_linear_model

}
