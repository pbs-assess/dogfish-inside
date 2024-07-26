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

# Commercial samples
dc <- readRDS("data/raw/samples-commercial.rds") |>
  dplyr::filter(grepl("4B", major_stat_area_name)) |>
  dplyr::filter(grepl("TRAWL", gear_desc) | grepl("LONGLINE", gear_desc)) |>
  dplyr::select(
    year, 
    gear_desc, 
    specimen_id, 
    length, 
    sex, 
    age, 
    sampling_desc, 
    usability_code
  )

# Survey samples
ds <- readRDS("data/raw/samples-survey.rds")

# Define length ----------------------------------------------------------------

# TODO: Revisit with keepers and discards in the commercial samples

b <- dc |>
  dplyr::filter(gear_desc == "BOTTOM TRAWL")
b |>
  dplyr::group_by(year, sampling_desc) |>
  dplyr::count() |>
  dplyr::arrange(sampling_desc, year)
unique(b$sampling_desc)

m <- dc |>
  dplyr::filter(gear_desc == "MIDWATER TRAWL")
m |>
  dplyr::group_by(year, sampling_desc) |>
  dplyr::count() |>
  dplyr::arrange(sampling_desc, year)

hl <- dc |>
  dplyr::filter(gear_desc == "LONGLINE")
hl |>
  dplyr::group_by(year, sampling_desc) |>
  dplyr::count() |>
  dplyr::arrange(sampling_desc, year) |>
  tibble::view()





# Trawl landing
f1 <- dc |>
  dplyr::filter(gear_desc == "BOTTOM TRAWL", sampling_desc == "KEEPERS") |>
  dplyr::mutate(fleet_name = "Bottom trawl landings") |>
  dplyr::select(-gear_desc, sampling_desc)

# Trawl discard
f2 <- dc |>
  dplyr::filter(gear_desc == "BOTTOM TRAWL", sampling_desc == "DISCARDS") |>
  dplyr::mutate(fleet_name = "Bottom trawl discards") |>
  dplyr::select(-gear_desc, sampling_desc)

# Midwater trawl
f3 <- dc |>
  dplyr::filter(gear_desc == "MIDWATER TRAWL", sampling_desc == "UNSORTED") |>
  dplyr::mutate(fleet_name = "Midwater trawl") |>
  dplyr::select(-gear_desc, sampling_desc)

# Hook and line landing
f4 <- dc |>
  dplyr::filter(gear_desc == "LONGLINE", sampling_desc == "KEEPERS") |>
  dplyr::mutate(fleet_name = "Hook and line landings") |>
  dplyr::select(-gear_desc, sampling_desc)

# Hook and line discard


# HBLL

hbll <- ds |>
  dplyr::filter(survey_abbrev %in% c("HBLL INS N", "HBLL INS S")) |>
  dplyr::mutate(fleet_name = "HBLL") |>
  select(year, fleet_name, specimen_id, length, sex, age, usability_code)
  
# Plot length ------------------------------------------------------------------
# TODO: Plot index

# Write length -----------------------------------------------------------------