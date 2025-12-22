# Scoring of Drugs via Network-based Methods

Scoring of Drugs via Network-based Methods

## Usage

``` r
score_drugs(driveR_res, drug_interactions_df, W_mat, method, ...)
```

## Arguments

- driveR_res:

  data frame of driveR results

- drug_interactions_df:

  data frame of drug-gene interactions

- W_mat:

  adjacency matrix for the PIN

- method:

  scoring method (one of 'distance-based' or 'RWR')

- ...:

  additional arguments for
  [`score_drugs_distance_based`](https://egeulgen.github.io/PANACEA/reference/score_drugs_distance_based.md)
  or
  [`score_drugs_RWR_based`](https://egeulgen.github.io/PANACEA/reference/score_drugs_RWR_based.md)

## Value

vector of scores per drug.

## Details

This is the wrapper function for the two proposed methods for
personalized scoring of drugs for individual cancer samples via
network-based methods. The available methods are 'distance-based' and
'RWR'. For the 'distance-based' method, the score between a gene (g) and
drug (d) is formulated as: \$\$score(g, d) = driver(g) / (d(g, d) +
1)^2\$\$ where driver(g) is the driverness probability of gene g, as
predicted by 'driveR' and d(g, d) is the distance withing the PIN
between gene g and drug d. The final score of the drug d is then the
average of the scores between each altered gene and d: \$\$score(d) =
\Sigma{score(g, d)} / \|genes\|\$\$

For the 'RWR' method, a random-walk with restart framework is used to
propagate the driverness probabilities.

By default
[`DGIdb_interactions_df`](https://egeulgen.github.io/PANACEA/reference/DGIdb_interactions_df.md)
is used as the `drug_interactions_df`.

If the `W_mat` argument is not supplied, the built-in STRNG data
[`STRING_adj_df`](https://egeulgen.github.io/PANACEA/reference/STRING_adj_df.md)
is used to generate `W_mat`.

## Examples

``` r
toy_data <- data.frame(
  gene_symbol = c("TP53", "EGFR", "KDR", "ATM"),
  driverness_prob = c(0.94, 0.92, 0.84, 0.72)
)
toy_interactions <- DGIdb_interactions_df[1:25, ]
res <- score_drugs(
  driveR_res = toy_data,
  drug_interactions_df = toy_interactions, # leave blank for default
  W_mat = toy_W_mat, # leave blank for default
  method = "distance-based",
  verbose = FALSE
)
#> 
```
