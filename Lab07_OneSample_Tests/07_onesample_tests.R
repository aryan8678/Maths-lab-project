# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Experiment 7: hypothetical classroom benchmarks, not sourced population claims
out <- lab_output("Lab07_OneSample_Tests"); df <- load_clean()
t <- t.test(df$BMI,mu=27)
p <- prop.test(sum(df$Diabetes_binary=="Yes"),nrow(df),p=.11)
rows <- rbind(test_row("One sample BMI",t,mean(df$BMI),nrow(df),"BMI kg/m^2","H0 mean BMI = 27", "27 is a hypothetical classroom benchmark"),
 test_row("One sample positive proportion",p,mean(df$Diabetes_binary=="Yes"),nrow(df),"Proportion","H0 combined positive proportion = 0.11","11% is hypothetical; outcome includes prediabetes"))
csv(rows,file.path(out,"tests.csv"))
log_text(file.path(out,"lab07_onesample_tests.txt"),{
 cat("Two-sided alternatives, alpha .05. Both benchmarks are hypothetical teaching values.\n")
 print(t); print(p); cat("prop.test reports X-squared, not a z statistic.\n")
})
