# Read data --------------------------------------------------------------------

d <- readRDS("data/raw/catch-recreational-creel.rds")





# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/generated/catch-recreational-creel.rds")
