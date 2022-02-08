driveR_res <- driveR::prioritize_driver_genes(driveR::example_features_table, "LUAD")
W_mat <- PANACEA:::adj_list2mat(STRING_adj_df)

test_that("distance-based scoring works", {
    expect_type(res <- score_drugs_distance_based(driveR_res = driveR_res,
                                                  drug_interactions_df = DGIdb_interactions_df,
                                                  W_mat = W_mat),
                "double")
})

test_check("NA returned if no genes pass threshold") {
    driveR_res2 <- driveR_res
    driveR_res2$driverness_prob <- 0.02
    expect_warning(res <- score_drugs_distance_based(driveR_res = driveR_res2,
                                                     drug_interactions_df = DGIdb_interactions_df,
                                                     W_mat = W_mat),
                   "No genes pass the 'driver_prob_cutoff'")
    expect_identical(res, NA)
}
