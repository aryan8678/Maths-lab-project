# Run: Rscript run_all.R    (or source("run_all.R") in RStudio)
# Run from the project root. All lab scripts can also run from their own folder.
scripts <- c("Lab00_Setup/00_setup.R", "Lab01_Data_Types/01_data_types.R",
 "Lab01B_Outlier_Analysis/01b_outlier_analysis.R", "Lab02_Summary_Stats/02_summary_stats.R",
 "Lab03_Correlation_Regression/03_correlation_regression.R", "Lab04_Multiple_Regression/04_multiple_regression.R",
 "Lab05_Binomial_Fitting/05_binomial_fitting.R", "Lab06_Normal_Poisson_Fitting/06_normal_poisson_fitting.R",
 "Lab07_OneSample_Tests/07_onesample_tests.R", "Lab08_TwoSample_Tests/08_twosample_tests.R",
 "Lab09_Paired_TTest/09_independent_ttest.R", "Lab09_Paired_TTest/09b_paired_ttest.R",
 "Lab10_ChiSquare_Tests/10_chisquare_tests.R", "Lab11_ANOVA_CRD/11_anova_crd.R",
 "Lab12_ANOVA_RBD/12_anova_rbd.R", "Lab13_Latin_Square/13_latin_square.R",
 "Lab14_Consolidation/14_consolidation.R")
dir.create("report", showWarnings = FALSE)
run_log <- file("report/execution_log.txt", "wt")
sink(run_log, split = TRUE)
tryCatch({
 for (script in scripts) {
   cat("\nRUNNING", script, "\n")
   source(script, local = new.env(parent = globalenv()))
   cat("COMPLETED", script, "\n")
 }
 cat("\nAll course exercises completed.\n")
 print(sessionInfo())
}, finally = {sink(); close(run_log)})
