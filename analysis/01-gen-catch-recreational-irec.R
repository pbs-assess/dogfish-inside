# Read data --------------------------------------------------------------------

d <- readRDS("data/raw/catch-recreational-irec.rds")



# Write data -------------------------------------------------------------------

saveRDS(d, file = "data/generated/catch-recreational-irec.rds")
