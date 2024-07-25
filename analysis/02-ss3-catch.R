# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(tibble)
# Source
source("R/utils.R")
# Theme set
ggplot2::theme_set(gfplot::theme_pbs())

# Adapted from:
# - https://github.com/pbs-assess/dogfish-assess/

# Read data --------------------------------------------------------------------

# TODO: Need to reconcile count vs kg 

catch <- readRDS("data/generated/catch-commercial.rds") |>
  dplyr::filter(area == "4B", year <= 2023) |>
  dplyr::group_by(year, gear) |>
  dplyr::summarise(
    landing = 1e-3 * sum(landed_kg),
    discard = 1e-3 * sum(discarded_kg),
    .groups = "drop" 
  )

# Define catch -----------------------------------------------------------------

# Trawl landing
f1 <- catch |>
  dplyr::filter(gear %in% c("Bottom trawl", "Unknown/trawl")) |>
  dplyr::summarise(value = sum(landing), .by = year) |>
  mutate(fleet = 1)

# Trawl discard
f2 <- catch |>
  dplyr::filter(gear %in% c("Bottom trawl", "Unknown/trawl")) |>
  dplyr::summarise(value = sum(discard), .by = year) |>
  mutate(fleet = 2)

# Midwater trawl
f3 <- catch |>
  dplyr::filter(gear %in% c("Midwater trawl")) |>
  dplyr::summarise(value = sum(landing + discard), .by = year) |>
  mutate(fleet = 3)

# Hook and line landing
f4 <- catch |>
  dplyr::filter(gear %in% c("Hook and line")) |>
  dplyr::summarise(value = sum(landing), .by = year) |>
  mutate(fleet = 4)

# Hook and line discard
f5 <- catch |>
  dplyr::filter(gear %in% c("Hook and line")) |>
  dplyr::summarise(value = sum(discard), .by = year) |>
  mutate(fleet = 5)

# HBLL Inside

# Recreational

# FSC

# Salmon bycatch

# Assemble catch
d <- dplyr::bind_rows(f1, f2, f3, f4, f5) |>
  dplyr::mutate(value = round(value, 3)) |>
  dplyr::mutate(se = 0.01) |>
  dplyr::mutate(season = 1) |>
  dplyr::filter(value > 0) |>
  dplyr::select(year, season, fleet, value, se) |>
  dplyr::arrange(fleet, year)

# Plot catch -------------------------------------------------------------------

# TODO: Plot catch

# Write catch ------------------------------------------------------------------

write.csv(d, file = "data/ss3/ss3-catch.csv", row.names = FALSE)
