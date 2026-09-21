# Lab 10 - Chi-Square: Goodness-of-Fit & Contingency Tests
# Syllabus Exp. 10
# Input: data/brfss_clean.csv

library(ggplot2)

df <- read.csv("../data/brfss_clean.csv")
df$HighBP           <- factor(df$HighBP, levels = c(0, 1), labels = c("No", "Yes"))
df$Smoker           <- factor(df$Smoker, levels = c("No", "Yes"))
df$Diabetes_binary  <- factor(df$Diabetes_binary, levels = c("No", "Yes"))

sink("output/lab10_chisquare_tests.txt")

cat("=== Goodness-of-fit: Age band distribution (uniform-ish assumption) ===\n")
age_tab <- table(df$Age)
print(age_tab)
print(chisq.test(age_tab))

cat("\n=== Contingency test 1: Diabetes_binary x HighBP ===\n")
t1 <- table(df$Diabetes_binary, df$HighBP)
print(t1)
print(chisq.test(t1))

cat("\n=== Contingency test 2: Diabetes_binary x Smoker ===\n")
t2 <- table(df$Diabetes_binary, df$Smoker)
print(t2)
print(chisq.test(t2))

sink()

ggsave("output/stacked_diabetes_by_highbp.png",
       ggplot(df, aes(HighBP, fill = Diabetes_binary)) +
         geom_bar(position = "fill") + ylab("Proportion") +
         labs(title = "Diabetes Proportion by High Blood Pressure Status"),
       width = 5, height = 4)

cat("Lab 10 done. See output/lab10_chisquare_tests.txt and stacked_diabetes_by_highbp.png\n")
