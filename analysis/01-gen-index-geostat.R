# Load
library(dplyr)
library(ggplot2)
library(sdmTMB)
library(tibble)
# Source
source("R/utils.R")
# Theme set
ggplot2::theme_set(gfplot::theme_pbs())

# Read data --------------------------------------------------------------------

h <- readRDS(here::here("data", "raw", "index-hbll-hooks.rds"))
s <- readRDS(here::here("data", "raw", "index-hbll-sets.rds"))
# View data
colnames(h)
colnames(s)
tibble::view(h)
tibble::view(s)

# Wrangle data -----------------------------------------------------------------

length(which(is.na(s$depth_m))) # 0
# Add columns
s <- s |>
  sdmTMB::add_utm_columns() |>
  dplyr::mutate(doy = lubridate::yday(time_deployed))
# Sum hooks
h <- h |>
  dplyr::rowwise() |>
  dplyr::mutate(
    sum_hooks = sum(
      count_target_species +
        count_non_target_species +
        count_empty_hooks +
        count_bait_only +
        count_bent_broken
    )
  ) |>
  dplyr::ungroup() |> # Undo rowwise()
  # Hook competition
  dplyr::mutate(
    count_bait_adj = ifelse(count_bait_only > 0, count_bait_only, 1),
    pit = count_bait_adj / sum_hooks,
    ait = -log(pit) / (1 - pit)
  )
# Check range
range(h$sum_hooks) # 73 246
range(h$pit) # 0.004065041 0.991031390
range(h$ait) # 1.004511 5.527802
# Check events
length(setdiff(s$fishing_event_id, h$fishing_event_id)) # 6
length(setdiff(h$fishing_event_id, s$fishing_event_id)) # 25
# Join and columns
d <- s |>
  dplyr::inner_join(h, by = c("survey", "ssid", "year", "fishing_event_id")) |>
  # Offsets
  dplyr::mutate(offset_hk = log(hook_count / ait)) |>
  dplyr::mutate(offset = log(hook_count)) |>
  # CPUE
  dplyr::mutate(cpue = catch_count / exp(offset)) |>
  # Centred doy
  dplyr::mutate(doy_centre = doy - round(mean(doy)))
# Check
tibble::view(d)
nrow(s) # 1266
nrow(h) # 1285
nrow(d) # 1260

# Plot data --------------------------------------------------------------------



# Create mesh ------------------------------------------------------------------

mesh <- make_mesh(d, c("X", "Y"), cutoff = 10)
plot(mesh)
mesh$mesh$n

# Fit models -------------------------------------------------------------------

fit_nb2 <- sdmTMB(
  catch_count ~ 1,
  family = nbinom2(link = "log"),
  data = d,
  mesh = mesh,
  offset = "offset_hk",
  time = "year",
  spatiotemporal = "rw",
  spatial = "on",
  silent = FALSE,
  anisotropy = TRUE,
  extra_time = as.integer(c(2006, 2017, 2020))
)

# Check model
sanity(fit_nb2)
fit_nb2$sd_report


# Compare models ---------------------------------------------------------------

AIC(fit_nb2)


# Prepare grid -----------------------------------------------------------------

# Get prediction grids
gn <- gfplot::hbll_inside_n_grid$grid
gs <- gfplot::hbll_inside_s_grid$grid
# Setup prediction grid
g <- gn |>
  rbind(gs) |>
  dplyr::rename(latitude = Y, longitude = X) |>
  sdmTMB::add_utm_columns()
# Plot prediction grid
ggplot(g, aes(X, Y)) +
  geom_tile(width = 2, height = 2) +
  coord_fixed()
# Replicate prediction grid
years <- sort(union(unique(d$year), fit_nb2$extra_time))
grid <- sdmTMB::replicate_df(g, time_name = "year", time_values = years)

# Generate index ---------------------------------------------------------------

# Predict
index_geostat_hbll <- fit_nb2 |>
  predict(newdata = grid, return_tmb_object = TRUE) |>
  get_index(bias_correct = TRUE)
# View 
tibble::view(index_geostat_hbll)
# Write 
write_data(index_geostat_hbll, path = "data/generated")
