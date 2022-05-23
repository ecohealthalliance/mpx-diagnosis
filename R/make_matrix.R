#' Functions to make matrix for lasso analysis
#' @param dat tibble or dataframe with TRUE/FALSE values
#' @param outcome_var name(s) of outcome fields in dat
#' @param interactions TRUE/FALSE include interactions in matrix. Default is TRUE.
#' @param interaction_vars if interactions = TRUE, which variables should interact? NULL (default) is all variables.
#' @param interaction_regex whether interaction_vars are set up for regex
#' @import dplyr tidyr purrr
#' @importFrom assertthat assert_that are_equal
#' @importFrom stats model.matrix
#' @importFrom stringr str_replace_all str_split str_detect
#' @export
make_matrix <- function(dat,
                        outcome_var,
                        interactions = TRUE,
                        interaction_vars = NULL,
                        interaction_regex = FALSE) {
  assertthat::assert_that(all(purrr::map_lgl(dat, ~is.logical(.) || all(. %in% c(0, 1)))), msg = "all columns in data must be logical")

  # Get outcome dat
  outcome_matrix <- dat %>%
    select(!!outcome_var) %>%
    mutate_all(~as.numeric(.)) %>%
    as.matrix()

  # Remove outcome vars
  dat <- dat %>%
    select(-!!outcome_var)

  # Define basic model formula
  form <- as.formula(paste0(' ~ ', ' + ', '.'))

  # Define full interaction formula
  if(interactions){
    form <- as.formula(paste0(' ~ ', ' + ', '.', ' + ', '(.)^2'))
  }

  # Generate initial model matrix and remove intercept
  model_matrix <- stats::model.matrix(form, data = dat)
  model_matrix <- model_matrix[ , -1]

  # Clean up matrix column names
  colnames(model_matrix) <- colnames(model_matrix) %>%
    stringr::str_replace_all(., "TRUE", "") %>%
    stringr::str_replace_all(., "`", "")

  # Apply interactions
  if(!is.null(interaction_vars)){

    # get and split all interactions
    all_interactions <- colnames(model_matrix)[grep(":", colnames(model_matrix))]
    x_split <- str_split(all_interactions, ":")

    # find interactions that should be included either by regex(if) or exact(else)
    if(interaction_regex){
      interaction_vars_collapse <- paste(interaction_vars, collapse = "|")
      x_detect <- map(x_split, ~str_detect(., paste(interaction_vars, collapse = "|")))
    }else{
      x_detect <- map(x_split, ~. %in% interaction_vars)
    }

    included_interactions <- map_lgl(x_detect, ~any(.)) %>%
      all_interactions[.]

    included_cols <- c(colnames(dat), included_interactions)
    included_index <- which(colnames(model_matrix) %in% included_cols)
    assertthat::are_equal(length(included_cols), length(included_index))
    model_matrix <- model_matrix[, included_index]
  }

  return(list(model_matrix = model_matrix, outcome_matrix = outcome_matrix))
}
