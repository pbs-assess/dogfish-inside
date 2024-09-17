# Load -------------------------------------------------------------------------

library(tidyverse)
library(ssio)

# Path -------------------------------------------------------------------------

path <- file.path("ss3", "T01")

# Define -----------------------------------------------------------------------

?ssio::write_control()

# Data frames ------------------------------------------------------------------

# Recruitment
recruitment_info <- tibble::tibble(
  growth_pattern = 1,
  month = 1,
  area = 1,
  age_at_settlement = 0
) |>
  as.data.frame()
# Maturity
maturity_data <- readRDS("data/ss3/maturity.rds")
# Mortality and growth
mortality_growth_parameters <- readRDS("data/ss3/parameters.rds") |>
  dplyr::filter(parameters == "MG") |>
  dplyr::select(-parameters) |>
  as.data.frame()
# Seasonal
seasonal_parameters <- rep(0L, 10) |> t() |> as.matrix() |> as.data.frame()
# Spawner recruitment
spawner_recruitment_parameters <- readRDS("data/ss3/parameters.rds") |>
  dplyr::filter(parameters == "SR") |>
  dplyr::select(-parameters) |>
  as.data.frame()
# Catchability
catchability_info <- catchability_option <- tibble::tribble(
  ~fleet, ~link, ~link_info, ~extra_se, ~biasadj, ~float,
       4,     1,          0,         0,        0,      1 # HBLL
) |>
  as.data.frame()
catchability_parameters <- readRDS("data/ss3/parameters.rds") |>
  dplyr::filter(parameters == "Q") |>
  dplyr::select(-parameters) |>
  as.data.frame()
# Selectivity
n_fleets <- 4
selectivity_size_info <- tibble::tibble(
  pattern = rep(24, n_fleets),
  discard = 0,
  male = 0,
  special = 0
) |>
  as.data.frame()
selectivity_age_info <-  tibble::tibble(
  pattern = rep(0, n_fleets),
  discard = 0,
  male = 0,
  special = 0
) |>
  as.data.frame()
selectivity_parameters <- readRDS("data/ss3/parameters.rds") |>
  dplyr::filter(parameters == "SS") |>
  dplyr::select(-parameters) |>
  as.data.frame()
# Variance adjustment
variance_info <- tibble::tibble(
  data_type = 4,
  fleet = seq_len(n_fleets),
  value = 1
) |>
  as.data.frame()
# Lambda
lambda_info <- tibble::tibble() |> as.data.frame()

# Write ------------------------------------------------------------------------

ssio::write_control(
  file = file.path(path, "control.ss"),
  recruitment_info = recruitment_info,
  time_varying_method = 1,
  growth_age_at_l1 = 0,
  growth_age_at_l2 = 40,
  growth_exp_decay = -999,
  growth_add_sd = 0,
  growth_cv_option = 0,
  maturity_option = 3,
  maturity_data = maturity_data,
  maturity_first_age = 18, # Overridden?
  fecundity_option = 4,
  parameter_offset_method = 2,
  mortality_growth_parameters = mortality_growth_parameters,
  seasonal_parameters = seasonal_parameters,
  spawner_recruitment_option = 7,
  spawner_recruitment_parameters = spawner_recruitment_parameters,
  use_steepness = 1,
  spawner_recruitment_feature = 0,
  recruitment_deviation_option = 1, #
  recruitment_deviation_year_start = 1954,
  recruitment_deviation_year_end = 2015,
  recruitment_deviation_phase = -3, #
  recruitment_deviation_advanced = 0,
  fishing_method = 3, #
  fishing_ballpark = 0.05,
  fishing_ballpark_year = -1,
  fishing_maximum = 4,
  fishing_iterations = 4,
  catchability_info = catchability_info,
  catchability_parameters = catchability_parameters,
  selectivity_size_info = selectivity_size_info,
  selectivity_age_info = selectivity_age_info,
  selectivity_parameters = selectivity_parameters,
  variance_info = variance_info,
  lambda_max_phase = 1,
  lambda_sd_offset = 0,
  lambda_info = lambda_info,
  sd_report_option = 0
)
