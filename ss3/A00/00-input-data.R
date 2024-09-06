# Load -------------------------------------------------------------------------

library(tidyverse)
library(ssio)

# Path -------------------------------------------------------------------------

path <- file.path("ss3", "A00")

# Define -----------------------------------------------------------------------

?ssio::write_data()

# Info and data ----------------------------------------------------------------

# Fleets
fleet_info <- readRDS("data/ss3/fleet-info.rds") #
catch_data <- readRDS("data/ss3/catch.rds") |>
  dplyr::filter(fleet %in% c(1, 3, 4, 7)) |>
  dplyr::mutate(
    fleet = dplyr::case_match(
      fleet,
      1 ~ 1,
      3 ~ 2,
      4 ~ 3,
      7 ~ 4
    )
  ) |>
  tidyr::drop_na()
# Index
index_info <- readRDS("data/ss3/cpue-info.rds") #
index_data <- readRDS("data/ss3/index.rds")
# # Discards
# discard_info <- NULL
# discard_data <- NULL
# Length
length_info <- readRDS("data/ss3/length-info.rds")
length_data <- readRDS("data/ss3/length.rds")

# Write ------------------------------------------------------------------------

ssio::write_data(
  file = file.path(path, "data.ss"),
  year_start = 1954,
  year_end = 2023,
  n_seasons_per_year = 1,
  n_months_per_season = 12,
  n_subseasons = 2,
  month_spawning = 1,
  n_sexes = 2,
  n_ages = 70,
  n_areas = 1,
  n_fleets = nrow(fleet_info),
  fleet_info = fleet_info,
  catch_data = catch_data,
  index_info = index_info,
  index_data = index_data,
  n_fleets_discard = 0, #
  # discard_info = discard_info, #
  # discard_data = discard_data, #
  use_mean_body_size = 0,
  length_bin_method = 2,
  length_bin_width = 5,
  length_bin_lower_min = 25,
  length_bin_lower_max = 115,
  use_length_composition = 1,
  length_info = length_info,
  n_length_bins = length(seq(25, 115, 5)),
  length_bins_lower = seq(25, 115, 5),
  length_data = length_data
)
