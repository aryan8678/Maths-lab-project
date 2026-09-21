# Lab 6 - Fitting Normal & Poisson Distributions
# Syllabus Exp. 6
# Input: data/brfss_clean.csv

df <- read.csv("../data/brfss_clean.csv")

## Normal check (BMI) --------------------------------------------------------
png("output/normal_bmi_hist.png", width = 600, height = 450)
hist(df$BMI, freq = FALSE, main = "BMI with Normal Curve", xlab = "BMI")
curve(dnorm(x, mean(df$BMI), sd(df$BMI)), add = TRUE, col = "red", lwd = 2)
dev.off()

png("output/normal_bmi_qq.png", width = 500, height = 500)
qqnorm(df$BMI); qqline(df$BMI, col = "red")
dev.off()

set.seed(101)
shapiro_bmi <- shapiro.test(sample(df$BMI, 500))   # Shapiro-Wilk needs n <= 5000

## Poisson fit (PhysHlth) -----------------------------------------------------
lambda_hat <- mean(df$PhysHlth)
obs_tab <- table(factor(df$PhysHlth, levels = 0:30))
exp_tab <- dpois(0:30, lambda_hat) * nrow(df)

png("output/poisson_physhlth.png", width = 800, height = 450)
barplot(rbind(obs_tab, exp_tab), beside = TRUE, col = c("steelblue", "orange"),
        main = "Poisson Fit: PhysHlth", xlab = "Days of poor physical health")
legend("topright", legend = c("Observed", "Expected"), fill = c("steelblue", "orange"))
dev.off()

poisson_gof <- chisq.test(obs_tab, p = dpois(0:30, lambda_hat) / sum(dpois(0:30, lambda_hat)))

sink("output/lab06_normal_poisson_fitting.txt")
cat("=== Shapiro-Wilk test for BMI (n=500 sample) ===\n")
print(shapiro_bmi)

cat("\nlambda_hat (mean PhysHlth):", lambda_hat, "\n")
cat("Variance PhysHlth:", var(df$PhysHlth), "\n")
cat("(Note: variance >> mean here indicates over-dispersion relative to Poisson.)\n\n")

cat("=== Chi-square goodness-of-fit: Poisson(lambda_hat) for PhysHlth ===\n")
print(poisson_gof)
sink()

cat("Lab 6 done. See output/lab06_normal_poisson_fitting.txt and the 3 PNGs in output/\n")
