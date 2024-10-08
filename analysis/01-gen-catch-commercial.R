# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(tibble)
library(tidyr)
# Theme set
ggplot2::theme_set(gfplot::theme_pbs())

# Read data --------------------------------------------------------------------

# Adapted from: 
# - gfcatch::tidy_catch()
# - https://github.com/pbs-assess/dogfish-assess/blob/main/analysis/utils.R

d0 <- readRDS(here::here("data", "raw", "catch-commercial.rds")) |>
  dplyr::mutate(area = gfplot::assign_areas(major_stat_area_name, "4B")) |>
  dplyr::filter(!is.na(species_common_name), !is.na(year)) |>
  dplyr::mutate(
    gear = dplyr::case_match(
      gear,
      c("BOTTOM TRAWL")              ~ "Bottom trawl",
      c("MIDWATER TRAWL")            ~ "Midwater trawl",
      c("HOOK AND LINE", "LONGLINE") ~ "Hook and line",
      c("TRAP")                      ~ "Trap",
      c("UNKNOWN TRAWL")             ~ "Unknown trawl"
    )
  ) |>
  select(year, area, species_common_name, gear, landed_kg, discarded_kg) |>
  dplyr::group_by(year, species_common_name, gear, area) |>
  dplyr::summarise(
    landings = 1e-03 * sum(landed_kg, na.rm = TRUE),
    discards = 1e-03 * sum(discarded_kg, na.rm = TRUE),
    .groups = "drop"
  ) |>
  tidyr::pivot_longer(
    cols = all_of(c("landings", "discards")),
    names_to = "type",
    values_to = "catch_t"
  ) |>
  dplyr::mutate(source = "GFFOS") |>
  dplyr::arrange(species_common_name, gear, type, year) |>
  dplyr::select(year, species_common_name, area, gear, type, catch_t, source)


# Read historical data ---------------------------------------------------------

# All gears landings 1876-1939
d1 <- readRDS("data/raw/catch-commercial-landings-all-gears-1876-1939.rds") |>
  dplyr::mutate(
    year = Year,
    species_common_name = "north pacific spiny dogfish",
    gear = "All gears", # TODO Update
    area = "4B",
    type = "landings",
    catch_t = Min, # For consistency with 1935-1939 overlap
    source = "Ketchen"
  ) |>
  dplyr::select(year, species_common_name, area, gear, type, catch_t, source)

# All gears landings 1935-1965
d2 <- readRDS("data/raw/catch-commercial-landings-all-gears-1935-1965.rds") |>
  dplyr::mutate(
    year = Year,
    species_common_name = "north pacific spiny dogfish",
    gear = "All gears", # TODO Update
    area = "4B",
    type = "landings",
    catch_t = `4B`,
    source = "Gallucci"
  ) |>
  dplyr::select(year, species_common_name, area, gear, type, catch_t, source)

# Hook and line landings 1966-2008
d3 <- readRDS("data/raw/catch-commercial-landings-longline-1966-2008.rds") |>
  tibble::add_row(Year = 1966, `4B` = 270) |> # Missing first row
  dplyr::mutate(
    year = Year,
    species_common_name = "north pacific spiny dogfish",
    gear = "Longline", # TODO Update
    area = "4B",
    type = "landings",
    catch_t = `4B`,
    source = "Gallucci"
  ) |>
  dplyr::arrange(year) |>
  dplyr::select(year, species_common_name, area, gear, type, catch_t, source)

# Trawl landings 1966-2008
d4 <- readRDS("data/raw/catch-commercial-landings-trawl-1966-2008.rds") |>
  dplyr::mutate(
    year = Year,
    species_common_name = "north pacific spiny dogfish",
    gear = "Trawl", # TODO Update
    area = "4B",
    type = "landings",
    catch_t = `4B`,
    source = "Gallucci"
  ) |>
  dplyr::select(year, species_common_name, area, gear, type, catch_t, source)

# Hook and line discards 2001-2006
d5 <- readRDS("data/raw/catch-commercial-discards-longline-2001-2006.rds") |>
  dplyr::mutate(
    year = Year,
    species_common_name = "north pacific spiny dogfish",
    gear = "Longline", # TODO Update
    area = "4B",
    type = "discards",
    catch_t = `4B`,
    source = "Gallucci"
  ) |>
  dplyr::select(year, species_common_name, area, gear, type, catch_t, source)

# Trawl discards 1966-2008
d6 <- readRDS("data/raw/catch-commercial-discards-trawl-1966-2008.rds") |>
  dplyr::mutate(
    year = Year,
    species_common_name = "north pacific spiny dogfish",
    gear = "Trawl", # TODO Update
    area = "4B",
    type = "discards",
    catch_t = `4B`,
    source = "Gallucci"
  ) |>
  dplyr::select(year, species_common_name, area, gear, type, catch_t, source)

# Bind data --------------------------------------------------------------------

d <- dplyr::bind_rows(d0, d1, d2, d3, d4, d5, d6) |>
  dplyr::mutate(catch_t = round(catch_t, 3)) |>
  tidyr::drop_na() |>
  dplyr::arrange(species_common_name, gear, type, year)
  
# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/generated/catch-commercial.rds")

# Plot data --------------------------------------------------------------------

ggplot(d, aes(x = year, y = catch_t, fill = type)) +
  geom_bar(position = "stack", stat = "identity") +
  facet_wrap(~gear, ncol = 1)
