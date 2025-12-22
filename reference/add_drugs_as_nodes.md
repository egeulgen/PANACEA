# Add Drugs as Nodes

Add Drugs as Nodes

## Usage

``` r
add_drugs_as_nodes(W_mat, drug_target_interactions, edge_weight = 1000)
```

## Arguments

- W_mat:

  adjacency matrix for the chosen PIN

- drug_target_interactions:

  data frame containing (processed) drugs and target genes

- edge_weight:

  edge weight for drug-target gene interaction (default = 1000)

## Value

adjacency matrix with the drugs added as nodes
