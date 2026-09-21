# Lab 0 - Environment Setup & Data Acquisition
# BMAT202P Probability and Statistics Lab Project
#
# Run this once before any other lab. Produces:
#   data/brfss_sample.csv  (n = 3000, reproducible working subsample)

## 1. Packages (one-time) -----------------------------------------------
required_pkgs <- c("dplyr", "ggplot2", "corrplot", "MASS",
                    "agricolae", "agridat", "car")
new_pkgs <- required_pkgs[!(required_pkgs %in% installed.packages()[, "Package"])]
if (length(new_pkgs) > 0) install.packages(new_pkgs)

library(dplyr)

## 2. Load full dataset ---------------------------------------------------
# NOTE: the file on disk is the 3-class variant (Diabetes_012: 0/1/2)
# from Kaggle/UCI, not the pre-binarized file the original plan named.
# We derive Diabetes_binary from it below (0 = No, 1 or 2 = Yes), which
# is the standard collapse used for this dataset.
full_data <- read.csv("../data/diabetes_012_health_indicators_BRFSS2015.csv")

dim(full_data)     # expect 253680 x 22 (extra col vs. binary version's 21)
names(full_data)

full_data$Diabetes_binary <- ifelse(full_data$Diabetes_012 > 0, 1, 0)

## 3. Reproducible working subsample --------------------------------------
set.seed(101)
df <- dplyr::sample_n(full_data, 3000)
write.csv(df, "../data/brfss_sample.csv", row.names = FALSE)

## 4. Sanity-load the Phase 2 datasets (used in Labs 12-13, not built here)
library(MASS);    data(anorexia)
data(npk)                                   # base R, no library() needed
library(agridat); data(goulden.latin)

cat("\nSetup complete.\n")
cat("full_data:", nrow(full_data), "x", ncol(full_data), "\n")
cat("df (sample):", nrow(df), "x", ncol(df), "\n")
cat("Written: data/brfss_sample.csv\n")
