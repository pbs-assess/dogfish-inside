# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(tibble)

# Read data --------------------------------------------------------------------

d <- readRDS("data/raw/catch-recreational-irec.rds") |>
  dplyr::filter(disposition == "Kept") |>
  # TODO update from here
  # dplyr::mutate(
  #   species_common_name = "north pacific spiny dogfish",
  #   area = dplyr::case_match(pfma, paste0("PFMA ", c(12:20, 28:29)) ~ "4B"),
  #   gear = "Recreational",
  #   type = dplyr::case_match(disposition, "Kept" ~ "landings"),
  #   catch_pc = estimate,
  #   variance = standard_error^2,
  #   source = "Creel"
  # ) |>
  # dplyr::group_by(year, species_common_name, area, gear, type, source) |>
  # dplyr::summarise(
  #   catch_pc = sum(catch_pc, na.rm = TRUE),
  #   variance = sum(variance, na.rm = TRUE), # Assumes catch independent
  #   .groups = "drop"
  # ) |>
  # dplyr::mutate(
  #   catch_kpc = 1e-03 * catch_pc,
  #   variance = (variance + catch_pc^2) * (1e-03)^2 - (catch_pc^2) * (1e-03)^2,
  #   se = sqrt(variance)
  # ) |>
  # dplyr::select(
  #   year,
  #   species_common_name,
  #   area,
  #   gear,
  #   type,
  #   catch_kpc,
  #   se,
  #   source
  # ) |>
  tidyr::drop_na()



# Write data -------------------------------------------------------------------

# saveRDS(d, file = "data/generated/catch-recreational-irec.rds")
