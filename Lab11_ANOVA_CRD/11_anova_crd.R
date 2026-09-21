# Lab 11 - ANOVA: Completely Randomized Design (CRD)
# Syllabus Exp. 11, part a
# Input: data/brfss_clean.csv

library(ggplot2)

df <- read.csv("../data/brfss_clean.csv")

model3 <- aov(BMI ~ factor(Education), data = df)

sink("output/lab11_anova_crd.txt")
cat("=== One-way ANOVA (CRD): BMI ~ Education ===\n")
print(summary(model3))

cat("\n=== Tukey HSD pairwise comparisons ===\n")
print(TukeyHSD(model3))
sink()

ggsave("output/box_bmi_by_education.png",
       ggplot(df, aes(factor(Education), BMI)) + geom_boxplot() +
         labs(title = "BMI by Education Level", x = "Education (band)"),
       width = 6, height = 4)

cat("Lab 11 done. See output/lab11_anova_crd.txt and box_bmi_by_education.png\n")
