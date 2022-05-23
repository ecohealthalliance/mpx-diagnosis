#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param bas_data Imported data
#' @return
#' @author 'Noam Ross'
#' @export
clean_bas_data <- function(bas_data) {

  dat <- bas_data |> janitor::clean_names()
  bas_cleaned <- dat |>
    select(id, agecat, sex, vacv_scar, fever_beforerash, rash_stages, rash_palm,
           rash_soles, lymphadenitis, occularlesions_type, pcr_mpx, pcr_vzv) |>
    filter(!is.na(pcr_mpx)) |>
    mutate(lymphadenitis = as.integer(lymphadenitis),
           rash_monomorphic = as.integer(rash_stages == "UN"),
           occ_lesion_un = as.integer(occularlesions_type == "U"),
           occ_lesion_bi = as.integer(occularlesions_type == "BI"),
           sex_male = as.integer(sex == "M"),
           mpx_pcr_pos = as.integer(pcr_mpx == "Positive"),
           vzv_pcr_pos = as.integer(pcr_vzv == "Positive"),
           vacv_scar = coalesce(vacv_scar, 0))
  ages <- bind_cols(as_tibble(model.matrix(~agecat, mutate(bas_cleaned, agecat = as.factor(agecat), .keep="none"))[,-1]))
  bas_cleaned <- bind_cols(bas_cleaned, ages) |>
    select(-occularlesions_type, -rash_stages, -sex, -pcr_mpx, -pcr_vzv, -agecat)

  bas_cleaned
}

bas_var_names = c(
  `Age` = "age",
  `VACV scar` = "vacv_scar",
  `Fever prodrome` = "fever_beforerash",
  `Rash on palms` = "rash_palm",
  `Rash on soles` = "rash_soles",
  `Lymphadenopathy` = "lymphadenitis",
  `Monomorphic rash` = "rash_monomorphic",
  `Uni. ocular lesion` = "occ_lesion_un",
  `Bi. ocular lesion` = "occ_lesion_bi",
  `Male` = "sex_male",
  `MPX PCR+` = "mpx_pcr_pos",
  `VZV PCR+ Positive` = "vzv_pcr_pos",
  `Age 5-15` = "agecat2",
  `Age 15-25` = "agecat3",
  `Age 25-40` = "agecat4",
  `Age >40` = "agecat5"
)
