# remotes::install_github('pbs-assess/gfdata')
library(gfdata)
source("R/utils.R")

# Read data
samples_survey <- gfdata::get_survey_samples(
  species = "044",
  ssid = c(39, 40)
) |>
  dplyr::filter(
    major_stat_area_code == "01",
  ) |>
  dplyr::select(
    -tidyselect::starts_with("dna")
  )

# View 
tibble::view(samples_survey)
# Write 
write_data(samples_survey, path = "data/raw")
