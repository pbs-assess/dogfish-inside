# Load packages
library(dplyr)
library(r4ss)
library(tibble)

# Path -------------------------------------------------------------------------

path <- file.path("ss3", "A01_test")

# Workflow inputs --------------------------------------------------------------

max_phase <- 10

# Dimension inputs -------------------------------------------------------------

# TODO Consider month_spawn

# Time
year_start <- 1954
year_end <- 2023
n_seasons <- 1
n_subseasons <- 2 # Must be even and >=2
months_per_season <- 12
# Space
n_areas <- 1
# Composition
n_ages <- 70
n_sexes <- 2
# Spawn timing
month_spawn <- 1
season_spawn <- 1
# Growth
n_morphs <- 1
n_platoons <- 1

# Data inputs ------------------------------------------------------------------

# TODO Replace NULL values
# TODO Consider bottom trawl cpue
# TODO Why se_log for outside cpue
# TODO Update month in cpue
# TODO Check length month

# SS3 name: Fleet Definition
# r4ss name: fleetinfo
# Stable across models: Yes
# Manual page: 40
fleet_info <- readRDS("data/ss3/fleet-info.rds")
# Vectors
fleet_types  <- fleet_info |> dplyr::pull(type) 
fleet_names  <- fleet_info |> dplyr::pull(fleet_name)
fleet_timing <- fleet_info |> dplyr::pull(fleet_timing) 
fleet_units  <- fleet_info |> dplyr::pull(fleet_units)  
fleet_area   <- fleet_info |> dplyr::pull(area)   
# Scalars
n_fleets <- nrow(fleet_info)
n_fleets_fishery <- length(which(fleet_types == 1L))
n_fleets_survey <- length(which(fleet_types == 3L))

# SS3 name: catch
# Stable across models: highdiscard differs
# Manual page: 46
catch <- readRDS("data/ss3/catch.rds")
colnames(catch)[2] <- c("seas") # SS_writedat balks at "season"

# SS3 name: Indices
# r4ss name: CPUEinfo and CPUE
# Stable across models: some change index set
# Manual page: 48
cpue_info <- readRDS("data/ss3/cpue-info.rds")
cpue <- readRDS("data/ss3/index.rds")

# SS3 name: Population Length Bins
# Manual page: 55
length_bin_method <- 2
length_bin_size <- 5
length_bin_min <- 25
length_bin_max <- 115
length_bins <- seq(length_bin_min, length_bin_max, length_bin_size)
n_length_bins <- length(length_bins)

# SS3 name: Length Composition Data Structure
# r4ss name: lencomp
# Manual page: 56
lengths <- readRDS("data/ss3/length.rds")
length_info <- readRDS("data/ss3/length-info.rds")
use_length_composition <- 1

# SS3 name: Age Composition Option
# Manual page: 62
n_age_bins <- 0

# Starter inputs ---------------------------------------------------------------

# TODO Consider sd report years

# SD Report
year_min_sd_report <- 2023
year_max_sd_report <- 2023
# MCMC
mcmc_burn <- 250
mcmc_thin <- 5
# Depletion basis: 0 = skip; 1 = B0; 2 = BMSY
depletion_basis <- 1



# Control inputs ---------------------------------------------------------------

# TODO Continue editing control inputs section


# Control
max_combined_bin <- NULL # TODO
bins_pop <- seq(10, 115, 5)
n_bins_pop <- length(bins_pop)
# Ages
n_ages <- 70 # Cp. n_age
age_at_maturity <- NULL # TODO
first_mature_age <- 18 # TODO Consider
# Recruitment
recr_dist_pattern <- NULL # TODO (control)

time_vary_auto_generation <- NULL # TODO (control)

recdev_year_main_start <- NULL # TODO
recdev_year_main_end <- NULL # TODO
recdev_phase <- -3 # TODO Check

# Mortality and growth
mortality_growth_parameters <- NULL # TODO

