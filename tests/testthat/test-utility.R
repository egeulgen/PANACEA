test_that("`convert2alias()` works as expected", {
  expect_equal(
    PANACEA:::convert2alias(
      input_genes = c("IDH1", "ERK1", "NONGENE"),
      target_genes = c("IDH1", "MAPK3")
    ),
    c("IDH1", "MAPK3", "NOT_FOUND")
  )
})

test_that("`add_drugs_as_nodes()` works as expected", {
  tmp_W_mat <- matrix(400, nrow = 4, ncol = 4, dimnames = list(paste0("G", 1:4), paste0("G", 1:4)))
  tmp_interactions_df <- data.frame(
    drug_name = c("D1", "D1", "D2"),
    converted_target_gene = c("G1", "G3", "G2")
  )
  expect_true(isSymmetric(PANACEA:::add_drugs_as_nodes(tmp_W_mat, tmp_interactions_df)))
})

test_that("`network_propagation()` works as expected", {
  tmp_W_mat <- matrix(400, nrow = 4, ncol = 4, dimnames = list(paste0("G", 1:4), paste0("G", 1:4)))
  tmp_W_mat_prime <- Laplacian.norm(tmp_W_mat)
  expect_type(res <- PANACEA:::network_propagation(c(G1 = 1, G4 = 1), tmp_W_mat_prime, 0.8), "list")
  expect_equal(length(res$p), nrow(tmp_W_mat_prime))
})

test_that("`process_drug_target_interactions()` works as expected", {
  genes <- c("IDH1", "MAPK3", "TP53", "KRAS")
  tmp_interactions_df <- data.frame(
    drug_name = c("D1", "D1", "D2", "D3"),
    gene_name = c("ERK1", "TP53", "IDH1", "ERK1")
  )

  expect_type(res <- PANACEA:::process_drug_target_interactions(tmp_interactions_df, genes), "list")
  expect_equal(nrow(res), nrow(tmp_interactions_df))
})

test_that("`adj_list2mat()` works as expected", {
  adj_list <- STRING_adj_df[1:1e4, ]
  expect_true(isSymmetric.matrix(PANACEA:::adj_list2mat(adj_list)))
})
