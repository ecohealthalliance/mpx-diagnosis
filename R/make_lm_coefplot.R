#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param bas_linear_model
#' @return
#' @author 'Noam Ross'
#' @export
make_lm_coefplot <- function(bas_linear_model) {

  draws <- as_draws_df(bas_linear_model) |>
    gather_draws(`b_.*`, regex=TRUE) |>
    filter(!.variable %in% c("b_Intercept")) |>
    group_by(.variable) |>
    mutate(label = stri_replace_all_regex(.variable, "^?b_", "")) |>
    mutate(label = stri_replace_all_fixed(label, bas_var_names, names(bas_var_names), vectorize_all = FALSE, case_insensitive = TRUE)) |>
    mutate(label = stri_replace_all_fixed(label, "_", ":")) |>
    mutate(label = paste0(label, " (", signif(exp(mean(.value)), 2), ")")) |>
    mutate(sig = sum(.value > 0)/n()) |>
    ungroup() |>
    mutate(dir = xor(.value > 0, sig > 0.5 ))


  bas_lm_coefplot <- ggplot(
    draws,
    aes(x = .value, y = fct_reorder(label, .value, \(x) sum(x > 0)/length(x)),
        fill = stat(x > 0))) +
    stat_halfeye(p_limits = c(0.2, 0.8)) +
    scale_x_continuous(limits = quantile(draws$.value, c(0.01, 0.99)),
                       breaks = log(c(0.01, 0.1, 1, 10, 100)),
                       labels = exp) +
    scale_fill_manual(values = viridis::plasma(2, begin = 0.1, end = 0.75, alpha = 0.7)) +
    labs(x = "Odds Ratio") +
    theme_bw() +
    theme(axis.title.y = element_blank(), legend.position = "none")

 # rm(bas_linear_model, draws)
  bas_lm_coefplot

}

