# Load -------------------------------------------------------------------------

library(tidyverse)
library(ssio)

# Path -------------------------------------------------------------------------

path <- file.path("ss3", "T00")

# Fleets -----------------------------------------------------------------------

source(file.path(path, "00-fleets.R"))
fleets()

# Define -----------------------------------------------------------------------

?ssio::write_data()

# Data frames ------------------------------------------------------------------

# Catch
catch_info <- create_catch_info() |>
  append_catch_info(1, -1, 1, 1, 1, name = "Bottom trawl landings") |>  
  append_catch_info(1, -1, 1, 1, 1, name = "Bottom trawl discards") |>
  append_catch_info(1, -1, 1, 1, 1, name = "Midwater trawl") |>
  append_catch_info(1, -1, 1, 1, 1, name = "Hook and line landings") |>
  append_catch_info(1, -1, 1, 1, 1, name = "Hook and line discards") |>
  append_catch_info(1, -1, 1, 1, 1, name = "All gears landings") |>
  append_catch_info(1, -1, 1, 2, 1, name = "HBLL survey") |>
  append_catch_info(1, -1, 1, 2, 1, name = "Recreational landings")  

# TODO
# Consider developing ssio:: functions for catch formatting
catch_data <- readRDS("data/ss3/catch.rds") |>
  dplyr::mutate(fleet_name = paste(gear, type)) |>
  dplyr::mutate(
    fleet_name = dplyr::case_match(
      fleet_name,
      # TODO ssio:: allow  scale discards by constant before combining
      paste("Midwater trawl", c("landings", "discards")) ~ "Midwater trawl",
      .default = fleet_name
    )
  ) |>
  # TODO remove season and catch_se from stored data?
  dplyr::select(year, fleet_name, catch) |>
  dplyr::group_by(year, fleet_name) |>
  dplyr::summarise(catch = sum(catch), .groups = "drop") |>
  dplyr::mutate(catch = round(catch, 3)) |>
  dplyr::mutate(fleet = fleets(fleet_name)) |>
  dplyr::arrange(fleet, year) |>
  dplyr::mutate(season = 1) |>
  dplyr::mutate(catch_se = 0.01) |>
  dplyr::select(year, season, fleet, catch, catch_se) |>
  dplyr::filter(catch > 0) |>
  tidyr::drop_na()
# End consider developing ssio:: functions for catch formatting

# Index
# Note: Apparently needs all fleets to read in data
index_info <- create_index_info() |>
  append_index_info(1, 1, name = "Bottom trawl landings") |>  
  append_index_info(2, 1, name = "Bottom trawl discards") |>  
  append_index_info(3, 1, name = "Midwater trawl") |>  
  append_index_info(4, 1, name = "Hook and line landings") |>  
  append_index_info(5, 1, name = "Hook and line discards") |>  
  append_index_info(6, 1, name = "All gears landings") |>  
  append_index_info(7, 0, name = "HBLL survey") |>    
  append_index_info(8, 0, name = "Recreational landings")
index_data <- readRDS("data/ss3/index.rds") |>
  dplyr::mutate(fleet_name = paste(gear, type)) |>
  dplyr::mutate(fleet = fleets(fleet_name)) |>
  dplyr::select(year, month, fleet, est, se)
# # Discards
# discard_info <- NULL
# discard_data <- NULL
# TODO
# Length info: only fleets with lengths?
length_info <- create_length_info() |>
  append_length_info(-1, 1e-04, 0, 0, 0, 0, 0.001, name = "BT landings") |>
  append_length_info(-1, 1e-04, 0, 0, 0, 0, 0.001, name = "BT discards") |>  
  append_length_info(-1, 1e-04, 0, 0, 0, 0, 0.001, name = "MT") |>
  append_length_info(-1, 1e-04, 0, 0, 0, 0, 0.001, name = "HL landings") |>
  append_length_info(-1, 1e-04, 0, 0, 0, 0, 0.001, name = "HL discards") |>
  append_length_info(-1, 1e-04, 0, 0, 0, 0, 0.001, name = "AG landings") |>
  append_length_info(-1, 1e-04, 0, 0, 0, 0, 0.001, name = "HBLL survey") |>
  append_length_info(-1, 1e-04, 0, 0, 0, 0, 0.001, name = "REC landings")  
# TODO
#  Consider developing ssio:: functions for length formatting
library(santoku)
# Define bins
bin_size <- 5
bin_lower <- seq(from = 25, to = 115, by = bin_size)
bin_plus_max <- 130
bins <- c(bin_lower, bin_plus_max)
# Length
length_data <- readRDS("data/ss3/length.rds") |>
  dplyr::mutate(fleet_name = paste(gear, type)) |>
  # Assign fleet anmes
  dplyr::mutate(
    fleet_name = dplyr::case_match(
      fleet_name,
      c("Bottom trawl keepers")    ~ "Bottom trawl landings",
      c("Bottom trawl unsorted")   ~ "Bottom trawl discards",
      c("Midwater trawl unsorted") ~ "Midwater trawl",
      c("Hook and line keepers")   ~ "Hook and line landings",
      c("Hook and line unsorted")  ~ "Hook and line discards",
      # Missing All gears landings (mirror to Bottom trawl landings)
      c("HBLL survey")             ~ "HBLL survey" 
      # Missing Recreational landings (mirror to HBLL survey)
    )
  ) |>
  tidyr::drop_na() |>
  # Assign fleet
  dplyr::mutate(fleet = fleets(fleet_name)) |>
  dplyr::select(year, fleet, sex, length) |>
  # Apply bins and format
  dplyr::filter(length > min(bins)) |>
  dplyr::mutate(bin_range = chop(length, breaks = bins)) |>
  dplyr::mutate(bin_name = chop(length, breaks = bins, label = bin_lower)) |>
  dplyr::select(year, fleet, sex, bin_name) |>
  dplyr::group_by(year, fleet, sex, bin_name) |>
  dplyr::summarise(n = n(), .groups = "drop") |>
  dplyr::group_by(year, fleet) |>
  dplyr::mutate(N = sum(n)) |>
  dplyr::ungroup() |>
  dplyr::arrange(fleet, year) |>
  tidyr::pivot_wider(
    names_from = sex:bin_name,
    names_sep = "_",
    names_expand = TRUE,
    values_from = n,
    values_fill = 0
  ) |>
  dplyr::mutate(month = 1, .before = fleet) |>
  dplyr::mutate(sex2 = 3, .before = N) |>
  dplyr::mutate(partition = 0, .before = N) |> 
  as.data.frame()
# End consider developing ssio:: functions for length formatting

# Write ------------------------------------------------------------------------

ssio::write_data(
  file = file.path(path, "data.ss"),
  year_start = 1876,
  year_end = 2023,
  n_seasons_per_year = 1,
  n_months_per_season = 12,
  n_subseasons = 2,
  month_spawning = 1,
  n_sexes = 2,
  n_ages = 70,
  n_areas = 1,
  n_fleets = nrow(catch_info),
  catch_info = catch_info,
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

