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




# Fit models -------------------------------------------------------------------




# Compare models ---------------------------------------------------------------




# Generate index ---------------------------------------------------------------




# # Plot
# ggplot(d, aes(year, biomass)) +
#   geom_point() +
#   geom_line() +
#   geom_ribbon(aes(ymin = lowerci, ymax = upperci), alpha = 0.4) +
#   xlab('Year') + 
#   ylab('Biomass estimate (kg)') +
#   facet_wrap(vars(survey_abbrev))
# # Save plot
# save_plot("index-hbll-design", width = 190, height = 120)
# # Write data
# saveRDS(d, "data/generated/index-hbll-design.rds")


# Plot julian
ggplot2::ggplot(s, ggplot2::aes(year, julian, colour = survey_abbrev)) +
  ggplot2::geom_jitter(pch = 21, alpha = 0.3)
# Plot utm
ggplot2::ggplot(s, ggplot2::aes(X, Y, size = density_ppkm2)) +
  ggplot2::geom_point(pch = 21, alpha = 0.3) +
  ggplot2::facet_wrap(ggplot2::vars(year)) +
  ggplot2::coord_fixed()
# Depth and log hook count
s <- s |>
  dplyr::filter(!is.na(depth_m)) |>
  dplyr::mutate(log_hook_count = log(hook_count))
tibble::view(s)
# Plot count bait
ggplot2::ggplot(h, ggplot2::aes(count_bait_only)) +
  ggplot2::geom_histogram() +
  ggplot2::facet_wrap(~year)
# Plot sum hooks
ggplot2::ggplot(h, ggplot2::aes(sum_hooks)) +
  ggplot2::geom_histogram() +
  ggplot2::facet_wrap(~year)

# Plot
ggplot2::ggplot(h, ggplot2::aes(pit, ait, group = year, col = year)) +
  ggplot2::geom_point()


# Plot
ggplot2::ggplot(d, ggplot2::aes(count_target_species, catch_count)) + 
  ggplot2::geom_point()
  # TODO: Why some scatter? Am I using data from gfdata/trials??
ggplot2::ggplot(d, ggplot2::aes(hook_count, sum_hooks)) + 
  ggplot2::geom_abline(slope = 1, intercept = 0) +
  ggplot2::geom_point() + 
  ggplot2::facet_wrap(~year)
  # TODO: Why outlier in 2018?
ggplot2::ggplot(d, ggplot2::aes(catch_count, count_target_species)) + 
  ggplot2::geom_abline(slope = 1, intercept = 0) +
  ggplot2::geom_point() + 
  ggplot2::facet_wrap(~year)
  # TODO: Why outliers 2003, 2004, 2014 and 2018?
ggplot2::ggplot(d, ggplot2::aes(hook_count, count_bait_only)) + 
  ggplot2::geom_abline(slope = 1, intercept = 0) +
  ggplot2::geom_point() + 
  ggplot2::facet_wrap(~year)
# More bait than hooks?
d |> dplyr::filter(count_bait_only > hook_count) |> nrow() # 0

# Define coast
coast <- rnaturalearth::ne_countries(
  scale = 10, 
  continent = "north america", 
  returnclass = "sf"
) |>
  sf::st_crop(xmin = -122.5, xmax = -129, ymin = 48, ymax = 51.2)
# Plot proportion baited hooks
gg <- ggplot(d, aes(longitude, latitude, fill = pit, colour = pit)) +
  geom_sf(data = coast, inherit.aes = FALSE) +
  coord_sf(expand = FALSE) +
  geom_point(pch = 21, alpha = 0.3) +
  facet_wrap(vars(year)) +
  scale_fill_viridis_c(option = "C", limits = c(0, 1)) +
  scale_colour_viridis_c(option = "C", limits = c(0, 1)) +
  theme(
    panel.spacing = unit(0, "in"),
    legend.position = 'bottom',
    axis.text.x = element_text(angle = 45, vjust = 0.5)
  ) +
  labs(
    x = "Longitude", 
    y = "Latitude", 
    fill = "Proportion baited hooks", 
    colour = "Proportion baited hooks"
  )
ggsave("report/figure/hbll-hook-baited.png", gg, height = 6, width = 5, dpi = 600)

# Plot CPUE
gg <- ggplot(d, aes(longitude, latitude, fill = cpue, colour = cpue)) +
  geom_sf(data = coast, inherit.aes = FALSE) +
  coord_sf(expand = FALSE) +
  geom_point(pch = 21, alpha = 0.3) +
  facet_wrap(vars(year)) +
  theme(
    panel.spacing = unit(0, "mm"),
    axis.text.x = element_text(angle = 45, vjust = 0.5)
  ) +
  scale_colour_viridis_c(trans = "log", breaks = c(0.007, 0.05, 0.368, 2.72)) +
  scale_fill_viridis_c(trans = "log", breaks = c(0.007, 0.05, 0.368, 2.72)) +
  labs(x = "Longitude", y = "Latitude", fill = "CPUE", colour = "CPUE")
  # TODO: Why -Inf? Log(0)
