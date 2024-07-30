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

# TODO Retain month?
# TODO Check area

d <- readRDS("data/raw/catch-survey.rds") |> 
  dplyr::mutate(
    survey = dplyr::case_match(
      survey_abbrev,
      c("HBLL INS N", "HBLL INS S") ~ "HBLL"
    )
  ) |>
  tidyr::drop_na(survey) |>
  dplyr::group_by(year, species_common_name, survey) |>
  dplyr::summarise(total_pc = sum(catch_count), .groups = "drop") |>
  dplyr::mutate(area = "4B", .before = 4)

# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/generated/catch-survey.rds")