# SR
sr_function <- 7 # 7 = survivorship function recruits <= production
sr_parameters <- NULL # TODO

# Fishing
maximum_f_value <- NULL # TODO

# Catchability
Q_options <- NULL # TODO
Q_parameters <- NULL # TODO

# Selectivity
size_selex_types <- NULL # TODO
age_selex_types <- NULL # TODO
size_selex_parameters <- NULL # TODO
age_selex_parameters <- NULL # TODO

var_adjustment <- NULL # TODO



# Starter ----------------------------------------------------------------------

# See SS3 User Manual for key
starter <- list(
  sourcefile = file.path(path, "starter.ss"),
  type = "Stock_Synthesis_starter_file",
  SSversion = "3.30",
  datfile = "data.ss",
  ctlfile = "control.ss",
  init_values_src = 0, # 0 = Use values in control file
  run_display_detail = 0, # 0 = ADMB outputs; 1 = each iteration
  detailed_age_structure = 1, # 0 = minimal; 1 = high (with wtatage.ss_new)
  checkup = 0, # Custom report options
  parmtrace = 0, # 0 = omit
  cumreport = 2, # 0 = omit; 1 = brief; 2 = full
  prior_like = 0, # 0 = only active parameters
  soft_bounds = 1, # 0 = omit; 1 = use
  N_bootstraps = 1, # 0 = no .ss_new files; 1 = annotate replicate of data
  last_estimation_phase = max_phase, # -1 = read and exit; n = exit after phase
  MCMCburn = mcmc_burn,
  MCMCthin = mcmc_thin,
  jitter_fraction = 0,
  minyr_sdreport = year_min_sd_report,
  maxyr_sdreport = year_max_sd_report,
  N_STD_yrs = 0, # Extra SD Report Years
  converge_criterion = 1e-04, # Change in log likelihood denoting convergence
  retro_yr = 0, # 0 = none; -x adjust model end year
  min_age_summary_bio = 1, # Min age for inclusion in summary biomass
  depl_basis = depletion_basis,
  depl_denom_frac = 1,
  SPR_basis = 0, # 0 = skip
  F_report_units = 1, # 0 = skip; 1 = biomass; 2 = numbers
  # F_age_range = c(NA, NA),
  F_report_basis = 0, # 0 = report raw
  MCMC_output_detail = 2, # 2 = write report for each mceval
  ALK_tolerance = 0, # Disabled; use 0
  final = "3.30" # Model version check value
  # seed = NULL
)

# Write
# SS_writestarter(starter, file.path(path, "starter.ss"), overwrite = TRUE)

# Control ----------------------------------------------------------------------

