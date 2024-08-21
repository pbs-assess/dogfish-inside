library(readr)

# Path -------------------------------------------------------------------------

# From https://github.com/pbs-assess/dogfish-assess/
p <- file.path(dirname(getwd()), "dogfish-assess/data/raw/")

# Read data --------------------------------------------------------------------

# Longline 1966-2008 annual landings (tonnes)
# Gallucci et al. (2011) ResDoc 2011/034 Table 3

# File name
f <- c("catches-longline-1966-2008.csv")
# Data
d <- read_csv(file.path(p, f), skip = 2, show_col_types = FALSE)

# Write data -------------------------------------------------------------------

saveRDS(d, "data/raw/catch-commercial-landings-longline-1966-2008.rds")
