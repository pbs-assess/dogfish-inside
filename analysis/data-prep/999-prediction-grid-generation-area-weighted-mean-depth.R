# remotes::install_github("pbs-assess/gfplot")
library(gfplot)
library(gfdata)
library(terra)
library(tidyverse)
library(sf)
library(here)

# NOTES
# Generate a prediction grid with an area-weighted mean depth, area weight mean depth with only those depths sampled by the survey for that block, and centroid depth. 
# Grid trimmed to coastline and overwater area calculated.
# make grids that covers HBLL N and S and all of Strait of Georgia
# have the HBLL INS grid nested inside the bigger grid


# DEM and land mass data is on one drive (too big for github): OneDrive - DFO-MPO\lingcod and dogfish program\dogfish-inside\data-raw\
# Could get a higher resolution DEM
# DEM data from here: https://osdp-psdo.canada.ca/dp/en/search/metadata/NRCAN-FGP-1-e6e11b99-f0cc-44f7-f5eb-3b995fb1637e
# BC land mass data from here: https://catalogue.data.gov.bc.ca/dataset/province-of-british-columbia-boundary-terrestrial/resource/3d72cf36-ab53-4a2a-9988-a883d7488384

# Jillian created grids for HBLL N and S that have over water area. See here: https://github.com/pbs-assess/gfdata/blob/85f4355ab7cba133674f425e3892f80e74894dfa/data-raw/survey_blocks.R#L80

# params
bccrs <- 32609
hbllshallow <- c(40, 70)
hblldeep <- c(71, 100)
dogshallow <- 5
dogdeep <- 350

# load data
depth <- terra::rast("C:/Users/DAVIDSONLI/OneDrive - DFO-MPO/lingcod and dogfish program/dogfish-inside/data-raw/dem_excluded_land.tif")
st_layers("C:/Users/DAVIDSONLI/OneDrive - DFO-MPO/lingcod and dogfish program/dogfish-inside/data-raw/BC_Boundary_Terrestrial.gpkg") # get layer name of single polygon
bc_poly <- st_read("C:/Users/DAVIDSONLI/OneDrive - DFO-MPO/lingcod and dogfish program/dogfish-inside/data-raw/BC_Boundary_Terrestrial.gpkg", layer = "BC_Boundary_Terrestrial_Multipart")
bc_shelf_poly <- st_read("C:/Users/DAVIDSONLI/OneDrive - DFO-MPO/lingcod and dogfish program/dogfish-inside/data-raw/Shelf_polygon.shp") # something like this probably this file on pacea I used this instead of trimming to the bc_poly as this has the boundary of the SOG
hbllblockdes <- readRDS("data/raw/All_HBLL_Blocks_Area_Water.rds") |>
  filter(SS_ALT_DES %in% c("INS S", "INS N")) |>
  dplyr::select(LATITUDE, LONGITUDE, G_DEPTH_ID) # link G_DEPTH_ID to the survey blocks, I don't see a common attribute
hbllblockdes2 <- st_as_sf(hbllblockdes, coords = c("LONGITUDE", "LATITUDE"), crs = 4326) |>
  st_transform(32609)


# create a grid that covers all of the HBLL INS S, S and the rest of the SOG
# make sure it's only overwater area
# make sure the depth is area weighted mean depth using the DEM
depthcr1 <- crop(depth, c(800000, 1313158, 304657.4, 700000))
r.pr <- terra::project(depthcr1, "EPSG:32609", res = 2000)
plot(r.pr)


bc_shelf_polypr <- bc_shelf_poly |>
  st_transform(32609) # sog polygon projected

# small_bc_ins <- bc_poly |>
#   st_transform(32609) |>
#   st_crop(r.pr)
# plot(st_geometry(small_bc_ins))


# create a grid that covers SOG with HBLL INS S and N nested in this bigger grid
blocks <- gfdata::survey_blocks |> filter(survey_abbrev %in% c("HBLL INS S", "HBLL INS N")) # area is overwater area
blocks <- blocks |> rename(area_orig = area)
blocks <- st_join(blocks, hbllblockdes2) # get depth category attribute

ggplot() +
  geom_sf(data = blocks, aes(fill = depth_m))

ggplot() +
  geom_sf(data = blocks, aes(colour = as.factor(G_DEPTH_ID)))

ggplot() +
  geom_sf(data = hbllblockdes2) +
  geom_sf(data = blocks, aes(colour = depth_m))

# polygon of SOG
grid <- blocks |> sf::st_make_grid(square = TRUE, cellsize = 2000)
grid |>
  ggplot() +
  geom_sf() +
  geom_sf(data = blocks, fill = "red")


# make a polygon around HBLL N and S grid
hulls <- st_buffer(blocks, dist = 20000)
soghull <- spatialEco::sf_dissolve(hulls) |> st_as_sf()
ggplot() +
  geom_sf(data = soghull) +
  geom_sf(data = blocks)

soggrid <- st_intersection(soghull, grid)
soggrid2 <- st_intersection(soggrid, bc_shelf_polypr)

ggplot() +
  geom_sf(data = soggrid2) +
  geom_sf(data = blocks, fill = "red")

soggrid3 <- st_join(soggrid2, blocks) # get attributes

soggrid3 <- soggrid3 %>%
  mutate(area_km2 = st_area(., units = "km^2") / 1000000) |>
  mutate(FID = seq(1:n())) |>
  mutate(area_km2 = as.numeric(area_km2))

