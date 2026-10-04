# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Reproducible result inventory and transparent limitations
out <- lab_output("Lab14_Consolidation")
files <- list.files(root,pattern="\\.png$",recursive=TRUE,full.names=FALSE)
files <- files[grepl("^Lab",files)]
csv(data.frame(figure=files),file.path(out,"figure_inventory.csv"))
tests <- c("Lab07_OneSample_Tests/output/tests.csv","Lab08_TwoSample_Tests/output/tests.csv",
 "Lab09_Paired_TTest/output/independent_test.csv","Lab09_Paired_TTest/output/paired_test.csv",
 "Lab10_ChiSquare_Tests/output/tests.csv")
combined <- do.call(rbind,lapply(tests,function(f) read.csv(file.path(root,f))))
csv(combined,file.path(root,"report","consolidated_tests.csv"))
log_text(file.path(out,"lab14_review.txt"),{
 cat("PRIMARY DATA: validated 3000-person random sample; valid BMI extremes retained.\n")
 cat("SENSITIVITY: separate BMI-IQR-filtered sample.\n")
 cat("Ordinary unweighted tests illustrate syllabus methods. The processed survey omits complex-design weights.\n")
 cat("Self-report, historical 2015 data, observational confounding, class imbalance and multiple tests limit conclusions.\n")
 cat("Hypothetical benchmarks demonstrate calculation. Non-significance does not prove equality or model truth.\n")
 cat("Separate experimental supplements support design concepts, not health conclusions.\n")
 print(combined); print(sessionInfo())
})
