# Load
library(readr)

# Path -------------------------------------------------------------------------

# From https://github.com/pbs-assess/dogfish-assess/
p <- file.path(dirname(getwd()), "dogfish-assess/data/raw/")

# Read data --------------------------------------------------------------------

# All gears 1935-1965 annual landings (tonnes)
# Gallucci et al. (2011) ResDoc 2011/034 Table 2

# File name
f <- c("catches-all-gears-1935-1965.csv")
# Data
d <- read_csv(file.path(p, f), skip = 2, show_col_types = FALSE)

# Write data -------------------------------------------------------------------

saveRDS(d, "data/raw/catch-commercial-landings-all-gears-1935-1965.rds")
