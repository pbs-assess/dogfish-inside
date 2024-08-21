library(readr)

# Path -------------------------------------------------------------------------

# From https://github.com/pbs-assess/dogfish-assess/
p <- file.path(dirname(getwd()), "dogfish-assess/data/raw/")

# Read data --------------------------------------------------------------------

# Trawl discards 1966-2008 annual discards (tonnes)
# Gallucci et al. (2011) ResDoc 2011/034 Table 6

# File name
f <- c("discards-trawl-1966-2008.csv")
# Data
d <- read_csv(file.path(p, f), skip = 2, show_col_types = FALSE)

# Write data -------------------------------------------------------------------

saveRDS(d, "data/raw/catch-commercial-discards-trawl-1966-2008.rds")
