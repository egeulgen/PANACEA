#' Add Drugs as Nodes
#'
#' @param W_mat adjacency matrix for the chosen PIN
#' @param drug_target_interactions data frame containing (processed) drugs and target genes
#' @param edge_weight edge weight for drug-target gene interaction (default = 1000)
#'
#' @return adjacency matrix with the drugs added as nodes
add_drugs_as_nodes <- function(W_mat, drug_target_interactions, edge_weight = 1000) {
  all_drugs <- unique(drug_target_interactions$drug_name)

  # add drugs to rows
  tmp <- matrix(0, nrow = length(all_drugs), ncol = ncol(W_mat), dimnames = list(all_drugs, colnames(W_mat)))
  W_mat <- rbind(W_mat, tmp)

  # add drugs to columns
  tmp <- matrix(0, nrow = nrow(W_mat), ncol = length(all_drugs), dimnames = list(rownames(W_mat), all_drugs))
  W_mat <- cbind(W_mat, tmp)

  # add edge weights
  for (drug in all_drugs) {
    tmp <- drug_target_interactions$converted_target_gene[drug_target_interactions$drug_name == drug]
    i <- match(tmp, rownames(W_mat))
    j <- which(colnames(W_mat) == drug)
    W_mat[i, j] <- W_mat[j, i] <- edge_weight
  }

  return(W_mat)
}

#' Convert Input Gene Symbols to Alias
#'
#' @param input_genes vector of input genes
#' @param target_genes vector of target genes
#'
#' @return vector of converted gene symbols (if any alias in target genes)
convert2alias <- function(input_genes, target_genes) {
  missing_genes <- input_genes[!input_genes %in% target_genes]
  nonmissing_genes <- input_genes[input_genes %in% target_genes]

  ## use SQL to get alias table and gene_info table (contains the symbols)
  ## first open the database connection
  db_con <- org.Hs.eg.db::org.Hs.eg_dbconn()
  ## the SQL query
  sql_query <- "SELECT * FROM alias, gene_info WHERE alias._id == gene_info._id;"
  ## execute the query on the database
  hsa_alias_df <- DBI::dbGetQuery(db_con, sql_query)

  select_alias <- function(result, converted_syms) {
    idx <- length(result)
    while (idx > 0) {
      if (!result[idx] %in% c(converted_syms, nonmissing_genes)) {
        return(result[idx])
      }
      idx <- idx - 1
    }
    return("NOT_FOUND")
  }

  ## loop for getting all symbols
  converted <- c()
  for (missing in missing_genes) {
    result <- hsa_alias_df[
      hsa_alias_df$alias_symbol == missing,
      c("alias_symbol", "symbol")
    ]
    result <- hsa_alias_df[
      hsa_alias_df$symbol %in% result$symbol,
      c("alias_symbol", "symbol")
    ]
    result <- result$alias_symbol[result$alias_symbol %in% target_genes]
    ## avoid duplicate entries
    to_add <- select_alias(result, converted[, 2])
    converted <- rbind(converted, c(missing, to_add))
  }

  ## Convert to appropriate symbol
  res_genes <- input_genes
  res_genes[match(converted[, 1], res_genes)] <- converted[, 2]

  return(res_genes)
}

