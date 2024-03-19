# Read iREC Inside Dogfish Recreational Catch Data

## Load packages ---------------------------------------------------------------

library(dplyr)
library(readxl)

## Load scripts ----------------------------------------------------------------

source("R/utils.R")

## List filenames in iREC estimates folder -------------------------------------

# Region\ (R:\) Network Drive
list.files(path = "R:/GMU/iREC estimates/")

## Assign the current spreadsheet path -----------------------------------------

irec_path <- list.files(
  path = "R:/GMU/iREC estimates/", 
  pattern = "^iREC estimates.*\\.xlsx$", # Begins with "iREC estimates" etc.
  full.names = TRUE
)
irec_path

## Read iREC data --------------------------------------------------------------

irec_dogfish_4b <- readxl::read_xlsx(
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
  
# View data --------------------------------------------------------------------

tibble::view(irec_dogfish_4b)

## Write to data/ --------------------------------------------------------------

write_data(irec_dogfish_4b, path = "data")
