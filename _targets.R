# Load targets package
library(targets)
# Source scripts in R/
# source("R/functions.R")
# source("R/plot.R")
# source("R/utils.R")

# Set options
tar_option_set(
  # Set packages
  packages = c(
    "ggplot2",
    "ggraph",
    "magrittr",
    "tibble"
    )
)
options(tidyverse.quiet = TRUE)

# tar_make_clustermq() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
# options(clustermq.scheduler = "multicore")

# Source scripts in R/
tar_source(
  files = "R",
  envir = targets::tar_option_get("envir"),
  change_directory = FALSE
)

# List target objects
list(
  # Define stock synthesis path ------------------------------------------------
  list(
    tar_target(ss3_path, "~/ss3")
  ),
  # Define figure options ------------------------------------------------------
  list(
    tar_target(figure_path, "report/figs"),
    tar_target(figure_ext, ".png"),
    tar_target(figure_dpi, 300)
  ),
  list()
)
