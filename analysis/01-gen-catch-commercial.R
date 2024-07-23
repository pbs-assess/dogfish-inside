# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(tibble)
# Source
source("R/utils.R")
# Theme set
ggplot2::theme_set(gfplot::theme_pbs())

# Tidy data --------------------------------------------------------------------

# Adapted from: 
# - gfcatch::tidy_catch()
# - https://github.com/pbs-assess/dogfish-assess/blob/main/analysis/utils.R

d <- readRDS(here::here("data", "raw", "catch-commercial.rds")) |>
  dplyr::mutate(area = gfplot::assign_areas(major_stat_area_name, "4B")) |>
  dplyr::filter(!is.na(species_common_name), !is.na(year)) |>
  dplyr::mutate(
    gear = dplyr::recode(
      gear,
      `UNKNOWN` = "Unknown/trawl",
      `BOTTOM TRAWL` = "Bottom trawl",
      `HOOK AND LINE` = "Hook and line",
      `LONGLINE` = "Hook and line",
      `MIDWATER TRAWL` = "Midwater trawl",
      `TRAP` = "Trap",
      `UNKNOWN TRAWL` = "Unknown/trawl"
    )
  ) |>
  select(year, area, species_common_name, gear, landed_kg, discarded_kg) |>
  dplyr::group_by(year, species_common_name, gear, area) |>
  dplyr::summarise(
    landed_kg = sum(landed_kg, na.rm = TRUE),
    discarded_kg = sum(discarded_kg, na.rm = TRUE),
    .groups = "drop"
  ) |>
  dplyr::arrange(species_common_name, year)

# Write summarized data
saveRDS(d, file = "data/generated/catch-commercial-4B-summarized.rds")
  
# Filter years
# - Trawl >= 1996
# - Longline >= 2007

d_new <- d |>
  dplyr::filter(
    (gear %in% c("Bottom trawl", "Midwater trawl") & year >= 1996) |
      (gear %in% c("Hook and line", "Trap", "Unknown/trawl") & year >= 2007)
  )


# Read historical data ---------------------------------------------------------

d_old <- NULL # TODO: Read old data

# Bind data --------------------------------------------------------------------

d <- bind_rows(d_new, d_old)

# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/generated/catch-commercial.rds")

# Plot data --------------------------------------------------------------------

# TODO: Plot data
