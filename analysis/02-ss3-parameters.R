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

# Mortality-Growth -------------------------------------------------------------

# Shared
d1s <- tibble::tibble(
  PRIOR = 0,
  PR_SD = 0,
  PR_type = 0,
  PHASE = -50,
  `env_var&link` = 0,
  dev_link = 0,
  dev_minyr = 0,
  dev_maxyr = 0,
  dev_PH = 0,
  Block = 0,
  Block_Fxn = 0
)

# Tibble setup
d1a <- tibble::tribble(
  ~row_names,               ~LO,     ~HI,      ~INIT,
  "NatM_p_1_Fem_GP_1",     0.01,   0.114,  7.400e-02,
  "L_at_Amin_Fem_GP_1",    1.00,  55.000,  2.840e+01,
  "L_at_Amax_Fem_GP_1",   30.00, 100.000,  9.087e+01,
  "VonBert_K_Fem_GP_1",    0.01,   0.200,  5.800e-02,
  "CV_young_Fem_GP_1",     0.01,   0.300,  2.500e-01,
  "CV_old_Fem_GP_1",       0.01,   0.300,  7.500e-02,
  "Wtlen_1_Fem_GP_1",      0.00,   0.100,  1.890e-06,
  "Wtlen_2_Fem_GP_1",      2.00,   4.000,  3.190e+00,
  "Mat50%_Fem_GP_1",       0.00, 100.000,  9.760e+01,
  "Mat_slope_Fem_GP_1",   -1.00,   0.000, -1.680e-01,
  "Eggs_alpha_Fem_GP_1", -14.70,   3.000, -9.960e+00,
  "Eggs_beta_Fem_GP_1",   -3.00,   3.000,  1.760e-01,
  "NatM_p_1_Mal_GP_1",     0.00,   0.000,  0.000e+00,
  "L_at_Amin_Mal_GP_1",   -2.00,   2.000, -3.900e-02,
  "L_at_Amax_Mal_GP_1",   -1.00,   1.000, -9.300e-02,
  "VonBert_K_Mal_GP_1",   -2.00,   2.000,  4.280e-01,
  "CV_young_Mal_GP_1",    -1.00,   1.000,  0.000e+00,
  "CV_old_Mal_GP_1",      -1.00,   1.000,  2.870e-01,
  "Wtlen_1_Mal_GP_1",      0.00,   0.100,  3.540e-06,
  "Wtlen_2_Mal_GP_1",      2.00,   4.000,  3.030e+00,
  "CohortGrowDev",        -5.00,   5.000,  1.000e+00,
  "Catch_Mult:_1",         0.00,   2.000,  1.000e+00,
  "Catch_Mult:_2",         0.00,   2.000,  3.333e+00,
  "Catch_Mult:_3",         0.00,   2.000,  1.000e+00,
  "Catch_Mult:_4",         0.00,   2.000,  1.000e+00,
  # "Catch_Mult:_5",       0.00,   2.000,  3.333e+00,
  "FracFemale_GP_1",       0.00,   1.000,  5.000e-01
) 
# Row names
row_names <- d1a |> dplyr::pull(row_names)

# Tibble
d1 <- d1a |>
  dplyr::bind_cols(d1s) |>
  dplyr::mutate(parameters = "MG") |>
  as.data.frame() |>
  magrittr::set_rownames(row_names) |>
  dplyr::select(-row_names) |>
  as.data.frame()

# Stock-Recruitment ------------------------------------------------------------
# Column names
col_names <- c("LO", "HI", "INIT", "PRIOR", "PR_SD", "PR_type", "PHASE")

# Shared columns
d2s <- tibble::tibble(
  `env_var&link` = 0,
  dev_link = 0,
  dev_minyr = 0,
  dev_maxyr = 0,
  dev_PH = 0,
  Block = 0,
  Block_Fxn = 0
)

# Tibble setup
d2a <- tibble::tribble(
  ~row_names,       ~LO, ~HI,   ~INIT, ~PRIOR,   ~PR_SD, ~PR_type, ~PHASE,
  "SR_LN(R0)",      5.0,  15, 9.34396,    0.0, 0.000000,        0,      1,
  "SR_surv_Sfrac",  0.0,   1, 0.40000,    0.5, 0.287717,        2,      1,
  "SR_surv_Beta",   0.2,   5, 1.00000,    0.0, 0.000000,        0,    -50,
  "SR_sigmaR",      0.2,   1, 0.40000,    0.0, 0.000000,        0,    -50,
  "SR_regime",     -1.0,   1, 0.00000,    0.0, 0.000000,        0,    -50,
  "SR_autocorr",   -1.0,   1, 0.00000,    0.0, 0.000000,        0,    -50,
)
# Row names
row_names <- d2a |> dplyr::pull(row_names)

# Tibble
d2 <- d2a |>
  dplyr::bind_cols(d2s) |>
  dplyr::mutate(parameters = "SR") |>
  as.data.frame() |>
  magrittr::set_rownames(row_names) |>
  dplyr::select(-row_names) |>
  as.data.frame()

