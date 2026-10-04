# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Experiment 9a: independent samples
out <- lab_output("Lab09_Paired_TTest"); df <- load_clean()
t <- t.test(PhysHlth~Sex,data=df)
csv(group_summary(df$PhysHlth,df$Sex),file.path(out,"phys_days_by_sex.csv"))
csv(test_row("Independent PhysHlth by sex",t,unname(t$estimate[1]-t$estimate[2]),nrow(df),"Female minus male days","H0 mean poor-health days equal"),file.path(out,"independent_test.csv"))
log_text(file.path(out,"lab09_independent_ttest.txt"),{print(t); cat("Independent respondents. Bounded skewed counts warrant cautious mean comparison.\n")})
