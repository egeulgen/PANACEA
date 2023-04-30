#' @useDynLib PANACEA, .registration = TRUE
NULL

#' Graph Laplacian Normalization
#'
#' @param W square symmetric adjacency matrix
#'
#' @return normalized adjacency matrix
#' @export
Laplacian.norm <- function(W) {
  # computing D^(-1/2) * W * D^(-1/2)
  n <- nrow(W)
  name.examples <- rownames(W)
  diag.D <- apply(W, 1, sum)
  diag.D[diag.D == 0] <- Inf
  inv.sqrt.diag.D <- 1 / sqrt(diag.D)
  W <- .C("norm_lapl_graph", as.double(W), as.double(inv.sqrt.diag.D), as.integer(n), PACKAGE = "PANACEA")[[1]]
  W <- matrix(W, nrow = n)
  rownames(W) <- colnames(W) <- name.examples
  return(W)
}