#sog grid with DEM depths from centroid
soggrid4 <-  soggrid3 |>
  st_centroid() |>
  mutate(
    UTM.lat.m = unlist(purrr::map(x, 2)),
    UTM.lon.m = unlist(purrr::map(x, 1))
  ) |>
  st_join(bdepths_sf) |>
  st_drop_geometry() |>
  mutate(depth_dem_m = west_coast_dem * -1) |> 
  mutate(UTM.lat = UTM.lat.m / 1000, UTM.lon = UTM.lon.m / 1000) |> 
  mutate(depth_dem_m = ifelse(is.na(depth_dem_m) == TRUE, depth_m, depth_dem_m)) #use the original depth if NA

soggrid4 |> filter(is.na(depth_dem_m) == TRUE) |> tally() #how many have NA depths
ggplot() + geom_point(data = soggrid4, aes(UTM.lon, UTM.lat, colour = depth_dem_m))
saveRDS(soggrid4, "data/generated/prediction-grid-centroid-dem-depth.rds")

#calculate area-weighted depth
# intersect SOG grid with the DEM to get depth
bdepths <- crop(r.pr, soggrid3)
bdepths_poly <- terra::as.polygons(bdepths)
bdepths_sf <- st_as_sf(bdepths_poly)

ggplot() +
  geom_sf(data = (bdepths_sf), colour = "red") +
  geom_sf(data = (soggrid3), aes(colour = FID))

bdepths_int <- st_intersection(soggrid3, bdepths_sf) %>%
  mutate(area_int = st_area(., units = "km^2") / 1000000) |>
  mutate(area_int = as.numeric(area_int)) |> # not all grid cells intersect with the DEM
  mutate(depth_dem_m = west_coast_dem * -1)

ggplot() +
  geom_sf(data = soggrid3, colour = "red") +
  geom_sf(data = bdepths_int, aes(colour = depth_dem_m))

# for the hbll grid take the area weighted mean of the fished depths, i.e. if a shallow block those depths that are  between 40 - 70 and if deep 71-100.
# remove depths that are outside of these ranges
# then sum the area that intersects and that becomes the area of the grid cell?

bdepths_int2 <- bdepths_int |>
  mutate(in_depth_range = ifelse(G_DEPTH_ID == 1 & depth_dem_m %in% c(40:70), "yes",
    ifelse(G_DEPTH_ID == 1 & !(depth_dem_m %in% c(40:70)), "no",
      ifelse(G_DEPTH_ID == 2 & depth_dem_m %in% c(71:100), "yes",
        ifelse(G_DEPTH_ID == 2 & !(depth_dem_m %in% c(71:100)), "no",
          ifelse(is.na(G_DEPTH_ID) == TRUE & depth_dem_m %in% c(5:350), "yes",
            ifelse(is.na(G_DEPTH_ID) == TRUE & !(depth_dem_m %in% c(5:350)), "no", NA)
          )
        )
      )
    )
  ))


bdepths_int3 <- bdepths_int2 |>
  filter(in_depth_range != "no") |> 
  mutate(weight = area_int / sum(area_int)) |>
  mutate(area_weighted_depth = (depth_dem_m * weight)) |>
  group_by(FID) |>
  mutate(area_weighted_mean_depth_realized = sum(area_weighted_depth) / sum(weight)) |> #depth that falls into the HBLL block categories or between the dogfish depth limits
  distinct(FID, .keep_all = TRUE) |> 
  dplyr::select(id, survey_abbrev, survey_series_id, block_id, depth_m, active_block, area_orig, G_DEPTH_ID, area_km2, depth_dem_m, area_weighted_mean_depth_realized)


bdepths_int4 <- bdepths_int2 |>
  mutate(weight = area_int / area_km2) |>
  mutate(area_weighted_depth = (depth_dem_m * weight)) |>
  group_by(FID) |>
  mutate(area_weighted_mean_depth = sum(area_weighted_depth) / sum(weight)) |> #all the depths that intersect with that cell
  distinct(FID, .keep_all = TRUE) |> 
  st_centroid() |>
  mutate(
    UTM.lat.m = unlist(purrr::map(x, 2)),
    UTM.lon.m = unlist(purrr::map(x, 1))
  ) |>
  st_drop_geometry() |>
  mutate(UTM.lat = UTM.lat.m / 1000, UTM.lon = UTM.lon.m / 1000) |> 
  dplyr::select(id, survey_abbrev, survey_series_id, block_id, depth_m, active_block, area_orig, G_DEPTH_ID, area_km2, depth_dem_m, area_weighted_mean_depth, UTM.lat.m, UTM.lon.m, UTM.lat, UTM.lon)

x <- left_join(bdepths_int4, bdepths_int3)
y <- soggrid3 |> st_drop_geometry()
soggrid5 <- left_join(y, x)

ggplot() +
  geom_sf(data = bdepths_int)

ggplot() +
  geom_point(data = soggrid5, aes(UTM.lon, UTM.lat, colour = area_weighted_mean_depth)) # for the point missing a rea weighted mean depth use the depth column from the original blocks dataset? or keep NA?

ggplot() +
  geom_jitter(data = bdepths_int4, aes(G_DEPTH_ID, depth_dem_m, colour = area_weighted_mean_depth_realized)) # for the point missing a rea weighted mean depth use the depth column from the original blocks dataset? or keep NA?

ggplot() +
  geom_point(data = soggrid5, aes(area_weighted_mean_depth_realized, depth_dem_m, colour = area_weighted_mean_depth)) # made 
ggplot() +
  geom_point(data = soggrid5, aes(area_weighted_mean_depth, depth_dem_m, colour = area_weighted_mean_depth)) # made 

range(na.omit(soggrid5$depth_m))
range(na.omit(soggrid5$area_weighted_mean_depth_realized))
range(na.omit(soggrid5$weighted_depth_m))
range(na.omit(soggrid5$area_km2))

saveRDS(grid, "data/generated/prediction-grid-weighted-mean.rds")
