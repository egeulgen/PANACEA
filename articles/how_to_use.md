# How to use PANACEA

## Overview

Identification of the most appropriate pharmacotherapy for each patient
based on genomic alterations is a major challenge in personalized
oncology. `PANACEA` is a collection of personalized anti-cancer drug
prioritization approaches utilizing network methods. The methods utilize
personalized “driverness” scores from
[`driveR`](https://egeulgen.github.io/driveR/) to rank drugs, mapping
these onto a protein-protein interaction network (PIN). The
“distance-based” method scores each drug based on these scores and
distances between drugs and genes to rank given drugs. The “RWR” method
propagates these scores via a random-walk with restart framework to rank
the drugs.

The wrapper function
[`score_drugs()`](https://egeulgen.github.io/PANACEA/reference/score_drugs.md)
can be used to score and rank drugs for an individual tumor sample via
the “distance-based” or “RWR” method. The required inputs are:

- `driveR_res`: data frame of
  [driveR](https://egeulgen.github.io/driveR/) results. Details on how
  to obtain `driveR` output are provided in [this
  vignette](https://egeulgen.github.io/driveR/articles/how_to_use.html)
- `drug_interactions_df`: data frame of drug-gene interactions (defaults
  to interactions from DGIdb expert-curated sources)
- `W_mat`: (symmetric) adjacency matrix for the PIN (defaults to STRING
  v11.5 interactions with combined score \> .4)
- `method`: scoring method (one of “distance-based” or “RWR”)

``` r
library(PANACEA)
```

## Example Input

In this vignette, driveR results for a lung adenocarcinoma case,
`example_driveR_res`, is used as the example input dataset. Details on
how to obtain `driveR` output are provided in [this
vignette](https://egeulgen.github.io/driveR/articles/how_to_use.html).

``` r
head(example_driveR_res)
#>   gene_symbol driverness_prob prediction
#> 1       IFNA7      0.18945527 non-driver
#> 2        TJP1      0.13935021 non-driver
#> 3      IL20RA      0.09266710 non-driver
#> 4        SOST      0.08017132 non-driver
#> 5       NCOA2      0.06734062 non-driver
#> 6        ARAF      0.06232757 non-driver
```

## “Distance-based” Method

For this method, the score between a drug, d, and an altered gene, g, is
defined as:

$$score(g,d) = \frac{1}{\left( dist(g,d) + 1 \right)^{2}}driver\_ prob_{g}$$
where $dist(g,d)$ is the distance between g and d within the PIN, and
$driver\_ prob_{g}$ is the driverness probability obtained from
`driveR`.

The final score for a drug is calculated as the average of the scores
between each altered gene and d:

$$score(d) = \sum\limits_{g \in G}\frac{1}{|G|}score(g,d)$$ where G is
the set of all altered genes.

Scoring of drugs for the example lung adenocarcinoma case
`example_driveR_res` via this “distance-based” method can be performed
as follows:

``` r
example_scores_dist <- score_drugs(example_driveR_res, method = "distance-based")
```

This scores and ranks drugs via the “distance-based” method using
drug-gene interactions from DGIdb expert-curated sources and the STRING
v11.5 PIN with combined score \> 700. Below, top 10 drugs are printed:

``` r
head(example_scores_dist, 10)
#>    EVEROLIMUS PEMBROLIZUMAB     CISPLATIN     LETROZOLE     CETUXIMAB 
#>   0.009405251   0.008960906   0.008960906   0.008900282   0.008755715 
#>  BICALUTAMIDE     SORAFENIB   ENCORAFENIB   REGORAFENIB    TRAMETINIB 
#>   0.008755715   0.008523904   0.008523904   0.008523904   0.008523904
```

## “RWR” Method

For this method, a random-walk with restart framework is used to
propagate the driverness probabilities. A drug’s final score is its
final propagation score.

Scoring of drugs for the example lung adenocarcinoma case
`example_driveR_res` via this “RWR” method can be performed as follows:

``` r
example_scores_RWR <- score_drugs(example_driveR_res, method = "RWR")
```

This scores and ranks drugs via the “RWR” method using drug-gene
interactions from DGIdb expert-curated sources and the STRING v11.5 PIN
with combined score \> 700. Below, top 10 drugs are printed:

``` r
head(example_scores_RWR, 10)
#>               BLOSOZUMAB;ROMOSOZUMAB              TIAGABINE HYDROCHLORIDE 
#>                         0.0008476627                         0.0004770740 
#>                              KRN-330                            SERELAXIN 
#>                         0.0004326723                         0.0003804546 
#>                            TIAGABINE           LY-3009120;MLN-2480;XL-281 
#>                         0.0003554924                         0.0002520392 
#>                          OCRIPLASMIN                          ENCORAFENIB 
#>                         0.0002386693                         0.0002312123 
#> COLLAGENASE CLOSTRIDIUM HISTOLYTICUM                              COCAINE 
#>                         0.0002245975                         0.0002227435
```
