# Load
library(dplyr)
library(stringr)
library(tibble)
# Source
source("R/utils.R")

# Define data ------------------------------------------------------------------

# Fleet names
# To edit fleet names update fleet() in R/utils.R
fleet_name <- fleet() |> pull(fleet_name) |> str_replace_all(" ", "_")

# Define fleet info
d <- tibble::tibble(
  # Type: 1 = catch; 2 = bycatch; 3 = no removals
  type = c(1L),
  # Timing: # -1 = over whole season; 1 = survey or pulse
  fleet_timing = c(-1L),
  # Area
  area = c(1L),
  # Units: 1 = biomass (metric tonnes); 2 = numbers (thousands)
  fleet_units = c(
    1L, # Bottom trawl
    1L, # Midwater trawl
    1L, # Hook and line
    2L  # HBLL
  ),
  # Multiplier: 0 = no; 1 = parameter for each
  need_catch_mult = c(1L),
  # Fleet name
  fleet_name = fleet_name
) |>
  as.data.frame()

# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/ss3/fleet-info.rds")