# Catchability -----------------------------------------------------------------

# Shared
d3s <- tibble::tibble(
  PRIOR = 0,
  PR_SD = 0,
  PR_type = 0,
  PHASE = -50,
  `env_var&link` = 0,
  dev_link = 0,
  dev_minyr = 0,
  dev_maxyr = 0,
  dev_PH = 0,
  Block = 0,
  Block_Fxn = 0
)

# Tibble setup
d3a <- tibble::tribble(
       ~row_names, ~LO, ~HI, ~INIT,
  "LnQ_base_HBLL",  -5,   5, -2.65,
)
# Row names
row_names <- d3a |> dplyr::pull(row_names)

# Tibble
d3 <- d3a |>
  dplyr::bind_cols(d3s) |>
  dplyr::mutate(parameters = "Q") |>
  as.data.frame() |>
  magrittr::set_rownames(row_names) |>
  dplyr::select(-row_names) |>
  as.data.frame()


# Selectivity size -------------------------------------------------------------

# Shared columns
d4s <- tibble::tibble(
  `env_var&link` = 0,
  dev_link = 0,
  dev_minyr = 0,
  dev_maxyr = 0,
  dev_PH = 0,
  Block = 0,
  Block_Fxn = 0
)

# Tibble setup
d4a <- tibble::tribble(
                ~row_names,    ~LO, ~HI,  ~INIT, ~PRIOR,~PR_SD,~PR_type,~PHASE,
"SizeSel_P_1_Bottom_trawl",     35, 150,  106.6, 100.00, 30.00,       6,     3,
"SizeSel_P_2_Bottom_trawl",    -10,  50,  -10.0,   0.00,  0.00,       0,   -50,
"SizeSel_P_3_Bottom_trawl",    -10,  10,    5.4,   5.05,  0.30,       6,     3,
"SizeSel_P_4_Bottom_trawl",    -10,  50,   15.0,   0.00,  0.00,       0,   -50,
"SizeSel_P_5_Bottom_trawl",   -999,  70, -999.0,   0.00,  0.00,       0,   -50,
"SizeSel_P_6_Bottom_trawl",   -999, 999, -999.0,   0.00,  0.00,       0,   -50,
"SizeSel_P_1_Midwater_trawl",   35, 110,   52.6,  55.00, 16.50,       6,     3,
"SizeSel_P_2_Midwater_trawl",  -10,  50,  -10.0,   0.00,  0.00,       0,   -50,
"SizeSel_P_3_Midwater_trawl",  -10,  10,    5.4,   4.60,  0.30,       6,     3,
"SizeSel_P_4_Midwater_trawl",  -10,  10,    5.2,   4.00,  0.30,       6,     3,
"SizeSel_P_5_Midwater_trawl", -999,  70, -999.0,   0.00,  0.00,       0,   -50,
"SizeSel_P_6_Midwater_trawl", -999,  70, -999.0,   0.00,  0.00,       0,   -50,
"SizeSel_P_1_Hook_and_line",    35, 110,  101.4,  95.00, 28.50,       6,     3,
"SizeSel_P_2_Hook_and_line",   -10,  50,  -10.0,   0.00,  0.00,       0,   -50,
"SizeSel_P_3_Hook_and_line",   -10,  10,    4.7,   4.00,  0.30,       6,     3,
"SizeSel_P_4_Hook_and_line",   -10,  50,   15.0,   0.00,  0.00,       0,   -50,
"SizeSel_P_5_Hook_and_line",  -999,  70, -999.0,   0.00,  0.00,       0,   -50,
"SizeSel_P_6_Hook_and_line",  -999, 999, -999.0,   0.00,  0.00,       0,   -50,
"SizeSel_P_1_HBLL",             35, 200,  150.0,  95.00, 28.50,       6,     3,
"SizeSel_P_2_HBLL",            -10,  50,  -10.0,   0.00,  0.00,       0,   -50,
"SizeSel_P_3_HBLL",            -10,  10,    6.2,   5.70,  0.30,       6,     3,
"SizeSel_P_4_HBLL",            -10,  50,   15.0,   0.00,  0.00,       0,   -50,
"SizeSel_P_5_HBLL",           -999,  70, -999.0,   0.00,  0.00,       0,   -50,
"SizeSel_P_6_HBLL",           -999, 999, -999.0,   0.00,  0.00,       0,   -50 
)
# Row names
row_names <- d4a |> dplyr::pull(row_names)

# Tibble
d4 <- d4a |>
  dplyr::bind_cols(d4s) |>
  dplyr::mutate(parameters = "SS") |>
  as.data.frame() |>
  magrittr::set_rownames(row_names) |>
  dplyr::select(-row_names) |>
  as.data.frame()



# All --------------------------------------------------------------------------

d <- dplyr::bind_rows(d1, d2, d3, d4) |> as.data.frame()

# Write ------------------------------------------------------------------------

saveRDS(d, "data/ss3/parameters.rds")
