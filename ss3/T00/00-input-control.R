# Load -------------------------------------------------------------------------

library(tidyverse)
library(ssio)

# Path -------------------------------------------------------------------------

path <- file.path("ss3", "T00")

# Define -----------------------------------------------------------------------

?ssio::write_control()

# Recruitment ------------------------------------------------------------------

recruitment_info <- create_recruitment_info() |>
  append_recruitment_info(1, 1, 1, 0, name = "Growth pattern 1")

# Maturity ---------------------------------------------------------------------

maturity_data <- readRDS("data/ss3/maturity.rds")

# Mortality and growth ---------------------------------------------------------

mortality_growth_parameters <- create_p() |>
  append_p(0.010, 0.11, 0.0740, 0, 0, 0, -50, name = "NatM_p_1_Fem_GP_1") |>
  append_p(1.000, 55.0, 28.000, 0, 0, 0, -50, name = "L_at_Amin_Fem_GP_1") |>
  append_p(30.00, 100., 91.000, 0, 0, 0, -50, name = "L_at_Amax_Fem_GP_1") |>
  append_p(0.010, 0.20, 0.0580, 0, 0, 0, -50, name = "VonBert_K_Fem_GP_1") |>
  append_p(0.010, 0.30, 0.2500, 0, 0, 0, -50, name = "CV_young_Fem_GP_1") |>
  append_p(0.010, 0.30, 0.0750, 0, 0, 0, -50, name = "CV_old_Fem_GP_1") |>
  append_p(0.000, 0.10, 1.9e-6, 0, 0, 0, -50, name = "Wtlen_1_Fem_GP_1") |>
  append_p(2.000, 4.00, 3.2000, 0, 0, 0, -50, name = "Wtlen_2_Fem_GP_1") |>
  append_p(0.000, 100., 98.000, 0, 0, 0, -50, name = "Mat50%_Fem_GP_1 ") |>
  append_p(-1.00, 0.00, -0.170, 0, 0, 0, -50, name = "Mat_slope_Fem_GP_1") |>
  append_p(-14.7, 3.00, -10.00, 0, 0, 0, -50, name = "Eggs_alpha_Fem_GP_1") |>
  append_p(-3.00, 3.00, 0.1800, 0, 0, 0, -50, name = "Eggs_beta_Fem_GP_1") |>
  append_p(0.000, 0.00, 0.0000, 0, 0, 0, -50, name = "NatM_p_1_Mal_GP_1") |>
  append_p(-2.00, 2.00, 0.0390, 0, 0, 0, -50, name = "L_at_Amin_Mal_GP_1") |>
  append_p(-1.00, 1.00, -0.093, 0, 0, 0, -50, name = "L_at_Amax_Mal_GP_1") |>
  append_p(-2.00, 2.00, 0.4300, 0, 0, 0, -50, name = "VonBert_K_Mal_GP_1") |>
  append_p(-1.00, 1.00, 0.0000, 0, 0, 0, -50, name = "CV_young_Mal_GP_1") |>
  append_p(-1.00, 1.00, 0.2900, 0, 0, 0, -50, name = "CV_old_Mal_GP_1") |> 
  append_p(0.000, 0.10, 3.5e-6, 0, 0, 0, -50, name = "Wtlen_1_Mal_GP_1") |>
  append_p(2.000, 4.00, 3.0000, 0, 0, 0, -50, name = "Wtlen_2_Mal_GP_1") |>
  append_p(-5.00, 5.00, 1.0000, 0, 0, 0, -50, name = "CohortGrowDev") |>
  append_p(0.000, 2.00, 1.0000, 0, 0, 0, -50, name = "Catch_Mult:_1") |>
  append_p(0.000, 2.00, 1.0000, 0, 0, 0, -50, name = "Catch_Mult:_2") |>
  append_p(0.000, 2.00, 1.0000, 0, 0, 0, -50, name = "Catch_Mult:_3") |>
  append_p(0.000, 2.00, 1.0000, 0, 0, 0, -50, name = "Catch_Mult:_4") |>
  append_p(0.000, 1.00, 0.5000, 0, 0, 0, -50, name = "FracFemale_GP_1")

# Seasonal ---------------------------------------------------------------------

seasonality_info <- create_seasonality_info() |>
  append_seasonality_info(name = "seasonality")

seasonality_info <- rep(0L, 10) |> t() |> as.matrix() |> as.data.frame()

# Spawner recruitment ----------------------------------------------------------

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
  seasonality_info = seasonality_info,
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
