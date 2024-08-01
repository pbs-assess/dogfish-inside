# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(santoku)
library(tibble)
# Source
source("R/utils.R")
# Theme set
ggplot2::theme_set(gfplot::theme_pbs())

# Adapted from:
# - https://github.com/pbs-assess/dogfish-assess/

# Read data --------------------------------------------------------------------

# Commercial samples
dc <- readRDS("data/generated/samples-commercial.rds") |>
  dplyr::mutate(fleet = fleet(gear)) |>
  dplyr::select(year, fleet, sex, length)

# Survey samples
ds <- readRDS("data/generated/samples-survey.rds") |>
  dplyr::mutate(fleet = fleet(survey)) |>
  dplyr::select(year, fleet, sex, length)

# Define length ----------------------------------------------------------------

# Define bins
bin_size <- 5
bin_lower <- seq(from = 25, to = 115, by = bin_size)
bin_plus_max <- 130
bins <- c(bin_lower, bin_plus_max)
# Apply bins
d <- dplyr::bind_rows(dc, ds) |>
  dplyr::mutate(sex = dplyr::case_match(sex, 1 ~ "M", 2 ~ "F")) |>
  tidyr::drop_na(sex) |>
  dplyr::filter(length > min(bins)) |>
  dplyr::mutate(bin_range = chop(length, breaks = bins)) |>
  dplyr::mutate(bin_name = chop(length, breaks = bins, label = bin_lower)) |>
  dplyr::select(year, fleet, sex, bin_name) |>
  dplyr::group_by(year, fleet, sex, bin_name) |>
  dplyr::summarise(n = n(), .groups = "drop") |>
  dplyr::group_by(year, fleet) |>
  dplyr::mutate(N = sum(n)) |>
  dplyr::ungroup() |>
  dplyr::arrange(fleet, year) |>
  tidyr::pivot_wider(
    names_from = sex:bin_name,
    names_sep = "_",
    names_expand = TRUE,
    values_from = n,
    values_fill = 0
  ) |>
  dplyr::mutate(month = 1, .before = fleet) |>
  dplyr::mutate(sex2 = 3, .before = N) |>
  dplyr::mutate(partition = 0, .before = N)


# Write data -------------------------------------------------------------------

write.csv(d, file = "data/ss3/ss3-length.csv", row.names = FALSE)
