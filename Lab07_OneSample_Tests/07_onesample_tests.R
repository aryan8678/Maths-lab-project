# Lab 7 - Hypothesis Testing: One-Sample Mean & Proportion
# Syllabus Exp. 7
# Input: data/brfss_clean.csv

df <- read.csv("../data/brfss_clean.csv")
df$Diabetes_binary <- factor(df$Diabetes_binary, levels = c("No", "Yes"))

sink("output/lab07_onesample_tests.txt")

cat("=== One-sample t-test: H0: mean(BMI) = 27  vs  H1: mean(BMI) != 27 ===\n")
print(t.test(df$BMI, mu = 27))

cat("\n=== One-sample proportion test: H0: p(diabetes) = 0.11  vs  H1: p != 0.11 ===\n")
successes <- sum(df$Diabetes_binary == "Yes")
print(prop.test(x = successes, n = nrow(df), p = 0.11))

sink()

cat("Lab 7 done. See output/lab07_onesample_tests.txt\n")