ggsave("report/figure/hbll-cpue.png", gg, height = 6, width = 5, dpi = 600)
# Plot cpue histogram
gg <- d %>%
  mutate(cpue = catch_count/exp(offset)) %>%
  #filter(cpue <= 1) %>%
  ggplot(aes(x = cpue, y = after_stat(count))) +
  geom_histogram(
    binwidth = 0.025, 
    linewidth = 0.1, 
    colour = 1, 
    fill = "grey80"
  ) +
  facet_wrap(vars(year)) +
  #theme(panel.spacing = unit(0, "mm")) +
  labs(x = "CPUE", y = "Frequency") +
  coord_cartesian(xlim = c(-0.0125, 0.35), expand = FALSE)
ggsave("report/figure/hbll-cpue-hist.png", gg, height = 6, width = 6)
# Plot CPUE vs depth
gg <- d %>%
  mutate(cpue = catch_count/exp(offset)) %>%
  ggplot(aes(depth_m, log(cpue + 1))) +
  geom_point(alpha = 0.5) +
  facet_wrap(vars(year)) +
  labs(x = "Depth (m)", y = "log(CPUE + 1)") +
  theme(panel.spacing = unit(0, "mm")) +
  coord_cartesian(xlim = c(0, 150))
ggsave("report/figure/hbll-cpue-depth.png", gg, height = 5, width = 6)
# Design index
# TODO: design based index



# SDM mesh
mesh <- make_mesh(d, c("X", "Y"), cutoff = 12)
# TODO: What mesh cutoff?
plot(mesh)
# How many vertices?
mesh$mesh$n # 136
# Plot mesh
g <- local({
  mesh_m <- mesh$mesh
  mesh_m$loc <- 1e3 * mesh_m$loc
  ggplot() +
    geom_sf(data = coast %>% sf::st_transform(crs = 32610), inherit.aes = FALSE) +
    inlabru::gg(mesh_m, edge.color = "grey60") +
    # geom_point(data = mesh$loc_xy %>% as.data.frame() %>% `*`(1e3), aes(X, Y), fill = "red", shape = 21, size = 1) +
    labs(x = "Longitude", y = "Latitude")
})
ggsave("report/figure/hbll-mesh.png", g, width = 5, height = 6)
# Centre julian
mean_julian <- mean(d$julian) # 233.3095
d <- d |>
  dplyr::mutate(julian_centre = julian - 233)
# Missing years?
sort(unique(d$year)) # 2006, 2017, 2020
# Fit sdmTMB
fit_nb2 <- sdmTMB(
  catch_count ~ 1 + poly(log(depth_m), 2L), # need depth_m covar?
  family = nbinom2(link = "log"),
  data = d,
  mesh = mesh,
  offset = "offset_hk",
  time = "year",
  spatiotemporal = "rw",
  spatial = "on",
  silent = FALSE,
  anisotropy = TRUE,
  extra_time = c(2006L, 2017L, 2020L)
)
# Check
sanity(fit_nb2)
# Save with offset_hk
saveRDS(fit_nb2, file = "data/set/hbll-sdmTMB.rds")
fit_nb2 <- readRDS("data/set/hbll-sdmTMB.rds")
# Fit no offset_hk
fit_nb2_nohk <- update(fit_nb2, offset = "offset")
# Check
sanity(fit_nb2_nohk)
# Save witout offset_hk
saveRDS(fit_nb2_nohk, file = "data/set/hbll-sdmTMB-nohk.rds")
fit_nb2_nohk <- readRDS("data/set/hbll-sdmTMB-nohk.rds")
# Fit with julian and no hk
fit_nb2_julian <- update(
  fit_nb2, 
  formula = catch_count ~ 1 + poly(log(depth_m), 2L) + poly(julian_centre, 2L)
)
# Check
sanity(fit_nb2_julian)
# Save with julian and no hk
saveRDS(fit_nb2_julian, file = "data/set/hbll-sdmTMB-julian.rds")
fit_nb2_julian <- readRDS("data/set/hbll-sdmTMB-julian.rds")
# Check aic
AIC(fit_nb2) # 13129.47
AIC(fit_nb2_nohk) # 12529.82
AIC(fit_nb2_julian) # 13096.36
# ...