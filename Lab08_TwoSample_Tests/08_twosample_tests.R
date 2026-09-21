# Lab 8 - Hypothesis Testing: Two-Sample Means & Proportions
# Syllabus Exp. 8
# Input: data/brfss_clean.csv

library(ggplot2)

df <- read.csv("../data/brfss_clean.csv")
df$Sex             <- factor(df$Sex, levels = c("Female", "Male"))
df$Smoker          <- factor(df$Smoker, levels = c("No", "Yes"))
df$Diabetes_binary <- factor(df$Diabetes_binary, levels = c("No", "Yes"))

sink("output/lab08_twosample_tests.txt")

cat("=== Two-sample t-test: BMI, Male vs Female ===\n")
print(t.test(BMI ~ Sex, data = df))

cat("\n=== Two-sample proportion test: Diabetes prevalence, Smokers vs Non-smokers ===\n")
tab <- table(df$Smoker, df$Diabetes_binary)
print(tab)
print(prop.test(tab))

sink()

ggsave("output/box_bmi_by_sex.png",
       ggplot(df, aes(Sex, BMI)) + geom_boxplot() +
         labs(title = "BMI by Sex"),
       width = 5, height = 4)

ggsave("output/bar_diabetes_by_smoker.png",
       ggplot(df, aes(Smoker, fill = Diabetes_binary)) +
         geom_bar(position = "fill") + ylab("Proportion") +
         labs(title = "Diabetes Prevalence by Smoking Status"),
       width = 5, height = 4)

cat("Lab 8 done. See output/lab08_twosample_tests.txt and the 2 chart PNGs\n")
