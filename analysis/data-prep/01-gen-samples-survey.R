# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(tibble)
# Theme set
ggplot2::theme_set(gfplot::theme_pbs())

# Adapted from:
# - https://github.com/pbs-assess/dogfish-assess/

# Read data --------------------------------------------------------------------

d <- readRDS("data/raw/samples-survey.rds") |>
  dplyr::mutate(area = gfplot::assign_areas(major_stat_area_name, "4B")) |>
  dplyr::mutate(
    survey = dplyr::case_match(
      survey_abbrev,
      c("HBLL INS N", "HBLL INS S") ~ "HBLL"
    )
  ) |>
  tidyr::drop_na(survey) |>
  dplyr::filter(sampling_desc %in% c("UNSORTED")) |>
  dplyr::select(
    year,
    month,
    survey,
    species_common_name,
    sex,
    length,
    length_type,
    weight,
    sampling_desc,
    area
  )

# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/generated/samples-survey.rds")

# Plot data --------------------------------------------------------------------

# TODO Plot data
