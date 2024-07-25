# remotes::install_github('pbs-assess/gfdata')
library(gfdata)
source("R/utils.R")

# Read data
d <- gfdata::get_commercial_samples(
  species = "044",
  unsorted_only = FALSE,
  return_all_lengths = FALSE # TODO: Returns fewer when true?
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
tibble::view(d)
# Write 
saveRDS(d, file = "data/raw/samples-commercial.rds")
