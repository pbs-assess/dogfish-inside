# remotes::install_github('pbs-assess/gfdata')
library(gfdata)
source("R/utils.R")

# Read survey composition data from GFBio for area 4B
comps_survey <- gfdata::get_survey_samples(
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
tibble::view(comps_survey)
# Write 
write_data(comps_survey, path = "data/raw")
