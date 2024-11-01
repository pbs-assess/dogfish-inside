# remotes::install_github("pbs-assess/gfdata")

# Read HBLL survey design index from GFBio for area 4B
d <- gfdata::get_survey_index(
  species = "044",
  ssid = c(39, 40)
)
# View
tibble::view(d)
# Write 
saveRDS(d, file = "data/raw/index-hbll-design.rds")

# Read HBLL survey hook data from GFBio for area 4B
dh <- gfdata::get_ll_hook_data(
  species = "044", 
  ssid = c(39, 40)
) |>
  dplyr::filter(major == 1) # Area 4B
# View hooks
tibble::view(dh)
# Write hooks
saveRDS(dh, file = "data/raw/index-hbll-hooks.rds")

# Read HBLL survey set data from GFBio for area 4B
ds <- gfdata::get_survey_sets(
  species = "044", 
  ssid = c(39, 40)
) |> 
  dplyr::rename(
    survey = survey_desc,
    ssid = survey_series_id
  )
# View 
tibble::view(ds)
# Write 
saveRDS(ds, file = "data/raw/index-hbll-sets.rds")
