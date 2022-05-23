#' Remove duplicate and colinear columns
#' @param model_matrix matrix produced by make_matrix()
#' @param verbose Show progress bar and messages?
#' @import dplyr tidyr purrr
#' @importFrom Matrix rankMatrix
#' @export
remove_colinear_columns <- function(model_matrix,
                                    verbose = interactive()) {

  #warning('This function requires large amounts of compute power.')

  # remove duplicate columns (set back to tibble for this)
  #model_tibble <- as_tibble(model_matrix)
  #intermediate_matrix <- model_tibble[!duplicated(as.list(model_tibble))] %>% as.matrix()
  intermediate_matrix <- model_matrix

  # get rank of matrix
  mat_rank <- rankMatrix(intermediate_matrix, warn.t = FALSE)
  if(verbose) message('\nMatrix Rank: ', mat_rank)

  if(verbose) message("Rank reduction round 1")
  pb <- progress_estimated(ncol(intermediate_matrix), min_time=5)
  for(ii in rev(seq_len(ncol(intermediate_matrix)))) {
    pb$tick()$print()
    tmp_matrix <- intermediate_matrix[,-ii]
    tmp_rank <- rankMatrix(tmp_matrix, warn.t = FALSE)
    if(tmp_rank == mat_rank) { #if rank unchanged with removal
      intermediate_matrix <- tmp_matrix
    }
  }

  if(verbose) message("Rank reduction round 2")
  pb <- progress_estimated(ncol(intermediate_matrix), min_time=5)
  for(ii in rev(seq_len(ncol(intermediate_matrix)))) {
    pb$tick()$print()
    tmp_matrix <- intermediate_matrix[,-ii]
    tmp_rank <- rankMatrix(tmp_matrix, warn.t = FALSE)
    if(tmp_rank == mat_rank) { #if rank unchanged with removal
      intermediate_matrix <- tmp_matrix

    }
  }

  removed_ii <- (!(colnames(model_matrix) %in% colnames(intermediate_matrix)))
  removed_vars <- colnames(model_matrix)[removed_ii]
  return(list(removed_vars = removed_vars, intermediate_matrix = intermediate_matrix))
}
