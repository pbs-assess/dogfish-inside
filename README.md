
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
      gfcatch-lingcod-4b.R(["gfcatch-lingcod-4b.R"])
      tba.R(["tba.R"])
    end
    subgraph data/
      gfcatch_lingcod_4b.rda
      TBA.rda
    end
  end
  data/-->_targets.R
  GFCatch---gfcatch-lingcod-4b.R-->gfcatch_lingcod_4b.rda
  TBA.csv---tba.R-->TBA.rda
```
