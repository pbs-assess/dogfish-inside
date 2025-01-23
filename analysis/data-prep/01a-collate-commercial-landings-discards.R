library(readr)
library(here)


# commercial trawl landings 1966-2008 ------------------------------
# From https://github.com/pbs-assess/dogfish-assess/
p <- paste0(here(), "/data/raw")

# Trawl 1966-2008 annual landings (tonnes)
# Gallucci et al. (2011) ResDoc 2011/034 Table 4
f <- c("catches-trawl-1966-2008.csv")
d <- read_csv(file.path(p, f), skip = 2, show_col_types = FALSE)
saveRDS(d, "data/raw/catch-commercial-landings-trawl-1966-2008.rds")


# commerical landings longline 1966-2008 --------------------------------------
# From https://github.com/pbs-assess/dogfish-assess/
p <- paste0(here(), "/data/raw")
# Longline 1966-2008 annual landings (tonnes)
# Gallucci et al. (2011) ResDoc 2011/034 Table 3
f <- c("catches-longline-1966-2008.csv")
d <- read_csv(file.path(p, f), skip = 2, show_col_types = FALSE)
saveRDS(d, "data/raw/catch-commercial-landings-longline-1966-2008.rds")


# commercial landings all gears 1935-1965 ---------------------------------
# From https://github.com/pbs-assess/dogfish-assess/
p <- paste0(here(), "/data/raw")
# All gears 1935-1965 annual landings (tonnes)
# Gallucci et al. (2011) ResDoc 2011/034 Table 2
f <- c("catches-all-gears-1935-1965.csv")
d <- read_csv(file.path(p, f), skip = 2, show_col_types = FALSE)
saveRDS(d, "data/raw/catch-commercial-landings-all-gears-1935-1965.rds")


# commercial landings all gear 1876-1939 ----------------------------------
library(googlesheets4)
g1 <- c("1_W67uz3s4W1zDE8nCbugVJjCDBvesHSOrsMmuU2V7oM")
g2 <- c("1bvItr120v3O2NFkFelJr5MpUgRbHNoA8823ttSkO_m4")
# All gears 1876-1934 annual landings (tonnes)
# Ketchen (1986) Tables 3 and 4
gs4_deauth()
d1 <- read_sheet(g1, skip = 1)
d2 <- read_sheet(g2, skip = 1)
# Assemble
d <- dplyr::bind_rows(d1, d2) 
saveRDS(d, "data/raw/catch-commercial-landings-all-gears-1876-1939.rds")


# commercial discards trawl 1966-2008 -------------------------------------
# From https://github.com/pbs-assess/dogfish-assess/
p <- paste0(here(), "/data/raw/")
# Trawl discards 1966-2008 annual discards (tonnes)
# Gallucci et al. (2011) ResDoc 2011/034 Table 6
f <- c("discards-trawl-1966-2008.csv")
d <- read_csv(file.path(p, f), skip = 2, show_col_types = FALSE)
saveRDS(d, "data/raw/catch-commercial-discards-trawl-1966-2008.rds")


# commercial discards longline 2001-2006 ----------------------------------
# From https://github.com/pbs-assess/dogfish-assess/
p <- paste0(here(), "/data/raw/")
# Longline discards 2001-2006 annual discards (tonnes)
# Gallucci et al. (2011) ResDoc 2011/034 Table 5
f <- c("discards-longline-2001-2006.csv")
d <- read_csv(file.path(p, f), skip = 2, show_col_types = FALSE)
saveRDS(d, "data/raw/catch-commercial-discards-longline-2001-2006.rds")


