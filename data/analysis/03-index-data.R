# Setup ------------------------------------------------------------------------

library(dplyr)
# remotes::install_github("pbs-assess/gfdata")
library(gfdata)
source("R/utils.R")

# Raw --------------------------------------------------------------------------

## Inside HBLL hook data -------------------------------------------------------

# Read HBLL survey hook data from GFBio for area 4B
index_hbll_hooks <- gfdata::get_ll_hook_data(
  species = "044", 
  ssid = c(39, 40)
) |>
  dplyr::filter(major == 1) # Area 4B
# View hooks
tibble::view(index_hbll_hooks)
# Write hooks
write_data(index_hbll_hooks, path = "data/raw")

## Inside HBLL survey sets -----------------------------------------------------

# Read HBLL survey set data from GFBio for area 4B
index_hbll_sets <- gfdata::get_survey_sets(
  species = "044", 
  ssid = c(39, 40)
) |> 
  dplyr::rename(
    survey = survey_desc,
    ssid = survey_series_id
  )
# View 
tibble::view(index_hbll_sets)
# Write 
write_data(index_hbll_sets, path = "data/raw")

# Generated --------------------------------------------------------------------



# SS3 --------------------------------------------------------------------------





# End --------------------------------------------------------------------------