# Load -------------------------------------------------------------------------

library(tidyverse)
library(r4ss)
library(ssio)

# Path -------------------------------------------------------------------------

path <- file.path("ss3", "A00")

# Define -----------------------------------------------------------------------

?ssio::write_starter()

# Write ------------------------------------------------------------------------

ssio::write_starter(
  file = file.path(path, "starter.ss"), 
  year_min_sd_report = 2023, # TODO consider
  year_max_sd_report = 2023, # TODO consider
)
