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
  # Integer index
  fleet = seq_along(fleet_name),
  # Units: 0 = numbers; 1 = biomass
  units = c(1, 1, 1, 0),
  # Error distribuion: 0 = lognormal
  errtype = 0,
  # Enable SD report
  sd_report = 0
) |> 
  as.data.frame()
# Set row names
rownames(d) <- fleet_names
  
# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/ss3/cpue-info.rds")
