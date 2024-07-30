# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(tibble)
# Source
source("R/utils.R")
# Theme set
ggplot2::theme_set(gfplot::theme_pbs())

# Read data --------------------------------------------------------------------

d <- readRDS("data/raw/samples-commercial.rds") |> 
  dplyr::mutate(area = gfplot::assign_areas(major_stat_area_name, "4B")) |>
  dplyr::mutate(gear = gear_desc) |>
  dplyr::mutate(
    gear = dplyr::case_match(
      gear,
      c("BOTTOM TRAWL")              ~ "Bottom trawl",
      c("MIDWATER TRAWL")            ~ "Midwater trawl",
      c("HOOK AND LINE", "LONGLINE") ~ "Hook and line",
      c("TRAP")                      ~ "Trap",
      c("UNKNOWN", "UNKNOWN TRAWL")  ~ "Unknown/trawl",
    )
  )

# TODO Check length distributions - different between discards/keeper/unsorted?
  
# Glance
dbt <- d |> dplyr::filter(gear == "Bottom trawl")

table(dbt |> dplyr::select(year, sampling_desc))

dhl <- d |> dplyr::filter(gear == "Hook and line")

table(dhl |> dplyr::select(year, sampling_desc))

dmt <- d |> dplyr::filter(gear == "Midwater trawl")

table(dmt |> dplyr::select(year, sampling_desc))
