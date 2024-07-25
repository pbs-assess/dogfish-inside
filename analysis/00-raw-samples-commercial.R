# remotes::install_github('pbs-assess/gfdata')
library(gfdata)
source("R/utils.R")

# Read data
samples_commercial <- gfdata::get_commercial_samples(
  species = "044",
  unsorted_only = FALSE,
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
tibble::view(samples_commercial)
# Write 
write_data(samples_commercial, path = "data/raw")
