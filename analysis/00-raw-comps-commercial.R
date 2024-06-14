# remotes::install_github('pbs-assess/gfdata')
library(gfdata)
source("R/utils.R")

# Read commercial composition data from GFBio for area 4B
comps_commercial <- gfdata::get_commercial_samples(
  species = "044",
  unsorted_only = TRUE,
  return_all_lengths = FALSE
) |>
  dplyr::filter(
    major_stat_area_code == "01",
  ) |>
  # Privacy (and extra) removals
  dplyr::select(
    -tidyselect::starts_with("dna"),
    -tidyselect::starts_with("vessel")
  )

# View 
tibble::view(comps_commercial)
# Write 
write_data(comps_commercial, path = "data/raw")
