# remotes::install_github("pbs-assess/gfdata")
source("R/utils.R")

# Read survey dogfish catch from GFBio for area 4B
catch_survey <- gfdata::get_survey_index(
  species = "044",
  ssid = c(39, 40)
)

# View 
tibble::view(catch_survey)
# Write 
write_data(catch_survey, path = "data/raw")
