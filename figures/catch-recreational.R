# Load
library(ggplot2)

# Read -------------------------------------------------------------------------

d1 <- readRDS("data/generated/catch-recreational-creel.rds")
d2 <- readRDS("data/generated/catch-recreational-irec.rds")

# Prepare ----------------------------------------------------------------------

d <- dplyr::bind_rows(d1, d2)

# Plot -------------------------------------------------------------------------

ggplot(d, aes(x = year, y = catch_kpc, col = source)) +
  geom_line() +
  gfplot::theme_pbs()
