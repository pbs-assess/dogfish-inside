
# remotes::install_github("pbs-assess/gfdata")
source("R/utils.R")

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
