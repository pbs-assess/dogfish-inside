# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(tibble)
# Theme set
ggplot2::theme_set(gfplot::theme_pbs())

# Read data --------------------------------------------------------------------

# Commercial samples
dc <- readRDS("data/generated/samples-commercial.rds") |>
  dplyr::rename(type = sampling_desc) |>
  tidyr::drop_na(year, gear, type, sex, length) |>
  dplyr::arrange(gear, type, year, sex) |>
  dplyr::select(year, gear, type, sex, length)

# Survey samples
ds <- readRDS("data/generated/samples-survey.rds") |>
  dplyr::mutate(gear = survey) |>
  dplyr::mutate(type = "survey") |>
  # dplyr::mutate(fleet = fleet(survey)) |>
  dplyr::select(year, gear, type, sex, length)

# Define length ----------------------------------------------------------------

d <- dplyr::bind_rows(dc, ds) |>
  dplyr::mutate(sex = dplyr::case_match(sex, 1 ~ "M", 2 ~ "F")) |>
  tidyr::drop_na(sex)

# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/ss3/length.rds")
