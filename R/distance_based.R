#' Distance-based Scoring of Drugs
#'
#' @param driveR_res data frame of driveR results
#' @param drug_interactions_df data frame of drug-gene interactions
#' @param W_mat adjacency matrix for the PIN
#' @param driver_prob_cutoff cut-off value for 'driverness_prob' (default = 0.05)
#' @param drug_name_col for 'drug_interactions_df', the column name containing drug names/identifiers
#' @param target_col for 'drug_interactions_df', the column name containing target gene symbols
#' @param verbose boolean to control verbosity (default = \code{TRUE})
#'
#' @return vector of scores per drug. Drugs with the same target gene(s) are merged
#' (via \code{\link{process_drug_target_interactions}})
#' @export
#'
#' @examples
#' toy_data <- data.frame(
#'   gene_symbol = c("TP53", "EGFR", "KDR", "ATM"),
#'   driverness_prob = c(0.94, 0.92, 0.84, 0.72)
#' )
#' toy_interactions <- DGIdb_interactions_df[1:100, ]
#' res <- score_drugs_distance_based(
#'   driveR_res = toy_data,
#'   drug_interactions_df = toy_interactions,
#'   W_mat = toy_W_mat, verbose = FALSE
#' )
score_drugs_distance_based <- function(driveR_res, drug_interactions_df, W_mat,
                                       driver_prob_cutoff = 0.05,
                                       drug_name_col = "drug_name",
                                       target_col = "gene_name",
                                       verbose = TRUE) {
  ### process PIN
  W_mat <- W_mat != 0
  PIN <- igraph::graph_from_adjacency_matrix(W_mat)

  ### process drug interactions
  if (verbose) {
    cat("Processing drug-gene interactions\n")
  }
  processed_interactions_df <- process_drug_target_interactions(
    drug_target_interactions = drug_interactions_df,
    PIN_genes = rownames(W_mat),
    drug_name_col = drug_name_col,
    target_col = target_col
  )

  all_drugs <- unique(processed_interactions_df$drug_name)

  ### process driveR results
  driveR_res <- driveR_res[driveR_res$driverness_prob > driver_prob_cutoff, ]

  driveR_res$gene_symbol <- convert2alias(driveR_res$gene_symbol, igraph::V(PIN)$name)
  driveR_res <- driveR_res[driveR_res$gene_symbol != "NOT_FOUND", ]

  ### calculate distances bw/ selected genes and target genes for all drugs
  selected_genes <- driveR_res$gene_symbol
  target_genes <- unique(processed_interactions_df$converted_target_gene)

  # return NA if no genes pass 'driver_prob_cutoff'
  if (length(selected_genes) == 0) {
    warning("No genes pass the 'driver_prob_cutoff'")
    return(NA)
  }

  if (verbose) {
    cat("Calculating distances\n")
  }

  dist_mat <- igraph::distances(
    graph = PIN,
    v = igraph::V(PIN)[selected_genes],
    to = igraph::V(PIN)[target_genes],
    algorithm = "unweighted"
  )

  ### score drugs
  if (verbose) {
    cat("Scoring drugs\n")
  }

  all_drug_scores <- c()
  for (drug in all_drugs) {
    if (verbose) {
      cat("Drug:", which(all_drugs == drug), "out of", length(all_drugs), "                               \r")
    }

    # determine the drug target genes
    drug_targets <- processed_interactions_df$converted_target_gene[processed_interactions_df$drug_name == drug]
    drug_targets <- intersect(drug_targets, colnames(dist_mat))

    # calculate minimum distance bw/ each selected gene and the drug
    dists <- apply(dist_mat[, drug_targets, drop = FALSE], 1, min) + 1

    # fetch driverness probabilities
    probs <- driveR_res$driverness_prob[match(names(dists), driveR_res$gene_symbol)]

    # calculate score
    scores <- probs / (dists + 1)^2 # d + 1 to reduce the effect from 1 (>>1) to 2 (>>4)

    all_drug_scores <- c(all_drug_scores, mean(scores))
  }
  if (verbose) {
    cat("\n\n")
  }
  names(all_drug_scores) <- all_drugs

  return(all_drug_scores)
}
