# Load -------------------------------------------------------------------------

library(tidyverse)
library(ssio)

# Path -------------------------------------------------------------------------

path <- file.path("ss3", "T01")

# Define -----------------------------------------------------------------------

?ssio::write_control()

# Data frames ------------------------------------------------------------------

# Recruitment
recruitment_info <- create_recruitment_info() |>
  append_recruitment_info(1, 1, 1, 0, name = "Growth pattern 1")
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
catchability_info <- create_catchability_info() |>
  append_catchability_info(4, 1, 0, 0, 0, 1, name = "HBLL")
catchability_parameters <- readRDS("data/ss3/parameters.rds") |>
  dplyr::filter(parameters == "Q") |>
  dplyr::select(-parameters) |>
  as.data.frame()
# Selectivity
n_fleets <- 4
selectivity_size_info <- create_selectivity_info() |>
  append_selectivity_info(24, 0, 0, 0, name = "Bottom trawl") |>
  append_selectivity_info(24, 0, 0, 0, name = "Midwater trawl") |>
  append_selectivity_info(24, 0, 0, 0, name = "Hook and line") |>
  append_selectivity_info(24, 0, 0, 0, name = "HBLL")
selectivity_age_info <- create_selectivity_info() |>
  append_selectivity_info(0, 0, 0, 0, name = "Bottom trawl") |>
  append_selectivity_info(0, 0, 0, 0, name = "Midwater trawl") |>
  append_selectivity_info(0, 0, 0, 0, name = "Hook and line") |>
  append_selectivity_info(0, 0, 0, 0, name = "HBLL")
selectivity_parameters <- readRDS("data/ss3/parameters.rds") |>
  dplyr::filter(parameters == "SS") |>
  dplyr::select(-parameters) |>
  as.data.frame()
# Variance adjustment
variance_info <- create_variance_info() |>
  append_variance_info(4, 1, 1, name = "Bottom trawl") |>
  append_variance_info(4, 2, 1, name = "Midwater trawl") |>
  append_variance_info(4, 3, 1, name = "Hook and line") |>
  append_variance_info(4, 4, 1, name = "HBLL")
# Lambda
lambda_info <- create_lambda_info()

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
