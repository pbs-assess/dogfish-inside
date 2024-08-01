
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Inside Dogfish Stock Assessment for British Columbia

## Install dependencies

### GitHub R packages

``` r
# install.packages("remotes")
remotes::install_github("pbs-assess/gfdata")
remotes::install_github("pbs-assess/gfplot")
remotes::install_github("r4ss/r4ss")
remotes::install_github("Cole-Monnahan-NOAA/adnuts")
remotes::install_github("PIFSCstockassessments/ss3diags")
```

### Stock Synthesis 3.30

- Download the latest release of [Stock Synthesis
  3.30](https://github.com/nmfs-ost/ss3-source-code?tab=readme-ov-file)
- Confirm that the ss3 executable is available in the R `$PATH`, for
  example using `r4ss::check_exe()`
