# Process Drug-Target Interactions

Process Drug-Target Interactions

## Usage

``` r
process_drug_target_interactions(
  drug_target_interactions,
  PIN_genes,
  drug_name_col = "drug_name",
  target_col = "gene_name"
)
```

## Arguments

- drug_target_interactions:

  data frame containing drugs and target genes

- PIN_genes:

  gene symbols for the chosen PIN

- drug_name_col:

  name of the column containing drug names (default = "drug_name")

- target_col:

  name of the column containing drug targets (default =
  "converted_target_gene")

## Value

processed drug-target interactions. Processing involves converting
symbols missing in the PIN, merging drugs that have the same target
gene(s)
