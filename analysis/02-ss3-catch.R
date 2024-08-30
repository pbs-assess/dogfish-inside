# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(tibble)
# Source
source("R/utils.R")

# Read data --------------------------------------------------------------------

# TODO Consider DF survey
# TODO Consider FSC
# TODO Consider Salmon bycatch

# Commercial catch (including historical)
d1 <- readRDS("data/generated/catch-commercial.rds") |>
  dplyr::filter(
    year <= 2023,
    area == "4B", 
    gear != "Bottom trawl" | (source == "GFFOS" & year >= 1996),
    gear != "Unknown trawl" | (source == "GFFOS" & year >= 1996),
    gear != "Midwater trawl" | (source == "GFFOS" & year >= 1996),
    gear != "Hook and line" | (source == "GFFOS" & year >= 2007),
    gear != "Trawl" | (source == "Gallucci" & year >= 1966 & year <= 1995),
    gear != "Longline" | (source == "Gallucci" & year <= 2006),
    gear != "All gears" | (source == "Gallucci" & year <= 1965),
    catch_t > 0
  ) |>
  dplyr::mutate(
    gear = dplyr::case_match(
      gear,
      c("All gears", "Bottom trawl", "Trawl", "Unknown trawl") ~ "Bottom trawl",
      c("Midwater trawl") ~ "Midwater trawl",
      c("Longline", "Hook and line") ~ "Hook and line",
    )
  ) |> 
  dplyr::mutate(fleet_name = paste(gear, type)) |>
  dplyr::mutate(
    fleet_name = dplyr::case_match(
      fleet_name,
      paste("Midwater trawl", c("landings", "discards")) ~ "Midwater trawl",
      .default = fleet_name
    )
  ) |>
  tidyr::drop_na(gear) |>
  dplyr::group_by(year, fleet_name, source) |>
  dplyr::summarise(catch_t = sum(catch_t), .groups = "drop") |>
  dplyr::arrange(fleet_name, year) |>
  dplyr::rename(catch = catch_t) |>
  dplyr::select(year, fleet_name, catch, source)

# Survey catch
d2 <- readRDS("data/generated/catch-survey.rds") |>
  dplyr::filter(area == "4B", year <= 2023) |>
  dplyr::rename(fleet_name = survey) |>
  dplyr::arrange(fleet_name, year) |>
  dplyr::rename(catch = catch_kpc) |>
  dplyr::select(year, fleet_name, catch, source)
  
# Recreational
d3 <- readRDS("data/generated/catch-recreational-creel.rds") |>
  dplyr::filter(area == "4B", year <= 2023) |>
  dplyr::rename(fleet_name = gear) |>
  dplyr::rename(catch = catch_kpc, catch_se = se) |>
  dplyr::select(year, fleet_name, catch, catch_se, source)

# Define catch -----------------------------------------------------------------

d <- dplyr::bind_rows(d1, d2, d3) |>
  dplyr::mutate(
    season = 1,
    fleet = fleet(fleet_name),
    catch = round(catch, 3),
    catch_se = dplyr::case_match(catch_se, NA ~ 0.01, .default = catch_se),
    catch_se = round(catch_se, 3)
  ) |>
  dplyr::filter(catch > 0) |>
  dplyr::arrange(fleet, year) |>
  dplyr::select(year, season, fleet, catch, catch_se) |>
  as.data.frame()

# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/ss3/catch.rds")

# Plot catch -------------------------------------------------------------------

# TODO: Plot catch
