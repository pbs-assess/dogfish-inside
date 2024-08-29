# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(tibble)
# Theme set
ggplot2::theme_set(gfplot::theme_pbs())

# Read data --------------------------------------------------------------------

d <- readRDS("data/raw/catch-survey.rds") |> 
  dplyr::mutate(
    survey = dplyr::case_match(
      survey_abbrev,
      c("HBLL INS N", "HBLL INS S") ~ "HBLL"
    )
  ) |>
  tidyr::drop_na(survey) |>
  dplyr::group_by(year, species_common_name, survey) |>
  dplyr::summarise(catch_pc = sum(catch_count), .groups = "drop") |>
  dplyr::mutate(catch_kpc = 1e-03 * catch_pc) |>
  dplyr::mutate(area = "4B") |>
  dplyr::mutate(type = "landings") |>
  dplyr::mutate(source = "GFBio") |>
  dplyr::select(
    year, 
    species_common_name, 
    area, 
    survey, 
    type, 
    catch_kpc, 
    source
  ) |>
  dplyr::arrange(year, survey)

# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/generated/catch-survey.rds")
