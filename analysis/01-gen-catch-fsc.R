# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(tibble)

# Read data --------------------------------------------------------------------

d <- readRDS("data/raw/catch-fsc.rds") |>
  dplyr::distinct() |> # Drop one apparent duplicate record
  dplyr::filter(units == "lb") |> # Drop one record 100 pieces
  dplyr::mutate(
    species_common_name = tolower(species),
    area = dplyr::case_match(
      pfma,
      paste0("PFMA ", c(12:20, 28:29)) ~ "4B"
    ),
    gear = "FSC",
    type = dplyr::case_match(disposition, "Kept" ~ "landings"),
    catch_kg = 0.453592 * catch, # Convert lbs to kg
    catch_t = 1e-03 * catch_kg,
    source = "FSC"
  ) |>
  tidyr::drop_na() |> # Drop release records
  dplyr::filter(species_common_name == "north pacific spiny dogfish") |>
  dplyr::select(
    year,
    species_common_name,
    area,
    gear,
    type,
    catch_t,
    source
  )

# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/generated/catch-fsc.rds")
