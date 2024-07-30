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

# Adapted from: 
# - gfcatch::tidy_catch()
# - https://github.com/pbs-assess/dogfish-assess/blob/main/analysis/utils.R

d <- readRDS(here::here("data", "raw", "catch-commercial.rds")) |>
  dplyr::mutate(area = gfplot::assign_areas(major_stat_area_name, "4B")) |>
  dplyr::filter(!is.na(species_common_name), !is.na(year)) |>
  dplyr::mutate(
    gear = dplyr::case_match(
      gear,
      c("BOTTOM TRAWL")              ~ "Bottom trawl",
      c("MIDWATER TRAWL")            ~ "Midwater trawl",
      c("HOOK AND LINE", "LONGLINE") ~ "Hook and line",
      c("TRAP")                      ~ "Trap",
      c("UNKNOWN", "UNKNOWN TRAWL")  ~ "Unknown/trawl",
    )
  ) |>
  select(year, area, species_common_name, gear, landed_kg, discarded_kg) |>
  dplyr::group_by(year, species_common_name, gear, area) |>
  dplyr::summarise(
    landed_kg = sum(landed_kg, na.rm = TRUE),
    discarded_kg = sum(discarded_kg, na.rm = TRUE),
    .groups = "drop"
  ) |>
  dplyr::arrange(species_common_name, year, gear)

# TODO Consider what years to use


# Read historical data ---------------------------------------------------------

d_old <- NULL # TODO Read old data

# Bind data --------------------------------------------------------------------

d <- bind_rows(d, d_old)

# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/generated/catch-commercial.rds")

# Plot data --------------------------------------------------------------------

dd <- d |>
  dplyr::mutate(facet = gear, .before = 3) |>
  tidyr::pivot_longer(
    cols = c("landed_kg", "discarded_kg"),
    names_to = "desc",
    values_to = "value"
  ) |>
  dplyr::mutate(gear = ifelse(desc == "discarded_kg", "Discarded", gear))

# Plot
# TODO Consider adapting plot_catch()
gfplot::plot_catch(dd, xlim = c(1954, 2023)) +
  ggplot2::facet_wrap(~facet, ncol = 1)
