# Load packages
library(r4ss)

# Workflow inputs --------------------------------------------------------------

max_phase <- 10

# Data frames ------------------------------------------------------------------

# Fleets
fleet_info # TODO See manual p 40 (use dogfish-assess colnames)
fleet_info_01 # TODO
fleet_info_02 # TODO
fleet_names <- fleet_info |> dplyr::pull(fleet_names) # TODO
fleet_timing <- fleet_info |> dplyr::pull(fleet_timing) # TODO
fleet_units <- fleet_info |> dplyr::pull(fleet_units) # TODO
fleet_area <- fleet_info |> dplyr::pull(fleet_area) # TODO
n_fleets <- fleet_info |> dplyr::pull(fleet_index) |> max() # TODO
n_fleets_fishery # TODO
n_fleets_survey # TODO
# Catch
catch <- readr::read_csv(here::here("data", "ss3", "ss3-catch.csv"))
cpue_info # TODO
cpue # TODO
# Lengths
bin_size <- 5
bin_min <- 25
bin_max <- 115
bins <- seq(bin_min, bin_max, bin_size)
n_bins <- length(bins)
lengths <- readr::read_csv(here::here("data", "ss3", "ss3-length.csv"))
length_info # TODO See manual p 56
comp_tail_compression # TODO
add_to_comp # TODO
max_combined_bin # TODO
bins_pop <- seq(10, 115, 5)
n_bins_pop <- length(bins_pop)
# Ages
n_ages <- 70


# Path -------------------------------------------------------------------------

path <- here::here("ss3", "A01_test")

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
  MCMCburn = 250, # MCMC burn in
  MCMCthin = 5, # MCMC thin interval
  jitter_fraction = 0,
  minyr_sdreport = 2023, # TODO Why both 2023?
  maxyr_sdreport = 2023, # TODO Why both 2023?
  N_STD_yrs = 0, # Extra SD Report Years?
  converge_criterion = 1e-04, # Change in log likelihood denoting convergence
  retro_yr = 0, # 0 = none; -x adjust model end year
  min_age_summary_bio = 1, # Min age for inclusion in summary biomass
  depl_basis = 1, # TODO Why? 0 = skip; 1 = relative to B0; 2 = relative to MSY
  depl_denom_frac = 1, # Value to use
  SPR_basis = 0, # TODO Why? 0 = skip
  F_report_units = 1, # 0 = skip; 1 = biomass; 2 = numbers
  F_age_range = c(NA, NA), # Conditional
  F_report_basis = 0, # 0 = report raw
  MCMC_output_detail = 2, # 2 = write report for each mceval
  ALK_tolerance = 0, # Disabled; use 0
  final = 3.3, # Model version check value
  seed = -1 # TODO Why?
)

# Control ----------------------------------------------------------------------

