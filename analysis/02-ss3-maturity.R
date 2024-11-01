# Load
library(dplyr)
library(gfplot)
library(ggplot2)
library(santoku)
library(tibble)
# Theme set
ggplot2::theme_set(gfplot::theme_pbs())

# Adapted from:
# - https://github.com/pbs-assess/dogfish-assess/

# Generate maturity ------------------------------------------------------------

# Taylor and Gallucci (2009)
create_maturity_at_age <- function (x, x50, delta) {
  1/(1 + exp(-log(19) * (x - x50) / delta))
}

# Taylor and Gallucci (2009) estimates for 2000s (Table 1)
# Age at 50% maturity
x50 <- 31.5
# Age at 90% maturity minus age at 50% maturity
delta <- 24.3
# Maturity
ages <- 0:70
d <- ifelse(ages < 18, 0, create_maturity_at_age(ages, x50, delta)) |>
  as.matrix() |> t() |>  round(3) |>
  magrittr::set_colnames(paste0("Age_", ages)) |>
  magrittr::set_rownames("Age_Maturity1") |>
  as.data.frame()
 
# Write ------------------------------------------------------------------------

saveRDS(d, file = "data/ss3/maturity.rds")

# Plot -------------------------------------------------------------------------

# ggplot(d, aes(x = age, y = mat)) +
#   geom_point()
