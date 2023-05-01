#' DGIdb Interactions Expert-curated Sources
#'
#' Data frame containing drug-gene interactions from expert-curated sources
#' (CancerCommons, CGI, ChemblInteractions, CIViC, ClearityFoundationBiomarkers,
#' ClearityFoundationClinicalTrial, COSMIC, DoCM, MyCancerGenome,
#' MyCancerGenomeClinicalTrial, TALC, TdgClinicalTrial, TEND)
#' from DGIdb.
#'
#' @format a data frame containing 11323 rows and 2 variables:
#' \describe{
#'   \item{drug_name}{Drug name}
#'   \item{gene_name}{HGNC gene symbol for the interacting gene}
#' }
"DGIdb_interactions_df"

#' Adjacency List for STRING v11.5 - High Confidence Interactions
#'
#' Data frame of adjacency list for STRING v11.5 interactions with combined
#' score > 700 (high confidence)
#'
#' @format a data frame with 887797 rows and 3 variables:
#' \describe{
#'   \item{protein1}{Interactor 1}
#'   \item{protein2}{Interactor 2}
#'   \item{value}{edge weight(combined score)}
#' }
"STRING_adj_df"

#' Toy Adjacency Matrix (for examples)
#'
#' Symmetric matrix containing example adjacency data
#'
#' @format matrix of 84 rows and 84 columns
"toy_W_mat"

#' Example driveR Result
#'
#' Data frame containing 'driveR' results for a lung adenocarcinoma case.
#' @format a data frame containing 106 rows and 3 variables:
#' \describe{
#'   \item{gene_symbol}{HGNC gene symbol}
#'   \item{driverness_prob}{'driverness' probability}
#'   \item{prediction}{driveR's prediction for whether the gene is a 'driver' or 'non-driver'}
#' }
"example_driveR_res"


#' Example PANACEA "distance-based" Method Result
#'
#' Vector containing 'PANACEA' "distance-based" results for a lung adenocarcinoma case.
#' Names are drug names, values are scores
#' @format named vector of 1423 values
"example_scores_dist"

#' Example PANACEA "RWR" Method Result
#'
#' Vector containing 'PANACEA' "RWR" results for a lung adenocarcinoma case.
#' Names are drug names, values are scores
#' @format named vector of 1423 values
"example_scores_RWR"
