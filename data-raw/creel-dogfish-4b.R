# Read CREST Creel Inside Dogfish Recreational Catch Data

## Load packages ---------------------------------------------------------------

library(dplyr)
library(readxl)

## Load scripts ----------------------------------------------------------------

source("R/utils.R")

## List filenames in Creel estimates folder -------------------------------------

# Salmon$ (S:\) Network Drive
path <- "S:/FMCR_Fishery_Monitoring_Catch_Reporting/Recreational_CM/Catch_Data/"
# List files
list.files(path = path)

## Assign the current spreadsheet path -----------------------------------------

creel_path <- paste0(path, "SC Sport Catch (Master Do Not Edit).xlsx")
creel_path

## Read Creel data --------------------------------------------------------------

creel_dogfish_4b <- readxl::read_xlsx(
  path = creel_path,
  sheet = "YTD"
) |>
  dplyr::rename_with(.fn = tolower) |>
  dplyr::filter(
    species %in% c("NORTH PACIFIC SPINY DOGFISH"), # "BOAT TRIPS"
    pfma %in% c(
      paste("PFMA", 12:20),
      paste("PFMA", 28:29)
    )
  ) |>
  dplyr::select(
    pfma,
    year,
    month,
    disposition,
    species,
    species_code,
    scientific_name,
    estimate,
    standard_error,
    percent_standard_error
  )

# View data --------------------------------------------------------------------

tibble::view(creel_dogfish_4b)

## Write to data/ --------------------------------------------------------------

write_data(creel_dogfish_4b, path = "data")
