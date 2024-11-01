
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Inside Dogfish Stock Assessment for British Columbia

## Install dependencies

### GitHub R packages

``` r
# install.packages("remotes")
remotes::install_github("pbs-assess/gfdata")
remotes::install_github("pbs-assess/gfplot")
remotes::install_github("luke-a-rogers/ssio")
remotes::install_github("r4ss/r4ss")
remotes::install_github("Cole-Monnahan-NOAA/adnuts")
remotes::install_github("PIFSCstockassessments/ss3diags")
```

### Stock Synthesis 3.30

- Download the latest release of [Stock Synthesis
  3.30](https://github.com/nmfs-ost/ss3-source-code?tab=readme-ov-file)
- Confirm that the ss3 executable is available in the R `$PATH`, for
  example using `r4ss::check_exe()`

## Fleets

Fleets are defined by a combination of `gear` type (e.g. “Hook and
line”) and `type` (e.g. “landings”). Because fleet definitions may
differ between models, data files for catch (catch.rds), indexes
(index.rds), and lengths (length.rds) are stored (in data/ss3/) with
`gear` and `type` columns, to allow the analyst to define fleets
specific to each model fit (typically in ss3/xxx/00-input-\*.R) using
the R package ssio (under development).

## Luke Todo

- [ ] Update R package ssio to assemble input data from stored data
- [ ] Update ss3/T00/ to fit test case model
- [ ] Remove dependence on R/ subfolder
