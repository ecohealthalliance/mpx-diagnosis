#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param bas_cleaned
#' @return
#' @author 'Noam Ross'
#' @export
make_bas_corrplot <- function(bas_cleaned) {
  cmat <- cor(bas_cleaned |> select(-id), use = "pairwise.complete.obs")
  pmat <- cor_pmat(bas_cleaned |> select(-id), use = "pairwise.complete.obs")
  bas_corplot <- ggcorrplot(cmat, p.mat = pmat, lab= TRUE, lab_size = 2,
                            pch.col ="#949494DB") +
    scale_fill_continuous_diverging(palette = "Purple-Green") +
    labs(
      title = "Correlation Between Symptons and PCR detection\nof MPX and VZV",
      caption = "Crossed-out correlations not significant") +
    theme(panel.grid = element_blank(), plot.title.position = "plot")
  rm(bas_cleaned)
  bas_corplot
}
