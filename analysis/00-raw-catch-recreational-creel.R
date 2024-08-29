# Define path ------------------------------------------------------------------

# Path on Salmon$ (S:\) network drive
p <- "S:/FMCR_Fishery_Monitoring_Catch_Reporting/Recreational_CM/Catch_Data"
f <- "SC Sport Catch (Master Do Not Edit).xlsx"
path <- file.path(p, f)
# Sheet
s <- readxl::excel_sheets(path = path)
sheet <- s[1] # "YTD"

# Read Creel data --------------------------------------------------------------

d <- readxl::read_xlsx(
  path = path,
  sheet = sheet,
) |>
  dplyr::rename_with(.fn = tolower) |>
  dplyr::filter(
    species %in% c("NORTH PACIFIC SPINY DOGFISH"),
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

# Write ------------------------------------------------------------------------

saveRDS(d, file = "data/raw/catch-recreational-creel.rds")
