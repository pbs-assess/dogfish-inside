
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Inside Dogfish Stock Assessment for British Columbia

## Install dependencies

### GitHub R packages

``` r
# install.packages("remotes")
remotes::install_github("r4ss/r4ss")
remotes::install_github("seananderson/ggsidekick")
remotes::install_github("PIFSCstockassessments/ss3diags")
```

### Stock Synthesis 3.0

Create a directory for the ss3 executable, for example using shell:

``` shell
cd ~
mkdir ss3
```

Download the latest release of [Stock Synthesis
3.0](https://github.com/nmfs-ost/ss3-source-code?tab=readme-ov-file),
for example using r4ss in RStudio:

``` r
r4ss::get_ss3_exe(dir = "~/ss3")
```

## Data

``` mermaid
flowchart LR
  subgraph dogfish-inside/
    _targets.R(["_targets.R"])
    subgraph data-raw/
      gfcatch-dogfish-4b.R(["gfcatch-dogfish-4b.R"])
      irec-dogfish-4b.R(["irec-dogfish-4b.R"])
      creel-dogfish-4b.R(["creel-dogfish-4b.R"])
      fsc-dogfish-4b.R(["fsc-dogfish-4b.R"])
      tba.R(["tba.R"])
    end
    subgraph data/
      gfcatch-dogfish-4b.rds
      irec-dogfish-4b.rds
      creel-dogfish-4b.rds
      fsc-dogfish-4b.rds
      tba.rds
    end
  end
  data/-->_targets.R
  GFCatch---gfcatch-dogfish-4b.R-->gfcatch-dogfish-4b.rds
  iREC---irec-dogfish-4b.R-->irec-dogfish-4b.rds
  Creel---creel-dogfish-4b.R-->creel-dogfish-4b.rds
  FSC---fsc-dogfish-4b.R-->fsc-dogfish-4b.rds
  TBA---tba.R-->tba.rds
```
