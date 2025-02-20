# This script will only work with access to the DFO PBS databases
#pulled this from Dogfish-assess

# remotes::install_github('pbs-assess/gfdata')
# remotes::install_github("pbs-assess/gfdata", ref = "trials", force = TRUE) #get get_all
library(gfdata)

spp <- "044"
ssid <- c(39, 40)


x <- get_ssids()


# pull SOG  trawl survey
sog_trawl_sets <- get_survey_sets( #ran two years..
  species = spp,
  ssid = 45,
  join_sample_ids = TRUE,
  verbose = TRUE,
  sleep = 0
)
unique(sog_trawl_sets$year)


# ssid = 15 lingcod trawl
sog_lingcod_sets <- get_survey_sets( #ran four years
  species = spp,
  ssid = 15,
  join_sample_ids = TRUE,
  verbose = TRUE,
  sleep = 0
)
unique(sog_lingcod_sets$year)


# 95 SOG mid water trawl 
# sog_midwater_sets <- get_survey_sets( #not supported, not sure where we could get these data
#   species = spp,
#   ssid = 95,
#   join_sample_ids = TRUE,
#   verbose = TRUE,
#   sleep = 0
# )
# unique(sog_miudwater_sets$year)


#pull SOG HBLL N and S suvey
survey_sets <- get_survey_sets(
  species = spp,
  ssid = ssid,
  join_sample_ids = TRUE,
  verbose = TRUE,
  sleep = 0
)

# Read HBLL survey hook data from GFBio for area 4B
dh <- gfdata::get_ll_hook_data(
  species = "044", 
  ssid = c(39, 40)
) |>
  dplyr::filter(major == 1) # Area 4B
tibble::view(dh)
saveRDS(dh, file = "data/raw/index-hbll-hooks.rds")


survey_samples <- get_survey_samples(
  species = spp,
  ssid = ssid
)

commercial_samples <- get_commercial_samples(
  spp,
  unsorted_only = FALSE,
  return_all_lengths = FALSE
)
# privacy (and extra) removals:
commercial_samples$vessel_id <- NULL
commercial_samples$dna_sample_type <- NULL
commercial_samples$dna_container_id <- NULL

catch <- get_catch(spp)

# spatial privacy issues:
# cpue_spatial <- get_cpue_spatial(spp)
# cpue_spatial_ll <- get_cpue_spatial_ll(spp)
# catch_spatial <- get_catch_spatial(spp)

# design-based indices:
survey_index <- get_survey_index(spp)

# age_precision <- get_age_precision(spp)

# pull inside dogfish and hbll sets
# survey ids include all of the dogfish surveys on the inside
d <- get_all_survey_sets("north pacific spiny dogfish", ssid = c(76, 48, 39, 40))
unique(d$survey_abbrev)
d$vessel_id <- NULL

# pull inside samples data
samps_all <- get_all_survey_samples("north pacific spiny dogfish", ssid = c(76, 48, 39, 40), include_event_info = TRUE)
samps_all$vessel_id <- NULL
samps_all$dna_sample_type <- NULL
samps_all$dna_container_id <- NULL


save_dat <- function(obj, filename) {
  attr(obj, "version") <- utils::packageVersion("gfdata")
  attr(obj, "date") <- Sys.time()
  saveRDS(obj, file = paste0("data/raw/", filename, ".rds"))
}


save_dat(sog_trawl_sets, "sog-trawl-sets")
save_dat(sog_lingcod_sets, "sog-lingcod-sets")
save_dat(survey_sets, "survey-sets")
save_dat(survey_samples, "survey-samples")
save_dat(commercial_samples, "commercial-samples")
save_dat(catch, "catch")
save_dat(survey_index, "design-based-indices")
save_dat(d, "survey-sets-getall")
save_dat(samps_all, "survey-samples-getall")
