# remotes::install_github("pbs-assess/gfdata")
source("R/utils.R")

# Read HBLL survey catch data from GFBio for area 4B
d <- gfdata::get_survey_sets(
  species = "044", 
  ssid = c(39, 40)
) |> 
  dplyr::rename(
    survey = survey_desc,
    ssid = survey_series_id
  )
# View 
tibble::view(d)
# Write 
saveRDS(d, file = "data/raw/catch-survey.rds")
