# Lab 4 - Multiple Linear Regression
# Syllabus Exp. 4
# Input: data/brfss_clean.csv

df <- read.csv("../data/brfss_clean.csv")

model2 <- lm(BMI ~ Age + PhysActivity + Income + Education + Smoker, data = df)

sink("output/lab04_multiple_regression.txt")
cat("=== Multiple linear regression: BMI ~ Age + PhysActivity + Income + Education + Smoker ===\n")
print(summary(model2))
sink()

png("output/residuals_vs_fitted.png", width = 600, height = 450)
plot(model2, which = 1)
dev.off()

cat("Lab 4 done. See output/lab04_multiple_regression.txt and residuals_vs_fitted.png\n")
