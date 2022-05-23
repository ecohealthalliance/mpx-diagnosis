#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param bas_data
#' @return
#' @author 'Noam Ross'
#' @export
prep_training_data <- function(bas_train) {
  mm <- bas_train |> select(-id, -vzv_pcr_pos) |>
    make_matrix(outcome_var = "mpx_pcr_pos")

  n1 <- remove_colinear_columns(mm$model_matrix)
  n2 <- remove_colinear_columns(n1$intermediate_matrix)

  bas_train_prepped <- bind_cols(
    select(bas_train, mpx_pcr_pos),
    as_tibble(n2$intermediate_matrix)
  ) |>
    janitor::clean_names()

  bas_train_prepped
}

prep_validate_data <- function(bas_validate, bas_train_prepped) {
  mm <- bas_validate |> select(-id, -vzv_pcr_pos) |>
    make_matrix(outcome_var = "mpx_pcr_pos")

  bas_validate_prepped <- as_tibble(mm$model_matrix) |>
    bind_cols(bas_validate |> select(mpx_pcr_pos)) |>
    janitor::clean_names() |>
    select(names(bas_train_prepped))

  bas_validate_prepped
}
