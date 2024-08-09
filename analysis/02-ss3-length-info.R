# Load
library(dplyr)
library(tibble)
# Source
source("R/utils.R")

# Define data ------------------------------------------------------------------

# Fleet names
# To edit fleet names update fleet() in R/utils.R
fleet_name <- fleet() |> pull(fleet_name) |> str_replace_all(" ", "_")

d <- tibble::tibble(
  # Min tail compression: -1 = no compression
  min_tail_comp = rep(-1L, length(fleet_name)),
  # Added constant to proportions: 
  add_to_comp = 1e-04,
  # Combine males and females
  combine_sexes = 0,
  # Compress bins: condense the final n bins
  compress_bins = 0,
  # Composition error distribution: 0 = multinomial
  composition_error = 0,
  # Parameter selection: 0 = default
  parameter_selection = 0,
  # Minimum sample size
  min_sample_size = 0.001
) |> 
  as.data.frame()
# Set row names
rownames(d) <- fleet_names

# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/ss3/length-info.rds")