control <- list(
  warnings = ,
  Comments = ,
  nseas = ,
  N_areas = ,
  Nages = ,
  Nsexes = ,
  Npopbins = ,
  Nfleets = ,
  Do_AgeKey = ,
  fleetnames = ,
  sourcefile = ,
  type = ,
  ReadVersion = ,
  eof = ,
  EmpiricalWAA = ,
  N_GP = ,
  N_platoon = ,
  recr_dist_method = ,
  recr_global_area = ,
  recr_dist_read = ,
  recr_dist_inx = ,
  recr_dist_pattern = ,
  N_Block_Designs = ,
  blocks_per_pattern = ,
  Block_Design = ,
  time_vary_adjust_method = ,
  time_vary_auto_generation = ,
  natM_type = ,
  GrowthModel = ,
  Growth_Age_for_L1 = ,
  Growth_Age_for_L2 = ,
  Exp_Decay = ,
  Growth_Placeholder = ,
  N_natMparms = ,
  SD_add_to_LAA = ,
  CV_Growth_Pattern = ,
  maturity_option = ,
  First_Mature_Age = ,
  fecundity_option = ,
  hermaphroditism_option = ,
  parameter_offset_approach = ,
  MG_parms = ,
  MGparm_seas_effects = ,
  SR_function = ,
  Use_steep_init_equi = ,
  Sigma_R_FofCurvature = ,
  SR_parms = ,
  do_recdev = ,
  MainRdevYrFirst = ,
  MainRdevYrLast = ,
  recdev_phase = ,
  recdev_adv = ,
  recdev_early_start = ,
  recdev_early_phase = ,
  Fcast_recr_phase = ,
  lambda4Fcast_recr_like = ,
  last_early_yr_nobias_adj = ,
  first_yr_fullbias_adj = ,
  last_yr_fullbias_adj = ,
  first_recent_yr_nobias_adj = ,
  max_bias_adj = ,
  period_of_cycles_in_recr = ,
  min_rec_dev = ,
  max_rec_dev = ,
  N_Read_recdevs = ,
  F_ballpark = ,
  F_ballpark_year = ,
  F_Method = ,
  maxF = ,
  F_iter = ,
  Q_options = ,
  Q_parms = ,
  size_selex_types = ,
  age_selex_types = ,
  size_selex_parms = ,
  age_selex_parms = ,
  Use_2D_AR1_selectivity = ,
  TG_custom = ,
  DoVar_adjust = ,
  maxlambdaphase = ,
  sd_offset = ,
  lambdas = ,
  N_lambdas = ,
  more_stddev_reporting = ,
  stddev_reporting_specs = ,
  stddev_reporting_selex = ,
  stddev_reporting_growth = ,
  stddev_reporting_N_at_A = 
)

# Data -------------------------------------------------------------------------

dat <- list(
  sourcefile = file.path(path, "data.ss"),
  type = "Stock_Synthesis_data_file",
  ReadVersion = "3.30",
  Comments = NULL,
  styr = 1954, # TODO Check Start year
  endyr = 2023, # End year
  nseas = 1, # TODO Consider
  months_per_seas = 12, # TODO Consider
  Nsubseasons = 2, # TODO Consider Minimum 2 (and even)
  spawn_month = 1, # TODO Consider
  Nsexes = 2, # 2 = two sex, use fraction female in control file
  Nages = n_ages, # Value of plus group; ages start at 0
  N_areas = 1, # Number of areas
  Nfleets = n_fleets, # TODO Check Total number of fishing and survey fleets
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
  lbin_method = 2, # 2 = generate from bin width min max
  binwidth = bin_size,
  minimum_size = bin_min,
  maximum_size = bin_max,
  use_lencomp = 1, # TODO Consider 
  len_info = length_info, # TODO
  N_lbins = n_bins,
  lbin_vector = bins,
  lencomp = lengths,
  N_agebins = 0,
  agebin_vector = NULL,
  N_ageerror_definitions = NULL,
  ageerror = NULL,
  age_info = NULL,
  Lbin_method = NULL, # TODO Check
  agecomp = NULL,
  use_MeanSize_at_Age_obs = 0, # TODO Check
  MeanSize_at_Age_obs = NULL,
  N_environ_variables = 0, # TODO Consider
  N_sizefreq_methods_rd = 0,
  N_sizefreq_methods = 0,
  do_tags = 0,
  morphcomp_data = 0,
  use_selectivity_priors = 0,
  eof = TRUE,
  spawn_seas = 1, # TODO Consider
  Nfleet = n_fleets_fishery, # Fishery
  Nsurveys = n_fleets_survey, # Survey
  fleetinfo1 = fleet_info_01,
  fleetinfo2 = fleet_info_02,
  N_meanbodywt = 0,
  comp_tail_compression = comp_tail_compression, # TODO
  add_to_comp = add_to_comp, # TODO
  max_combined_lbin = max_combined_bin, # TODO
  N_lbinspop = n_bins_pop, # TODO
  lbin_vector_pop = bins_pop
)

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
