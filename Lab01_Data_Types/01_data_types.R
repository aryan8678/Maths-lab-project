# Lab 1 - Data Types, Import & Export
# Syllabus Exp. 1
# Input:  data/brfss_sample.csv (from Lab 0)
# Output: data/brfss_clean.csv, output/lab01_variable_types.txt

df <- read.csv("../data/brfss_sample.csv")

sink("output/lab01_variable_types.txt")

cat("=== Structure ===\n")
str(df)

cat("\n=== Class of each column ===\n")
print(sapply(df, class))

cat("\n=== Missing values per column ===\n")
print(colSums(is.na(df)))

sink()

## Convert appropriate columns to factors ---------------------------------
binary_vars <- c("Diabetes_binary", "HighBP", "HighChol", "CholCheck",
                  "Smoker", "Stroke", "HeartDiseaseorAttack", "PhysActivity",
                  "Fruits", "Veggies", "HvyAlcoholConsump", "AnyHealthcare",
                  "NoDocbcCost", "DiffWalk", "Sex")
df[binary_vars] <- lapply(df[binary_vars], function(x) factor(x, levels = c(0, 1)))

df$Sex             <- factor(df$Sex, labels = c("Female", "Male"))
df$Smoker          <- factor(df$Smoker, labels = c("No", "Yes"))
df$Diabetes_binary <- factor(df$Diabetes_binary, labels = c("No", "Yes"))

df$GenHlth   <- factor(df$GenHlth, ordered = TRUE)
df$Education <- factor(df$Education, ordered = TRUE)
df$Income    <- factor(df$Income, ordered = TRUE)
df$Age       <- factor(df$Age, ordered = TRUE)   # BRFSS age band code, not raw age

## Variable type classification table -------------------------------------
var_types <- data.frame(
  variable = names(df),
  type = c("count (12-class label pre-binarize)", # Diabetes_012
           "binary",                               # Diabetes_binary (derived)
           "binary", "binary", "binary",            # HighBP, HighChol, CholCheck
           "continuous",                            # BMI
           "binary", "binary", "binary", "binary",  # Smoker, Stroke, HeartDiseaseorAttack, PhysActivity
           "binary", "binary", "binary",            # Fruits, Veggies, HvyAlcoholConsump
           "binary", "binary",                      # AnyHealthcare, NoDocbcCost
           "ordinal",                               # GenHlth
           "count (0-30 days)", "count (0-30 days)",# MentHlth, PhysHlth
           "binary",                                # DiffWalk
           "binary",                                # Sex
           "ordinal (age band)",                    # Age
           "ordinal",                                # Education
           "ordinal"                                 # Income
  )[match(names(df), c("Diabetes_012","Diabetes_binary","HighBP","HighChol","CholCheck",
                        "BMI","Smoker","Stroke","HeartDiseaseorAttack","PhysActivity",
                        "Fruits","Veggies","HvyAlcoholConsump","AnyHealthcare","NoDocbcCost",
                        "GenHlth","MentHlth","PhysHlth","DiffWalk","Sex","Age",
                        "Education","Income"))]
)
write.csv(var_types, "output/lab01_variable_type_table.csv", row.names = FALSE)

## Export cleaned data ------------------------------------------------------
write.csv(df, "../data/brfss_clean.csv", row.names = FALSE)

cat("Lab 1 done. See output/lab01_variable_types.txt,",
    "output/lab01_variable_type_table.csv, and data/brfss_clean.csv\n")
