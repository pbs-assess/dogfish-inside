# Define path ------------------------------------------------------------------

# Path on Region\ (R:\) network drive
path <- list.files(
  path = "R:/iREC reporting program/", 
  pattern = "^iREC estimates CALIBRATED.*\\.xlsx$",
  full.names = TRUE
)
# Sheet
s <- readxl::excel_sheets()
sheet <- s[]

# Read iREC data ---------------------------------------------------------------

d <- readxl::read_xlsx(
  path = path,
  sheet = sheet
) |>
  dplyr::rename_with(.fn = tolower) |>
  dplyr::filter(
    item %in% c("Dogfish"),
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

# Write ------------------------------------------------------------------------

saveRDS(d, file = "data/raw/catch-recreational-irec.rds")
