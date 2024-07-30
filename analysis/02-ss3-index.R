# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(tibble)
# Source
source("R/utils.R")
# Theme set
ggplot2::theme_set(gfplot::theme_pbs())

# Adapted from:
# - https://github.com/pbs-assess/dogfish-assess/

# Read data --------------------------------------------------------------------

# TODO: Need to reconcile count vs kg 

hbll <- readRDS("data/generated/index-geostat-hbll.rds") |>
  dplyr::mutate(fleet = fleet("HBLL"))
  
# TODO: Other indexes?  
  
  
# Define index -----------------------------------------------------------------
# TODO Consider keeping month
# TODO Why month not season like ss3 catch?
# TODO Why est not value like ss3 catch?
# TODO Why not scale indexes into c(0, 1)? Would need to scale se too...

d <- dplyr::bind_rows(hbll) |>
  dplyr::mutate(value = round(est, 3)) |>
  dplyr::mutate(se = round(se, 3)) |>
  dplyr::mutate(month = 1) |> 
  dplyr::filter(est > 0) |>
  dplyr::select(year, month, fleet, est, se) |>
  dplyr::arrange(fleet, year)

# Plot index -------------------------------------------------------------------
# TODO: Plot index

# Write index ------------------------------------------------------------------

write.csv(d, file = "data/ss3/ss3-index.csv", row.names = FALSE)
