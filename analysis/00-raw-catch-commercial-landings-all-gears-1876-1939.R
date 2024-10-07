# Load
library(googlesheets4)

# Path -------------------------------------------------------------------------

g1 <- c("1_W67uz3s4W1zDE8nCbugVJjCDBvesHSOrsMmuU2V7oM")
g2 <- c("1bvItr120v3O2NFkFelJr5MpUgRbHNoA8823ttSkO_m4")

# Read data --------------------------------------------------------------------

# All gears 1876-1934 annual landings (tonnes)
# Ketchen (1986) Tables 3 and 4
gs4_deauth()
d1 <- read_sheet(g1, skip = 1)
d2 <- read_sheet(g2, skip = 1)
# Assemble
d <- dplyr::bind_rows(d1, d2) 

# Write data -------------------------------------------------------------------

saveRDS(d, "data/raw/catch-commercial-landings-all-gears-1876-1939.rds")