control <- list(
  warnings = "", # TODO Check
  Comments = NULL,
  nseas = n_seasons,
  N_areas = n_areas,
  Nages = n_ages,
  Nsexes = n_sexes,
  Npopbins = n_bins_pop,
  Nfleets = n_fleets,
  Do_AgeKey = 0,
  fleetnames = fleet_names,
  sourcefile = file.path(path, "control.ss"),
  type = "Stock_Synthesis_control_file",
  ReadVersion = "3.30",
  eof = TRUE, # TODO Why?
  EmpiricalWAA = 0, 
  N_GP = n_morphs, # Number of growth patterns (aka morphs)
  N_platoon = n_platoons, # Number of platoons within a morph
  recr_dist_method = 4, # Recruitment distribution 4 = no parameters
  recr_global_area = 1,
  recr_dist_read = 1,
  recr_dist_inx = 0,
  recr_dist_pattern = recr_dist_pattern, # TODO Consider
  N_Block_Designs = 0,
  blocks_per_pattern = NULL,
  Block_Design = NULL,
  time_vary_adjust_method = 1, # TODO Check
  time_vary_auto_generation = time_vary_auto_generation, # TODO
  natM_type = 0, # 0 = a single parameter
  GrowthModel = 1, # 1 = von Bertalanffy (3 parameters)
  Growth_Age_for_L1 = 0, # TODO Check
  Growth_Age_for_L2 = 40, # TODO Check
  Exp_Decay = -999, # TODO Check
  Growth_Placeholder = 0, # TODO Check
  N_natMparms = 1,# TODO Check
  SD_add_to_LAA = 0, # TODO Check
  CV_Growth_Pattern = 0, # TODO Check
  maturity_option = 3, # 3 = read maturity-at-age for each female morph
  Age_Maturity = age_at_maturity, # TODO
  First_Mature_Age = first_mature_age, # TODO
  fecundity_option = 4, # TODO Check 4 gives fecundity = a + b * L
  hermaphroditism_option = 0, # 0 = not used
  parameter_offset_approach = 2, # TODO Check 2 gives M_male = M_f * exp(M_m)
  MG_parms = mortality_growth_parameters, # TODO
  MGparm_seas_effects = rep(0, n_seasons), # TODO Check
  SR_function = sr_function,
  Use_steep_init_equi = 1, # 1 = use steepness (h)
  Sigma_R_FofCurvature = 0, # Option not implemented
  SR_parms = sr_parameters,
  do_recdev = 1, # 1 = deviation vector that sums to zero
  MainRdevYrFirst = recdev_year_main_start,
  MainRdevYrLast = recdev_year_main_end,
  recdev_phase = recdev_phase,
  recdev_adv = 0,
  recdev_early_start = NULL, # TODO Check
  recdev_early_phase = NULL, # TODO Check
  Fcast_recr_phase = NULL, # TODO Check
  lambda4Fcast_recr_like = NULL, # TODO Check
  last_early_yr_nobias_adj = NULL, # TODO Check
  first_yr_fullbias_adj = NULL, # TODO Check
  last_yr_fullbias_adj = NULL, # TODO Check
  first_recent_yr_nobias_adj = NULL, # TODO Check
  max_bias_adj = NULL, # TODO Check
  period_of_cycles_in_recr = NULL, # TODO Check
  min_rec_dev = NULL, # TODO Check
  max_rec_dev = NULL, # TODO Check
  N_Read_recdevs = NULL, # TODO Check
  F_ballpark = 0.05,
  F_ballpark_year = -1920, # TODO Check
  F_Method = 3, # TODO Check - Why not recommended 4?
  maxF = maximum_f_value,
  F_iter = 3, # TODO Check
  Q_options = Q_options,
  Q_parms = Q_parameters,
  size_selex_types = size_selex_types,
  age_selex_types = age_selex_types,
  size_selex_parms = size_selex_parameters,
  age_selex_parms = age_selex_parameters,
  Use_2D_AR1_selectivity = 0,
  TG_custom = 0, # TODO Check
  DoVar_adjust = 1, # TODO Check
  Variance_adjustment_list = var_adjustment,
  maxlambdaphase = 1,
  sd_offset = 0,
  lambdas = NULL,
  N_lambdas = 0,
  more_stddev_reporting = 0,
  stddev_reporting_specs = NULL,
  stddev_reporting_selex = NULL,
  stddev_reporting_growth = NULL,
  stddev_reporting_N_at_A = NULL
)

# Write
# SS_writectl(control, file.path(path, "control.ss"), overwrite = TRUE)

# Data -------------------------------------------------------------------------

