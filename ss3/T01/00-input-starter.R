# Load -------------------------------------------------------------------------

library(tidyverse)
library(ssio)

# Path -------------------------------------------------------------------------

path <- file.path("ss3", "T01")

# Define -----------------------------------------------------------------------

?ssio::write_starter()

# Write ------------------------------------------------------------------------

ssio::write_starter(
  file = file.path(path, "starter.ss"), 
  sd_report_year_min = 2023, # TODO consider
  sd_report_year_max = 2023, # TODO consider
)
