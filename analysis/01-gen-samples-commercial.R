# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(tibble)
# Source
source("R/utils.R")
# Theme set
ggplot2::theme_set(gfplot::theme_pbs())

# Read data --------------------------------------------------------------------

d <- readRDS("data/raw/samples-commercial.rds") |> 
  dplyr::mutate(area = gfplot::assign_areas(major_stat_area_name, "4B")) |>
  dplyr::mutate(gear = gear_desc) |>
  dplyr::mutate(
    gear = dplyr::case_match(
      gear,
      c("BOTTOM TRAWL", "UNKNOWN TRAWL") ~ "Bottom trawl",
      c("MIDWATER TRAWL")                ~ "Midwater trawl",
      c("HOOK AND LINE", "LONGLINE")     ~ "Hook and line",
    )
  ) |>
  tidyr::drop_na(gear) |>
  dplyr::mutate(
    sampling_desc = dplyr::case_match(
      sampling_desc,
      c("KEEPERS")  ~ "keepers",
      c("DISCARDS") ~ "discards",
      c("UNSORTED") ~ "unsorted"
    )
  ) |>
  tidyr::drop_na(sampling_desc) |>
  tidyr::drop_na(length) |>
  dplyr::select(
    year,
    gear,
    species_common_name,
    sex,
    length,
    length_type,
    sampling_desc,
    area
  )

# TODO Check length distributions - different between discards/keeper/unsorted?

# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/generated/samples-commercial.rds")

# Plot data --------------------------------------------------------------------

# Sampling description 
ggplot(d, aes(x = factor(year), y = length, colour = sampling_desc)) +
  geom_boxplot() +
  facet_grid(rows = vars(gear))

ggplot(d, aes(x = sampling_desc, y = length, colour = sampling_desc)) +
  geom_boxplot() +
  facet_grid(rows = vars(gear))

# Gear
ggplot(d, aes(x = gear, y = length, colour = sampling_desc)) +
  geom_boxplot()

# Sex
ggplot(d, aes(x = factor(year), y = length, colour = factor(sex))) +
  geom_boxplot() +
  facet_grid(rows = vars(gear))

ggplot(d, aes(x = gear, y = length, colour = factor(sex))) +
  geom_boxplot()

# Glance
dbt <- d |> dplyr::filter(gear == "Bottom trawl")

table(dbt |> dplyr::select(year, sampling_desc))

dhl <- d |> dplyr::filter(gear == "Hook and line")

table(dhl |> dplyr::select(year, sampling_desc))

dmt <- d |> dplyr::filter(gear == "Midwater trawl")

table(dmt |> dplyr::select(year, sampling_desc))
