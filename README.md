
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="https://github.com/egeulgen/PANACEA/blob/master/inst/extdata/PANACEA_logo.png?raw=true" align="left" height="150/"/> PANACEA: Personalized Network-based Anti-Cancer Therapy Evaluation

<!-- badges: start -->

[![R-CMD-check](https://github.com/egeulgen/PANACEA/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/egeulgen/PANACEA/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/egeulgen/PANACEA/branch/master/graph/badge.svg)](https://app.codecov.io/gh/egeulgen/PANACEA?branch=master)
[![License:MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/license/mit/)
<!-- badges: end -->

Identification of the most appropriate pharmacotherapy for each patient
based on genomic alterations is a major challenge in personalized
oncology. `PANACEA` is a collection of personalized anti-cancer drug
prioritization approaches utilizing network methods. The methods utilize
personalized “driverness” scores from
[`driveR`](https://egeulgen.github.io/driveR/) to rank drugs, mapping
these onto a protein-protein interaction network. The “distance-based”
method scores each drug based on these scores and distances between
drugs and genes to rank given drugs. The “RWR” method propagates these
scores via a random-walk with restart framework to rank the drugs.

The method is described in detail in *Ulgen E, Ozisik O, Sezerman OU.
PANACEA: network-based methods for pharmacotherapy prioritization in
personalized oncology. Bioinformatics. 2023 Jan 1;39(1):btad022.
<https://doi.org/10.1093/bioinformatics/btad022>*

![PANACEA
workflow](https://github.com/egeulgen/PANACEA/blob/master/inst/extdata/workflow.png?raw=true "PANACEA workflow")

## Installation

You can install the latest release version of PANACEA from CRAN via:

``` r
install.packages("PANACEA")
```

You can install the development version of PANACEA from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("egeulgen/PANACEA", build_vignettes = TRUE)
```

## Usage

The wrapper function `score_drugs()` can be used to score and rank drugs
for an individual tumor sample via the “distance-based” or “RWR” method.
The required inputs are:

- `driveR_res`: data frame of
  [driveR](https://egeulgen.github.io/driveR/) results. Details on how
  to obtain `driveR` output are provided in [this
  vignette](https://egeulgen.github.io/driveR/articles/how_to_use.html)
- `drug_interactions_df`: data frame of drug-gene interactions (defaults
  to interactions from DGIdb expert-curated sources)
- `W_mat`: (symmetric) adjacency matrix for the protein interaction
  network (defaults to STRING v11.5 interactions with combined score \>
  .4)
- `method`: scoring method (one of “distance-based” or “RWR”)

## Example Usage

For detailed information on how to use `PANACEA`, please see the
vignette “How to use PANACEA” via `vignette("how_to_use")` or visit
[this link](https://egeulgen.github.io/PANACEA/articles/how_to_use.html)
