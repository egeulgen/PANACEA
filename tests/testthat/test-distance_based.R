test_that("`score_drugs_distance_based()` works as expected", {
  skip_on_cran()
  W_mat <- PANACEA:::adj_list2mat(STRING_adj_df[STRING_adj_df$combined_score > 995, ])
  selected_drugs <- unique(DGIdb_interactions_df$drug_name)[1:20]
  sel_interactions_df <- DGIdb_interactions_df[DGIdb_interactions_df$drug_name %in% selected_drugs, ]
  expect_type(
    score_drugs_distance_based(
      driveR_res = example_driveR_res,
      drug_interactions_df = sel_interactions_df,
      W_mat = W_mat
    ),
    "double"
  )

  ## NA returned if no genes pass threshold
  driveR_res2 <- example_driveR_res
  driveR_res2$driverness_prob <- 0.02
  expect_warning(
    res <- score_drugs_distance_based(
      driveR_res = driveR_res2,
      drug_interactions_df = DGIdb_interactions_df,
      W_mat = W_mat
    ),
    "No genes pass the 'driver_prob_cutoff'"
  )
  expect_identical(res, NA)
})
