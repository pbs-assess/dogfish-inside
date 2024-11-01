# remotes::install_github('pbs-assess/gfdata')
library(gfdata)

# Read data
d <- gfdata::get_survey_samples(
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
tibble::view(d)
# Write 
saveRDS(d, file = "data/raw/samples-survey.rds")
