# Define creel path on Salmon$ (S:\) network drive
p <- "S:/FMCR_Fishery_Monitoring_Catch_Reporting/Recreational_CM/Catch_Data/"
f <- "SC Sport Catch (Master Do Not Edit).xlsx"
pf <- paste0(p, f)

# Read recreational dogfish catch from CREST creel survey for area 4B
d <- readxl::read_xlsx(
  path = pf,
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
tibble::view(d)
# Write catch
saveRDS(d, file = "data/raw/catch-recreational-creel.rds")

# Define irec path on Region\ (R:\) network drive
p2 <- list.files(
  path = "R:/iREC reporting program/", 
  pattern = "^iREC estimates CALIBRATED.*\\.xlsx$",
  full.names = TRUE
)
p2

# Read recreational dogfish catch from iREC survey for area 4B
d2 <- readxl::read_xlsx(
  path = p2,
  sheet = "calibrated iREC estimates"
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
tibble::view(d2)
# Write catch
saveRDS(d2, file = "data/raw/catch-recreational-irec.rds")
