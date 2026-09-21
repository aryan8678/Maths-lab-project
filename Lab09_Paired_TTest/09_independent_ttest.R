# Lab 9 - t-test: Independent & Paired Samples
# Syllabus Exp. 9
#
# NOTE ON SCOPE: this project is being built through Phase 1 (BRFSS-only)
# for now. The paired-samples half of Exp. 9 requires MASS::anorexia,
# which the implementation plan explicitly assigns to Phase 2 (it's the
# one genuine before/after paired dataset used specifically because the
# BRFSS survey is observational and has no paired samples). That half
# will be added here (script 09b) when Phase 2 is built.
#
# Input: data/brfss_clean.csv

df <- read.csv("../data/brfss_clean.csv")
df$Sex <- factor(df$Sex, levels = c("Female", "Male"))

sink("output/lab09_independent_ttest.txt")
cat("=== Independent-samples t-test: PhysHlth by Sex ===\n")
print(t.test(PhysHlth ~ Sex, data = df))
sink()

cat("Lab 9 (independent-samples part) done. See output/lab09_independent_ttest.txt\n")
cat("Paired-samples part (anorexia data) deferred to Phase 2.\n")
