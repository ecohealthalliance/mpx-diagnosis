
# Load packages/functions --------
# Been having an issue where tidyverse won't load unless Matrix is loaded first
suppressPackageStartupMessages(source('packages.R'))

for (r_file in list.files("R", pattern = "\\.R$", recursive = TRUE, full.names = TRUE)) try(source(r_file))

tar_option_set(
  resources = tar_resources(
    qs = tar_resources_qs(preset = "fast")),
  format = "qs"
)

data_targets <- tar_plan(
  tar_file(bas_excel, "data/datbase_MPX_final_948.xls"),
  bas_data = read_xls(bas_excel,sheet = "Sheet1"),
  bas_cleaned = clean_bas_data(bas_data),
  bas_split = initial_split(bas_cleaned, prop = 0.749, strata = "mpx_pcr_pos"),
  bas_train = training(bas_split),
  bas_train_prepped = prep_training_data(bas_train),
  bas_validate = testing(bas_split),
  bas_validate_prepped = prep_validate_data(bas_validate, bas_train_prepped)
)

analysis_targets <- tar_plan(
  bas_linear_model = fit_bas_linear(bas_train_prepped)
#  bas_dbarts_model = fit_bas_dbarts(bas_train_prepped)
)

plot_targets <- tar_plan(
  bas_corrplot = make_bas_corrplot(bas_cleaned),
  bas_lm_coefplot = make_lm_coefplot(bas_linear_model)
)

output_targets <- tar_plan(
  tar_file(corrplot_file,
             ggsave("outputs/bas_corrplot.png", bas_corrplot,
                    dpi = 300, units = "in", width = 6, height = ,
                    bg = "white")),
  tar_file(lm_coefplot_file,
           ggsave("outputs/bas_lm_coefplot.png", bas_lm_coefplot,
                  dpi = 300, units = "in", width = 6, height =10,
                  bg = "white")),
  tar_render(model_diagnostics,
             path = "reports/model-diagnostics.Rmd",
             output_dir = "outputs"),
  tar_render(readme,
             path = "README.Rmd",
             output_dir = here::here())
)

list(
  data_targets,
  analysis_targets,
  plot_targets,
  output_targets
)
