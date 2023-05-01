test_that("`score_drugs_RWR_based()` works as expected", {
  skip_on_cran()
  W_mat <- PANACEA:::adj_list2mat(STRING_adj_df[STRING_adj_df$combined_score > 995, ])
  selected_drugs <- unique(DGIdb_interactions_df$drug_name)[1:20]
  sel_interactions_df <- DGIdb_interactions_df[DGIdb_interactions_df$drug_name %in% selected_drugs, ]
  expect_type(
    score_drugs_RWR_based(
      driveR_res = example_driveR_res,
      drug_interactions_df = sel_interactions_df,
      W_mat = W_mat,
      max.iter = 100
    ),
    "double"
  )
})
