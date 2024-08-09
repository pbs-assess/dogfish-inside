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

# Commercial catch
# TODO Retain fishing month?
dc <- readRDS("data/generated/catch-commercial.rds") |>
  dplyr::filter(area == "4B", year <= 2023) |>
  dplyr::mutate(
    gear = dplyr::case_match(
      gear,
      c("Bottom trawl", "Unknown/trawl")  ~ "Bottom trawl",
      c("Midwater trawl")                 ~ "Midwater trawl",
      c("Hook and line")                  ~ "Hook and line",
    )
  ) |>
  tidyr::drop_na(gear) |>
  dplyr::mutate(fleet = fleet(gear), .before = 3) |>
  dplyr::group_by(year, fleet) |>
  dplyr::summarise(
    landed_kt = 1e-3 * sum(landed_kg),
    discarded_kt = 1e-3 * sum(discarded_kg),
    total_kt = sum(landed_kt + discarded_kt),
    .groups = "drop"
  ) |>
  dplyr::mutate(catch = total_kt) |>
  dplyr::select(year, fleet, catch) |>
  dplyr::arrange(fleet, year)

# Survey catch
# TODO Retain survey month?
ds <- readRDS("data/generated/catch-survey.rds") |>
  dplyr::filter(area == "4B", year <= 2023) |>
  dplyr::mutate(fleet = fleet(survey), .before = 3) |>
  dplyr::group_by(year, fleet) |>
  dplyr::summarise(
    total_kpc = 1e-3 * sum(total_pc),
    .groups = "drop"
  ) |>
  dplyr::mutate(catch = total_kpc) |>
  dplyr::select(year, fleet, catch) |>
  dplyr::arrange(fleet, year)

# DF Survey?

# Recreational

# FSC

# Salmon bycatch

# Define catch -----------------------------------------------------------------

d <- dplyr::bind_rows(dc, ds) |>
  dplyr::mutate(catch = round(catch, 3)) |>
  dplyr::mutate(catch_se = 0.01) |>
  dplyr::mutate(season = 1) |>
  dplyr::filter(catch > 0) |>
  dplyr::select(year, season, fleet, catch, catch_se) |>
  dplyr::arrange(fleet, year) |>
  as.data.frame()

# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/ss3/catch.rds")

# Plot catch -------------------------------------------------------------------

# TODO: Plot catch