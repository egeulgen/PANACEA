#' Scoring of Drugs via Network-based Methods
#'
#' @inheritParams score_drugs_distance_based
#' @param method scoring method (one of 'distance-based' or 'RWR')
#' @param ... additional arguments for \code{\link{score_drugs_distance_based}} or
#' \code{\link{score_drugs_RWR_based}}
#'
#' @details This is the wrapper function for the two proposed methods for
#' personalized scoring of drugs for individual cancer samples via network-based
#' methods. The available methods are 'distance-based' and 'RWR'. For the
#' 'distance-based' method, the score between a gene (g) and drug (d) is formulated
#' as:
#' \deqn{score(g, d) = driver(g) / (d(g, d) + 1)^2}
#' where driver(g) is the driverness probability of gene g, as predicted by
#' 'driveR' and d(g, d) is the distance withing the PIN between gene g and drug d.
#' The final score of the drug d is then the average of the scores between each
#' altered gene and d:
#' \deqn{score(d) = \Sigma{score(g, d)} / |genes|}
#'
#' For the 'RWR' method, a random-walk with restart framework is used to propagate
#' the driverness probabilities.
#'
#' By default \code{\link{DGIdb_interactions_df}} is used as the
#' \code{drug_interactions_df}.
#'
#' If the \code{W_mat} argument is not supplied, the built-in STRNG data
#' \code{\link{STRING_adj_df}} is used to generate \code{W_mat}.
#'
#' @return vector of scores per drug.
#' @export
#'
#' @examples
#' toy_data <- data.frame(
#'   gene_symbol = c("TP53", "EGFR", "KDR", "ATM"),
#'   driverness_prob = c(0.94, 0.92, 0.84, 0.72)
#' )
#' toy_interactions <- DGIdb_interactions_df[1:25, ]
#' res <- score_drugs(
#'   driveR_res = toy_data,
#'   drug_interactions_df = toy_interactions, # leave blank for default
#'   W_mat = toy_W_mat, # leave blank for default
#'   method = "distance-based",
#'   verbose = FALSE
#' )
score_drugs <- function(driveR_res, drug_interactions_df, W_mat, method, ...) {
  if (missing(drug_interactions_df)) {
    drug_interactions_df <- DGIdb_interactions_df
  }

  if (missing(W_mat)) {
    W_mat <- adj_list2mat(adj_list = STRING_adj_df)
  }

  ### score drugs
  if (method == "distance-based") {
    all_drug_scores <- score_drugs_distance_based(
      driveR_res = driveR_res,
      drug_interactions_df = drug_interactions_df,
      W_mat = W_mat, ...
    )
  } else if (method == "RWR") {
    all_drug_scores <- score_drugs_RWR_based(
      driveR_res = driveR_res,
      drug_interactions_df = drug_interactions_df,
      W_mat = W_mat, ...
    )
  } else {
    stop("Method must be one of 'distance-based' or 'RWR'")
  }
  all_drug_scores <- sort(all_drug_scores, decreasing = TRUE)
  return(all_drug_scores)
}
