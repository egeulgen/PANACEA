#' RWR-based Scoring of Drugs
#'
#' @inheritParams score_drugs_distance_based
#' @inheritParams network_propagation
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
#' res <- score_drugs_RWR_based(
#'   driveR_res = toy_data,
#'   drug_interactions_df = toy_interactions,
#'   W_mat = toy_W_mat, verbose = FALSE
#' )
score_drugs_RWR_based <- function(driveR_res, drug_interactions_df, W_mat,
                                  alpha = 0.05,
                                  max.iter = 1000,
                                  eps = 1e-4,
                                  drug_name_col = "drug_name",
                                  target_col = "gene_name",
                                  verbose = TRUE) {
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

  ### process adj. mat.
  if (verbose) {
    cat("Processing adjacency matrix\n")
  }
  W_mat <- add_drugs_as_nodes(W_mat, processed_interactions_df)
  W_prime <- Laplacian.norm(W_mat)

  ### driveR results
  driver_vec <- driveR_res$driverness_prob
  names(driver_vec) <- driveR_res$gene_symbol

  ### RWR
  if (verbose) {
    cat("RWR step\n")
  }
  driver_propagated <- network_propagation(driver_vec, W_prime,
    alpha = alpha,
    max.iter = max.iter, eps = eps
  )

  all_drug_scores <- driver_propagated$p[all_drugs]
  return(all_drug_scores)
}
