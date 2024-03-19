# Read KREST FSC Inside Dogfish Recreational Catch Data

## Load packages ---------------------------------------------------------------

library(dplyr)
library(lubridate)
library(readxl)

## Load scripts ----------------------------------------------------------------

source("R/utils.R")

## List filenames in data\fsc\ folder ------------------------------------------

# DFO Laptop drive
path <- "C:/Users/rogersl/data/fsc/"
# List files
list.files(path = path)

## Assign the current spreadsheet path -----------------------------------------

fsc_path <- paste0(
  path, 
  "LingcodDogfishGroundfishFSCforallyears_BasicEstimate_21-Feb-24.xlsx"
)
fsc_path

## Read FSC data --------------------------------------------------------------

fsc_dogfish_4b <- readxl::read_xlsx(
  path = fsc_path,
  sheet = "Interview Data_LingcodDogfishGr"
) |>
  dplyr::rename_with(.fn = tolower) |>
  dplyr::filter(
    species %in% c("NORTH PACIFIC SPINY DOGFISH", "UNIDENTIFIED GROUNDFISH"),
    estimation_area %in% c(paste("PFMA", 12:20), paste("PFMA", 28:29))
  ) |>
  dplyr::mutate(
    pfma = estimation_area,
    year = lubridate::year(start_time),
    month = lubridate::month(start_time),
    catch = catch_count,
    units = tolower(units),
    comment = catch_data_comment
  ) |>
  dplyr::select(
    purpose,
    pfma,
    gear_type,
    year,
    month,
    disposition,
    species,
    catch,
    units,
    comment
  )

# View data --------------------------------------------------------------------

tibble::view(fsc_dogfish_4b)

## Write to data/ --------------------------------------------------------------

write_data(fsc_dogfish_4b, path = "data")
