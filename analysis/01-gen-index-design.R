# Load
library(dplyr)
library(ggplot2)
library(tibble)
# Theme set
ggplot2::theme_set(gfplot::theme_pbs())
# Read raw data
d <- readRDS(here::here("data", "raw", "index-hbll-design.rds"))
# View
tibble::view(d)
# Plot
ggplot(d, aes(year, biomass)) +
  geom_point() +
  geom_line() +
  geom_ribbon(aes(ymin = lowerci, ymax = upperci), alpha = 0.4) +
  xlab('Year') + 
  ylab('Biomass estimate (kg)') +
  facet_wrap(vars(survey_abbrev))
# Save plot
save_plot("index-hbll-design", width = 190, height = 120)
# Write data
saveRDS(d, "data/generated/index-hbll-design.rds")