dat <- list(
  sourcefile = file.path(path, "data.ss"),
  type = "Stock_Synthesis_data_file",
  ReadVersion = "3.30",
  Comments = NULL,
  styr = year_start,
  endyr = year_end, 
  nseas = n_seasons,
  months_per_seas = months_per_season,
  Nsubseasons = n_subseasons,
  spawn_month = month_spawn,
  Nsexes = n_sexes,
  Nages = n_ages,
  N_areas = n_areas,
  Nfleets = n_fleets, 
  fleetinfo = fleet_info, 
  fleetnames = fleet_names,
  surveytiming = fleet_timing,
  units_of_catch = fleet_units,
  areas = fleet_area,
  catch = catch,
  CPUEinfo = cpue_info,
  CPUE = cpue,
  N_discard_fleets = 0, # TODO Consider
  use_meanbodywt = 0, # TODO Consider
  lbin_method = length_bin_method,
  binwidth = length_bin_size,
  minimum_size = length_bin_min,
  maximum_size = length_bin_max,
  use_lencomp = use_length_composition,
  len_info = length_info,
  N_lbins = n_length_bins,
  lbin_vector = length_bins,
  lencomp = lengths,
  N_agebins = n_age_bins,
  # agebin_vector = NULL,
  # N_ageerror_definitions = NULL,
  # ageerror = NULL,
  # age_info = NULL,
  # agecomp = NULL,
  use_MeanSize_at_Age_obs = 0, # TODO Check
  MeanSize_at_Age_obs = NULL,
  N_environ_variables = 0, # TODO Consider
  N_sizefreq_methods_rd = 0,
  N_sizefreq_methods = 0,
  do_tags = 0,
  morphcomp_data = 0,
  use_selectivity_priors = 0,
  eof = TRUE,
  spawn_seas = season_spawn,
  Nfleet = n_fleets_fishery, # Fishery
  Nsurveys = n_fleets_survey, # Survey
  # fleetinfo1 = fleet_info_01,
  # fleetinfo2 = fleet_info_02,
  N_meanbodywt = 0,
  # comp_tail_compression = NULL,
  # add_to_comp = NULL,
  # max_combined_lbin = max_combined_bin, # TODO
  N_MeanSize_at_Age_obs = 0 # TODO Check
  # N_lbinspop = n_bins_pop, # TODO
  # lbin_vector_pop = bins_pop
)

# Write
# SS_writedat(dat, file.path(path, "data.ss"), overwrite = TRUE)
# d <- SS_readdat(file.path(path, "data.ss"))

# Forecast ---------------------------------------------------------------------

forecast <- list(
  warnings = "", # TODO Why?
  SSversion = 3.3,
  sourcefile = file.path(path, "forecast.ss"),
  type = "Stock_Synthesis_forecast_file",
  benchmarks = 1, # 0 = omit; 1 = F_SPR, F_B_target, and F_MSY
  MSY = 2, # 1 = F_SPR as proxy; 2 = F_MSY
  SPRtarget = 0.4, # TODO Why not 0.45? See Manual
  Btarget = 0.4, # TODO Why this value?
  Bmark_years = rep(0, 10), # TODO What benchmark conditional on?
  Bmark_relF_Basis = 1, # TODO What? 1 = year range; 2 = relF same as Forecast
  Forecast = 0, # TODO Why? 0 = single forecast year calculated
  Nforecastyrs = NULL, # TODO Check
  F_scalar = NULL, # F scalar/multiplier
  Fcast_years = NULL, # TODO Check
  Fcast_selex = NULL, # TODO Check
  ControlRuleMethod = NULL,
  BforconstantF = NULL,
  BfornoF = NULL,
  Flimitfraction = NULL,
  N_forecast_loops = NULL,
  First_forecast_loop_with_stochastic_recruitment = NULL,
  fcast_rec_option = NULL,
  fcast_rec_val = NULL,
  Fcast_loop_control_5 = NULL,
  FirstYear_for_caps_and_allocations = NULL,
  stddev_of_log_catch_ratio = NULL,
  Do_West_Coast_gfish_rebuilder_output = NULL,
  Ydecl = NULL,
  Yinit = NULL,
  fleet_relative_F = NULL,
  basis_for_fcast_catch_tuning = NULL,
  N_allocation_groups = NULL,
  InputBasis = NULL,
  eof = NULL
)

# Build input ------------------------------------------------------------------

input <- list(
  dir = path,
  path = path,
  dat = dat,
  ctl = control,
  start = starter,
  fore = forecast
)

# Write ------------------------------------------------------------------------

SS_write(input, dir = path, overwrite = TRUE)
