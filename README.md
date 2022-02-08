
<!-- README.md is generated from README.Rmd. Please edit that file -->

# PANACEA: Personalized Network-based Anti-Cancer Therapy Evaluation

<!-- badges: start -->

[![R-CMD-check](https://github.com/egeulgen/PANACEA/workflows/R-CMD-check/badge.svg)](https://github.com/egeulgen/PANACEA/actions)
[![Lifecycle:experimental](https://lifecycle.r-lib.org/articles/figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![License:MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

Identification of the most appropriate pharmacotherapy for each patient
based on genomic events is a major challenge in personalized oncology.
`PANACEA` is a collection of personalized anti-cancer drug
prioritization approaches utilizing network methods. The methods utilize
personalized “driverness” scores from
[`driveR`](https://github.com/egeulgen/driveR) to rank drugs, mapping
these onto a protein-protein interaction network. The “distance-based”
method scores each drug based on these scores an distances between drugs
and genes to rank given drugs. The “RWR” method propagates these scores
via a random-walk with restart framework to rank the drugs.

## Installation

You can install the development version of PANACEA from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("egeulgen/PANACEA")
```

## Usage

The wrapper function `score_drugs()` can be used to score and rank drugs
for an individual tumor sample via the ‘distance-based’ or ‘RWR’ method.
The required inputs are:

-   `driveR_res`: data frame of
    `[driveR](https://egeulgen.github.io/driveR/)` results
-   `drug_interactions_df`: data frame of drug-gene interactions
    (defaults to interactions from DGIdb expert-curated sources)
-   `W_mat`: (symmetric) adjacency matrix for the protein interaction
    network (defaults to STRING v11.5 interactions with combined score >
    .4)
-   `method`: scoring method (one of ‘distance-based’ or ‘RWR’)
