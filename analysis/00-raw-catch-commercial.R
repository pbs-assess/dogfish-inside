# remotes::install_github("pbs-assess/gfdata")
library(gfdata)
library(readr)

# Read contemporary ------------------------------------------------------------

d <- gfdata::get_catch(
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
tibble::view(d)
# Write catch
saveRDS(d, file = "data/raw/catch-commercial.rds")

# Read historical --------------------------------------------------------------

# From https://github.com/pbs-assess/dogfish-assess/
path <- file.path(dirname(getwd()), "dogfish-assess/data/raw/")


# All 1935-1965
# Galluci et al. (2011) ResDoc 2011/034 Table 2 (p.33)
# Annual landings (tonnes)

d <- read_csv(paste0(path, "catches-all-gears-1935-1965.csv"), skip = 2)

# Write
saveRDS(d, "data/raw/catch-commercial-all-gears-1935-1965.rds")

# Longline 1966-2008
# Galluci et al. (2011) ResDoc 2011/034 Table 3 (p.34)
# Annual landings (tonnes)

d <- read_csv(paste0(path, "catches-longline-1966-2008.csv"), skip = 2)

# Write
saveRDS(d, "data/raw/catch-commercial-longline-1966-2008.rds")

# Trawl 1966-2008
# Galluci et al. (2011) ResDoc 2011/034 Table 3 (p.34)
# Annual landings (tonnes)

d <- read_csv(paste0(path, "catches-trawl-1966-2008.csv"), skip = 2)

# Write
saveRDS(d, "data/raw/catch-commercial-trawl-1966-2008.rds")
