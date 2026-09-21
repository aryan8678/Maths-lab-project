# Lab 5 - Fitting the Binomial Distribution
# Syllabus Exp. 5
# Input: data/brfss_clean.csv

df <- read.csv("../data/brfss_clean.csv")
df$Diabetes_binary <- factor(df$Diabetes_binary, levels = c("No", "Yes"))

n_per_group <- 10
groups <- split(df$Diabetes_binary, ceiling(seq_along(df$Diabetes_binary) / n_per_group))
successes <- sapply(groups, function(g) sum(g == "Yes"))

p_hat <- mean(df$Diabetes_binary == "Yes")
observed <- table(factor(successes, levels = 0:n_per_group))
expected <- dbinom(0:n_per_group, n_per_group, p_hat) * length(groups)

png("output/binomial_observed_vs_expected.png", width = 700, height = 450)
barplot(rbind(observed, expected), beside = TRUE,
        col = c("steelblue", "orange"),
        names.arg = 0:n_per_group, xlab = "Successes per block of 10",
        main = "Binomial Fit: Diabetes_binary")
legend("topright", legend = c("Observed", "Expected"), fill = c("steelblue", "orange"))
dev.off()

sink("output/lab05_binomial_fitting.txt")
cat("p_hat (sample proportion with diabetes):", p_hat, "\n\n")
cat("=== Chi-square goodness-of-fit: Binomial(10, p_hat) ===\n")
print(chisq.test(observed, p = dbinom(0:n_per_group, n_per_group, p_hat), rescale.p = TRUE))
sink()

cat("Lab 5 done. See output/lab05_binomial_fitting.txt and binomial_observed_vs_expected.png\n")
