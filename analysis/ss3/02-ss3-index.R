# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(tibble)
# Theme set
ggplot2::theme_set(gfplot::theme_pbs())

# Read data --------------------------------------------------------------------

# TODO: Need to reconcile count vs kg 

hbll <- readRDS("data/generated/index-geostat-hbll.rds") |>
  dplyr::mutate(gear = "HBLL") |>
  dplyr::mutate(type = "survey")
  
# TODO: Other indexes?  
  
  
# Define index -----------------------------------------------------------------

# TODO Consider keeping month
# TODO Why month not season like ss3 catch?
# TODO Why est not value like ss3 catch?
# TODO Why not scale indexes into c(0, 1)? Would need to scale se too...
# TODO Convert se to log scale? See ss3 manual

d <- dplyr::bind_rows(hbll) |>
  dplyr::mutate(est = round(est, 3)) |>
  dplyr::mutate(se = round(se, 3)) |>
  dplyr::mutate(month = 1) |> 
  dplyr::filter(est > 0) |>
  # dplyr::select(year, month, fleet, est, se) |>
  dplyr::select(year, month, gear, type, est, se) |>  
  dplyr::arrange(gear, type, year) |> 
  as.data.frame()

# Write index ------------------------------------------------------------------

saveRDS(d, file = "data/ss3/index.rds")

# Plot index -------------------------------------------------------------------

# TODO: Plot index