#' Network Propagation (Random-walk with Restart)
#'
#' @param prior_vec vector of prior knowledge on selected genes (names are gene symbols)
#' @param W_prime (Laplacian-normalized, symmetric) adjacency matrix
#' @param alpha restart parameter, controlling trade-off between prior information and network smoothing
#' @param max.iter maximum allowed number of iterations (default = 1000)
#' @param eps epsilon value to assess the L2 norm of the difference between iterations (default = 1e-4)
#'
#' @details Implementing RWR following the following publications:
#'  Cowen L, Ideker T, Raphael BJ, Sharan R. Network propagation: a universal amplifier of genetic associations. Nat Rev Genet. 2017 Sep;18(9):551–62.
#'  Shnaps O, Perry E, Silverbush D, Sharan R. Inference of personalized drug targets via network propagation. Pac Symp Biocomput. 2016;21:156–67.
#' @return vector of propagation values
network_propagation <- function(prior_vec, W_prime, alpha, max.iter = 1000, eps = 1e-4) {
  ### all node symbols
  all_nodes <- rownames(W_prime)

  ### map initial values onto all nodes
  # convert missing symbols to aliases in the PIN
  converted <- convert2alias(names(prior_vec), all_nodes)
  names(prior_vec) <- converted
  prior_vec <- prior_vec[names(prior_vec) != "NOT_FOUND"]

  ### prior Knowledge
  Y <- prior_vec[match(all_nodes, names(prior_vec))]
  Y[is.na(Y)] <- 0
  names(Y) <- all_nodes

  ### L2 norm
  L2_norm <- function(x) sqrt(sum(x^2))

  ### Iterative propagation
  current_F <- Y
  for (t in seq_len(max.iter)) {
    previous_F <- current_F
    current_F <- (1 - alpha) * as.vector(previous_F %*% W_prime) + alpha * Y
    if (L2_norm(current_F - previous_F) < eps) {
      break
    }
  }

  return(list(p = current_F, n.iter = t))
}

#' Process Drug-Target Interactions
#'
#' @param drug_target_interactions data frame containing drugs and target genes
#' @param PIN_genes gene symbols for the chosen PIN
#' @param drug_name_col name of the column containing drug names (default = "drug_name")
#' @param target_col name of the column containing drug targets (default = "converted_target_gene")
#'
#' @return processed drug-target interactions. Processing involves converting
#' symbols missing in the PIN, merging drugs that have the same target gene(s)
process_drug_target_interactions <- function(drug_target_interactions, PIN_genes,
                                             drug_name_col = "drug_name", target_col = "gene_name") {
  ### Select and rename necessary columns
  drug_target_interactions <- drug_target_interactions[, c(drug_name_col, target_col)]
  colnames(drug_target_interactions) <- c("drug_name", "gene_name")

  ### Convert to alias symbols within PIN, effectively removing drugs with no target genes within the PIN
  tmp <- unique(drug_target_interactions$gene_name)
  converted <- convert2alias(tmp, PIN_genes)
  names(converted) <- tmp
  drug_target_interactions$converted_target_gene <- converted[match(drug_target_interactions$gene_name, names(converted))]
  drug_target_interactions <- drug_target_interactions[drug_target_interactions$converted_target_gene != "NOT_FOUND", ]

  all_drugs <- unique(drug_target_interactions$drug_name)

  ### Group drugs that target the same gene(s) together
  drug_target_list <- list()
  simple_drug_df <- c()
  for (drug in all_drugs) {
    tmp <- sort(unique(drug_target_interactions$converted_target_gene[drug_target_interactions$drug_name == drug]))
    simple_drug_df <- rbind(simple_drug_df, data.frame(
      drug = drug,
      genes = paste(tmp, collapse = ";")
    ))
  }

  counts <- table(simple_drug_df$genes)
  counts <- counts[counts != 1]
  duplicated_targets <- names(counts)

  for (target_txt in duplicated_targets) {
    to_merge <- simple_drug_df$drug[simple_drug_df$genes == target_txt]
    drug_target_interactions$drug_name[drug_target_interactions$drug_name %in% to_merge] <- paste(to_merge, collapse = ";")
  }

  drug_target_interactions <- unique(drug_target_interactions)
  return(drug_target_interactions)
}

#' Turn Adjacency List into Adjacency Matrix
#'
#' @param adj_list Adjacency list
#'
#' @return Adjacency matrix
adj_list2mat <- function(adj_list) {
  ### add reverse interactions (so that the edge-weights matrix is symmetric)
  tmp <- adj_list[, c(2, 1, 3)]
  colnames(tmp) <- c("protein1", "protein2", "combined_score")
  adj_list <- rbind(adj_list, tmp)
  adj_list <- unique(adj_list)

  ### Create adjacency matrix
  W_mat <- reshape2::acast(adj_list, protein1 ~ protein2, value.var = "combined_score")
  W_mat[is.na(W_mat)] <- 0

  return(W_mat)
}
