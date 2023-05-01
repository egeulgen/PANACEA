test_that("`score_drugs()` funcion works as expected", {
  skip_on_cran()
  toy_data <- data.frame(
    gene_symbol = c("TP53", "EGFR", "KDR", "ATM"),
    driverness_prob = c(0.94, 0.92, 0.84, 0.72)
  )
  toy_interactions <- DGIdb_interactions_df[1:100, ]

  expect_type(
    score_drugs(
      driveR_res = toy_data,
      drug_interactions_df = toy_interactions,
      W_mat = toy_W_mat,
      method = "distance-based"
    ),
    "double"
  )
  expect_type(
    score_drugs(
      driveR_res = toy_data,
      drug_interactions_df = toy_interactions,
      W_mat = toy_W_mat,
      alpha = 0.8,
      method = "RWR",
      max.iter = 100
    ),
    "double"
  )

  # invalid method and check for defaults
  expect_error(score_drugs(
    driveR_res = toy_data,
    method = "INVALID"
  ))
})
