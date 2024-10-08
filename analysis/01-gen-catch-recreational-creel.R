# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(tibble)

# Read data --------------------------------------------------------------------

d <- readRDS("data/raw/catch-recreational-creel.rds") |>
  dplyr::mutate(
    species_common_name = tolower(species),
    area = dplyr::case_match(pfma, paste0("PFMA ", c(12:20, 28:29)) ~ "4B"),
    gear = "Recreational",
    type = dplyr::case_match(disposition, "Kept" ~ "landings"),
    catch_pc = estimate,
    source = "Creel"
  ) |>
  dplyr::group_by(year, species_common_name, area, gear, type, source) |>
  dplyr::summarise(catch_pc = sum(catch_pc, na.rm = TRUE), .groups = "drop") |>
  dplyr::mutate(catch_kpc = 1e-03 * catch_pc) |>
  dplyr::select(
    year,
    species_common_name,
    area,
    gear,
    type,
    catch_kpc,
    source
  ) |>
  tidyr::drop_na()

# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/generated/catch-recreational-creel.rds")
