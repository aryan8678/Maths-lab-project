# Lab 3 - Correlation & Simple Linear Regression
# Syllabus Exp. 3
# Input: data/brfss_clean.csv

library(ggplot2)

df <- read.csv("../data/brfss_clean.csv")

sink("output/lab03_correlation_regression.txt")

cat("=== Correlation: BMI vs PhysHlth ===\n")
r <- cor(df$BMI, df$PhysHlth, use = "complete.obs")
print(r)

cat("\n=== Simple linear regression: BMI ~ PhysHlth ===\n")
model1 <- lm(BMI ~ PhysHlth, data = df)
print(summary(model1))

sink()

ggsave("output/scatter_bmi_physhlth.png",
       ggplot(df, aes(PhysHlth, BMI)) +
         geom_jitter(alpha = 0.3) +
         geom_smooth(method = "lm", col = "red") +
         labs(title = "BMI vs Days of Poor Physical Health",
              subtitle = paste0("r = ", round(r, 3))),
       width = 6, height = 4)

cat("Lab 3 done. See output/lab03_correlation_regression.txt and scatter_bmi_physhlth.png\n")
