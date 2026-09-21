# Lab 2 - Summary Statistics & Visualization
# Syllabus Exp. 2
# Input:  data/brfss_clean.csv (from Lab 1)

library(ggplot2)

df <- read.csv("../data/brfss_clean.csv")
df$Diabetes_binary <- factor(df$Diabetes_binary, levels = c("No", "Yes"))
df$Sex             <- factor(df$Sex, levels = c("Female", "Male"))

sink("output/lab02_summary_stats.txt")

cat("=== Numeric summaries ===\n")
cat("\nBMI:\n");      print(summary(df$BMI));      cat("SD:", sd(df$BMI), "\n")
cat("\nMentHlth:\n"); print(summary(df$MentHlth)); cat("SD:", sd(df$MentHlth), "\n")
cat("\nPhysHlth:\n"); print(summary(df$PhysHlth)); cat("SD:", sd(df$PhysHlth), "\n")

cat("\n=== Frequency tables ===\n")
cat("\nSex:\n");              print(table(df$Sex))
cat("\nDiabetes_binary:\n");  print(table(df$Diabetes_binary))
cat("\nDiabetes_binary (proportion):\n"); print(prop.table(table(df$Diabetes_binary)))

sink()

## Charts -------------------------------------------------------------------
ggsave("output/hist_bmi.png",
       ggplot(df, aes(BMI)) + geom_histogram(binwidth = 2, fill = "steelblue") +
         labs(title = "Distribution of BMI"),
       width = 6, height = 4)

ggsave("output/bar_education.png",
       ggplot(df, aes(factor(Education))) + geom_bar(fill = "darkorange") +
         labs(title = "Education Level Counts", x = "Education (band)"),
       width = 6, height = 4)

png("output/pie_sex.png", width = 500, height = 500)
pie(table(df$Sex), main = "Sex Distribution")
dev.off()

ggsave("output/box_bmi_by_diabetes.png",
       ggplot(df, aes(Diabetes_binary, BMI)) + geom_boxplot() +
         labs(title = "BMI by Diabetes Status"),
       width = 6, height = 4)

ggsave("output/density_physhlth.png",
       ggplot(df, aes(PhysHlth)) + geom_density(fill = "lightgreen", alpha = 0.5) +
         labs(title = "Density of PhysHlth (days of poor physical health)"),
       width = 6, height = 4)

cat("Lab 2 done. See output/lab02_summary_stats.txt and the 5 chart PNGs in output/\n")
