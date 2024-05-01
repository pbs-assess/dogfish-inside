# Setup ------------------------------------------------------------------------

library(dplyr)
# remotes::install_github("pbs-assess/gfdata")
library(gfdata)
library(readxl)
source("R/utils.R")

# Raw --------------------------------------------------------------------------

## Commercial catch ------------------------------------------------------------

# Read commercial dogfish catch from GFCatch for area 4B
catch_commercial <- gfdata::get_catch(
  species = "044",
  major = "01"
) |>
  dplyr::select(
    fishery_sector,
    gear,
    year,
    best_date,
    best_depth,
    species_code,
    species_common_name,
    species_scientific_name,
    landed_kg,
    discarded_kg,
    landed_pcs,
    discarded_pcs,
    major_stat_area_name,
    minor_stat_area_code
  )
# View catch
tibble::view(catch_commercial)
# Write catch
write_data(catch_commercial, path = "data/raw")

## Recreational catch ----------------------------------------------------------

# Define creel path on Salmon$ (S:\) network drive
path <- "S:/FMCR_Fishery_Monitoring_Catch_Reporting/Recreational_CM/Catch_Data/"
creel_path <- paste0(path, "SC Sport Catch (Master Do Not Edit).xlsx")
# Read recreational dogfish catch from CREST creel survey for area 4B
catch_recreational_creel <- readxl::read_xlsx(
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
# View catch
tibble::view(catch_recreational_creel)
# Write catch
write_data(catch_recreational_creel, path = "data/raw")

# Define irec path on Region\ (R:\) network drive
irec_path <- list.files(
  path = "R:/GMU/iREC estimates/", 
  pattern = "^iREC estimates.*\\.xlsx$", # Begins with "iREC estimates" etc.
  full.names = TRUE
)
irec_path
# Read recreational dogfish catch from iREC survey for area 4B
catch_recreational_irec <- readxl::read_xlsx(
  path = irec_path,
  sheet = "iREC estimates"
) |>
  dplyr::rename_with(.fn = tolower) |>
  dplyr::filter(
    item %in% c("Dogfish"), # "Fisher Days (adult)", "Fisher Days (juvenile)"
    area %in% c(paste("Area", 12:20),
                paste("Area", 28:29),
                paste("Area 19", c("(GS)", "(JDF)")),
                paste("Area 20", c("(East)", "(West)")),
                paste("Area 29", c("(Marine)")))
  ) |>
  dplyr::select(
    logistical_area,
    year,
    month,
    area,
    method,
    item,
    disposition,
    retainable,
    estimate,
    variance
  )
# View catch
tibble::view(catch_recreational_irec)
# Write catch
write_data(catch_recreational_irec, path = "data/raw")

## FSC catch -------------------------------------------------------------------

# Define FSC path on DFO laptop drive
path <- "C:/Users/rogersl/data/fsc/"
fsc_path <- paste0(
  path, 
  "LingcodDogfishGroundfishFSCforallyears_BasicEstimate_21-Feb-24.xlsx"
)
# Read FSC dogfish catch from KREST survey for area 4B
catch_fsc <- readxl::read_xlsx(
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
# View catch
tibble::view(catch_fsc)
## Write catch
write_data(catch_fsc, path = "data/raw")


# Generated --------------------------------------------------------------------



# SS3 --------------------------------------------------------------------------





# End --------------------------------------------------------------------------
