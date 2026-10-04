# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Acquisition and reproducible simple random sampling
out <- lab_output("Lab00_Setup")
raw <- data_path("diabetes_012_health_indicators_BRFSS2015.csv")
if (!file.exists(raw)) stop("Acquire data first: python scripts/acquire_data.py")
full <- read.csv(raw)
expected <- c("Diabetes_012","HighBP","HighChol","CholCheck","BMI","Smoker","Stroke",
 "HeartDiseaseorAttack","PhysActivity","Fruits","Veggies","HvyAlcoholConsump",
 "AnyHealthcare","NoDocbcCost","GenHlth","MentHlth","PhysHlth","DiffWalk","Sex","Age","Education","Income")
stopifnot(nrow(full) == 253680, identical(names(full), expected))
full$source_row <- seq_len(nrow(full))
full$Diabetes_binary <- ifelse(full$Diabetes_012 > 0, 1, 0)
set.seed(101)
df <- full[sample.int(nrow(full), 3000), ]
csv(df, data_path("brfss_sample.csv"))
status <- function(x, label) data.frame(dataset = label, status_code = 0:2,
 count = as.integer(table(factor(x$Diabetes_012, levels=0:2))),
 proportion = as.numeric(prop.table(table(factor(x$Diabetes_012, levels=0:2)))))
csv(rbind(status(full,"Full derivative"),status(df,"Working sample")), file.path(out,"class_balance.csv"))
metrics(c(full_n=nrow(full), raw_columns=length(expected), predictors=21, sample_n=nrow(df),
 seed=101, full_combined_rate=mean(full$Diabetes_binary), sample_combined_rate=mean(df$Diabetes_binary),
 full_duplicate_profiles=sum(duplicated(full[,expected])), sample_duplicate_profiles=sum(duplicated(df[,expected]))),out)
log_text(file.path(out,"lab00_setup.txt"), {
 cat("Source: Alex Teboul Kaggle derivative of CDC BRFSS 2015.\n")
 cat("253680 records, 21 predictors and one three-class target.\n")
 cat("Working sample: 3000, seed 101, without replacement.\n")
 cat("Combined positive = prediabetes OR diabetes.\n")
 cat("Duplicate feature profiles are retained; they do not identify duplicate people.\n")
 print(tools::md5sum(raw)); print(table(df$Diabetes_012)); print(sessionInfo())
})
