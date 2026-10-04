> Historical plan. Phase 2 is now implemented. The simpler Gomez complete-block rice experiment replaces the proposed npk example. See README.md, RUNNING_GUIDE.md and report/FINAL_REVIEW.md for the completed implementation.

# Implementation Plan
### BMAT202P — Probability and Statistics Lab Project
**Project title:** *Statistical Analysis of Diabetes & Lifestyle Risk Factors (CDC BRFSS 2015), with a Classical Design-of-Experiments Supplement*

---

## 0. Project Overview

| | |
|---|---|
| **Phase 1 dataset** | CDC Diabetes Health Indicators (BRFSS 2015) — 253,680 rows, 21 variables |
| **Phase 1 source** | Kaggle: `kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset` → file `diabetes_binary_health_indicators_BRFSS2015.csv` (also mirrored on UCI ML Repo, id=891) |
| **Phase 2 datasets** | `MASS::anorexia` (paired t-test), `datasets::npk` (RBD), `agridat::goulden.latin` (Latin Square) — all real, already-published data, built into R/packages |
| **Tool** | R / RStudio (matches the prescribed textbook, *Statistical Analysis with R* by J. Schmuller) |
| **Total lab sessions** | 15 (≈ 2 hrs each = 30 hrs, matching the syllabus's total lab hours) |

**Why two phases:** Phase 1 covers everything that a large observational survey can support (data handling, description, regression, binomial/Poisson fitting, hypothesis tests, chi-square, one-way ANOVA). Phase 2 covers the two things an observational dataset structurally cannot give you — a genuine paired (before/after) sample, and true block-designed ANOVA (RBD, Latin Square) — using real classical experiments instead of data you'd have to collect yourself.

---

## Lab 0 — Environment Setup & Data Acquisition
*(No syllabus experiment number — preparation session)*

**Tasks:**
1. Install R and RStudio.
2. Install required packages (one-time):
   ```r
   install.packages(c("dplyr", "ggplot2", "corrplot", "MASS", "agricolae", "agridat", "car"))
   ```
3. Create Kaggle account (free) → download `diabetes_binary_health_indicators_BRFSS2015.csv`. Place it in your project's `/data` folder.
4. Load and sanity-check:
   ```r
   library(dplyr)
   full_data <- read.csv("data/diabetes_binary_health_indicators_BRFSS2015.csv")
   dim(full_data)          # should be 253680 x 21
   names(full_data)        # confirm column names — adjust casing below if they differ
   ```
5. Draw a reproducible working subsample (keeps plots/tests fast and readable):
   ```r
   set.seed(101)
   df <- dplyr::sample_n(full_data, 3000)
   write.csv(df, "data/brfss_sample.csv", row.names = FALSE)
   ```
6. Load Phase 2 datasets now so you know they work:
   ```r
   library(MASS);      data(anorexia)
   data(npk)                                   # base R, no library() needed
   library(agridat);   data(goulden.latin)
   ```

**Deliverable:** Working R project folder, all packages installed, `df` (n=3000) and the three Phase 2 datasets loading without error.

---

## Lab 1 — Data Types, Import & Export
*(Syllabus Exp. 1)*

**Dataset:** `df` (BRFSS sample)

**Tasks:**
- Identify each variable's type: binary (`Diabetes_binary`, `HighBP`, `Smoker`, `Sex`, …), ordinal (`GenHlth`, `Education`, `Income`, `Age` band), continuous (`BMI`), count (`MentHlth`, `PhysHlth`).
- Convert appropriate columns to factors.
- Check for missing values.
- Export a cleaned version.

```r
str(df)
sapply(df, class)
colSums(is.na(df))

df$Sex     <- factor(df$Sex, labels = c("Female","Male"))
df$Smoker  <- factor(df$Smoker, labels = c("No","Yes"))
df$Diabetes_binary <- factor(df$Diabetes_binary, labels = c("No","Yes"))

write.csv(df, "data/brfss_clean.csv", row.names = FALSE)
```

**Deliverable:** Table of variable names classified by type (nominal/ordinal/continuous/count); cleaned CSV exported.

---

## Lab 2 — Summary Statistics & Visualization
*(Syllabus Exp. 2)*

**Tasks:** Compute descriptive statistics and produce a *variety* of chart types.

```r
summary(df$BMI); summary(df$MentHlth); summary(df$PhysHlth)
table(df$Sex); table(df$Diabetes_binary); prop.table(table(df$Diabetes_binary))

library(ggplot2)
# Histogram
ggplot(df, aes(BMI)) + geom_histogram(binwidth = 2, fill="steelblue")
# Bar chart
ggplot(df, aes(factor(Education))) + geom_bar(fill="darkorange")
# Pie chart
pie(table(df$Sex), main = "Sex Distribution")
# Boxplot
ggplot(df, aes(Diabetes_binary, BMI)) + geom_boxplot()
# Density plot
ggplot(df, aes(PhysHlth)) + geom_density(fill="lightgreen", alpha=0.5)
```

**Deliverable:** A results table (mean, median, SD, min, max for BMI/MentHlth/PhysHlth; frequency tables for categoricals) + 5 different chart types with one-paragraph interpretation each.

---

## Lab 3 — Correlation & Simple Linear Regression
*(Syllabus Exp. 3)*

**Tasks:** Relationship between BMI and PhysHlth (or Age band and BMI).

```r
cor(df$BMI, df$PhysHlth, use = "complete.obs")
model1 <- lm(BMI ~ PhysHlth, data = df)
summary(model1)          # note the coefficient, R², p-value

ggplot(df, aes(PhysHlth, BMI)) +
  geom_jitter(alpha=0.3) +
  geom_smooth(method="lm", col="red")
```

**Deliverable:** Correlation coefficient with interpretation; regression equation; R² interpreted in plain language ("X% of variation in BMI is explained by …"); scatter plot with fitted line.

---

## Lab 4 — Multiple Linear Regression
*(Syllabus Exp. 4)*

```r
model2 <- lm(BMI ~ Age + PhysActivity + Income + Education + Smoker, data = df)
summary(model2)          # multiple R², adjusted R²
plot(model2, which = 1)  # residuals vs fitted
```

**Deliverable:** Full regression table (coefficients, significance), multiple R² and adjusted R² with interpretation, residual diagnostic plot, brief comment on model fit.

---

## Lab 5 — Fitting the Binomial Distribution
*(Syllabus Exp. 5)*

**Idea:** Split the sample into fixed-size blocks, count "successes" (people with the condition) per block, and compare to the theoretical Binomial PMF.

```r
n_per_group <- 10
groups <- split(df$Diabetes_binary, ceiling(seq_along(df$Diabetes_binary)/n_per_group))
successes <- sapply(groups, function(g) sum(g == "Yes"))

p_hat <- mean(df$Diabetes_binary == "Yes")
observed <- table(factor(successes, levels = 0:n_per_group))
expected <- dbinom(0:n_per_group, n_per_group, p_hat) * length(groups)

barplot(rbind(observed, expected), beside = TRUE,
        col = c("steelblue","orange"), legend.text = c("Observed","Expected"))
chisq.test(observed, p = dbinom(0:n_per_group, n_per_group, p_hat), rescale.p = TRUE)
```

**Deliverable:** Observed-vs-expected bar chart, chi-square goodness-of-fit result, conclusion on whether Diabetes_binary behaves like Binomial(10, p̂) across blocks.

---

## Lab 6 — Fitting Normal & Poisson Distributions
*(Syllabus Exp. 6)*

**Normal check (BMI):**
```r
hist(df$BMI, freq = FALSE, main = "BMI with Normal Curve")
curve(dnorm(x, mean(df$BMI), sd(df$BMI)), add = TRUE, col = "red", lwd = 2)
qqnorm(df$BMI); qqline(df$BMI, col = "red")
shapiro.test(sample(df$BMI, 500))   # Shapiro-Wilk needs n ≤ 5000
```

**Poisson fit (PhysHlth — a genuine count variable, 0–30):**
```r
lambda_hat <- mean(df$PhysHlth)
obs_tab <- table(factor(df$PhysHlth, levels = 0:30))
exp_tab <- dpois(0:30, lambda_hat) * nrow(df)

barplot(rbind(obs_tab, exp_tab), beside = TRUE, col=c("steelblue","orange"))
chisq.test(obs_tab, p = dpois(0:30, lambda_hat)/sum(dpois(0:30,lambda_hat)))
```

**Deliverable:** Histogram + normal curve overlay, QQ-plot, Shapiro-Wilk result for BMI; observed-vs-expected Poisson bar chart and chi-square GOF result for PhysHlth; conclusion on both fits (note: real count data is often over-dispersed relative to Poisson — worth a sentence of honest commentary).

---

## Lab 7 — Hypothesis Testing: One-Sample Mean & Proportion
*(Syllabus Exp. 7)*

```r
# One-sample t-test: is mean BMI different from a reference value (e.g. 27)?
t.test(df$BMI, mu = 27)

# One-sample proportion test: is diabetes prevalence different from a claimed 11%?
successes <- sum(df$Diabetes_binary == "Yes")
prop.test(x = successes, n = nrow(df), p = 0.11)
```

**Deliverable:** State H₀/H₁ for each test, report t/z statistic, p-value, and a plain-language conclusion for both.

---

## Lab 8 — Hypothesis Testing: Two-Sample Means & Proportions
*(Syllabus Exp. 8)*

```r
# Two-sample mean: BMI, Male vs Female
t.test(BMI ~ Sex, data = df)

# Two-sample proportion: diabetes prevalence, Smokers vs Non-smokers
tab <- table(df$Smoker, df$Diabetes_binary)
prop.test(tab)
```

**Deliverable:** Grouped boxplot (BMI by Sex), grouped bar chart (diabetes proportion by smoking status), both test results with H₀/H₁ and conclusions.

---

## Lab 9 — t-test: Independent & Paired Samples
*(Syllabus Exp. 9)*

**Independent samples (BRFSS data):**
```r
t.test(PhysHlth ~ Sex, data = df)          # independent, unpaired
```

**Paired samples (Phase 2 — `MASS::anorexia`):**
```r
library(MASS); data(anorexia)
t.test(anorexia$Prewt, anorexia$Postwt, paired = TRUE)

# Visualize the pairing
matplot(t(anorexia[,c("Prewt","Postwt")]), type="l", lty=1,
        col=rgb(0,0,1,0.3), xaxt="n", ylab="Weight (lbs)")
axis(1, at=1:2, labels=c("Pre","Post"))
```

**Deliverable:** Independent t-test result (BRFSS); paired t-test result (anorexia data) with a before/after line plot; short discussion contrasting what "independent" vs "paired" means for the conclusion drawn.

---

## Lab 10 — Chi-Square: Goodness-of-Fit & Contingency Tests
*(Syllabus Exp. 10)*

**Goodness-of-fit** — reuse Lab 5/6 results, or run a fresh one:
```r
age_tab <- table(df$Age)
chisq.test(age_tab)   # tests uniform-ish assumption; discuss result
```

**Contingency (independence) tests:**
```r
t1 <- table(df$Diabetes_binary, df$HighBP)
chisq.test(t1)

t2 <- table(df$Diabetes_binary, df$Smoker)
chisq.test(t2)

# Stacked bar visualization
ggplot(df, aes(HighBP, fill = Diabetes_binary)) +
  geom_bar(position = "fill") + ylab("Proportion")
```

**Deliverable:** At least one GOF test and two contingency tests, each with a stacked-bar or mosaic-style chart and a plain-language interpretation of association (or lack of it).

---

## Lab 11 — ANOVA: Completely Randomized Design (CRD)
*(Syllabus Exp. 11, part a)*

**Dataset:** BRFSS sample — compare BMI (or PhysHlth) across Education levels (multiple independent groups, no blocking).

```r
model3 <- aov(BMI ~ factor(Education), data = df)
summary(model3)
TukeyHSD(model3)

ggplot(df, aes(factor(Education), BMI)) + geom_boxplot()
```

**Deliverable:** ANOVA table, F-statistic and p-value, Tukey HSD pairwise comparisons, boxplot by group, conclusion on whether mean BMI differs across education levels.

---

## Lab 12 — ANOVA: Randomized Block Design (RBD)
*(Syllabus Exp. 11, part b)*

**Dataset:** `datasets::npk` — classical real N/P/K fertilizer trial on pea yield, 6 blocks (built into base R, nothing to install).

```r
data(npk)
model4 <- aov(yield ~ block + N + P + K, data = npk)
summary(model4)

boxplot(yield ~ block, data = npk, main = "Yield by Block")
boxplot(yield ~ N, data = npk, main = "Yield by Nitrogen Treatment")
```

**Deliverable:** RBD ANOVA table separating block effect from treatment effects (N, P, K), boxplots by block and by treatment, explanation of *why* blocking by field plot removes nuisance variability from the error term (compare residual SS with/without the block term for a nice discussion point).

---

## Lab 13 — ANOVA: Latin Square Design (LSD)
*(Syllabus Exp. 11, part c)*

**Dataset:** `agridat::goulden.latin` — real 5×5 Latin square fungicide trial on wheat stem rust (Goulden, 1952).

```r
library(agridat)
data(goulden.latin)
dat <- goulden.latin

model5 <- aov(yield ~ trt + factor(row) + factor(col), data = dat)
summary(model5)

# Field-layout heatmap (needs the 'desplot' package, optional)
# install.packages("desplot"); library(desplot)
# desplot(dat, yield ~ col*row, text = trt, main = "Goulden Latin Square")
```

**Deliverable:** LSD ANOVA table separating row-block, column-block, and treatment effects; a simple heatmap or table showing the 5×5 layout; conclusion on which fungicide treatment(s) performed best, and a short note on how LSD controls two nuisance factors (row + column) simultaneously versus RBD's one.

---

## Lab 14 — Consolidation, Cross-Check & Report Assembly
*(No new syllabus number — wrap-up session)*

**Tasks:**
1. Bonus cross-check: run a second CRD example on `anorexia$Postwt - anorexia$Prewt` grouped by `Treat`, to compare against Lab 11's CRD result:
   ```r
   anorexia$change <- anorexia$Postwt - anorexia$Prewt
   summary(aov(change ~ Treat, data = anorexia))
   ```
2. Re-check every chi-square/t-test assumption you used (sample size, expected cell counts ≥5 for chi-square, roughly normal data for t-tests) and note any caveats in the report.
3. Compile all code into a single, well-commented `.R` script.
4. Assemble the final report (structure below).
5. Prepare for the FAT / oral exam: be ready to explain *why* each test was chosen, not just how to run it.

---

## Final Report Structure

1. **Introduction & Objectives**
2. **Dataset Description** — Phase 1 (BRFSS) and Phase 2 (anorexia, npk, goulden.latin), with justification for the two-phase approach
3. **Data Import & Preprocessing** (Lab 1)
4. **Descriptive Statistics & Visualization** (Lab 2)
5. **Correlation & Regression** (Labs 3–4)
6. **Probability Distribution Fitting** (Labs 5–6)
7. **Hypothesis Testing** (Labs 7–9)
8. **Chi-Square Tests** (Lab 10)
9. **ANOVA — CRD, RBD, Latin Square** (Labs 11–13)
10. **Consolidated Findings & Conclusion** (Lab 14)
11. **Appendix** — full R code, package list, references/data sources

---

## Session-at-a-Glance Timeline

| Session | Syllabus Exp. | Focus |
|---|---|---|
| 0 | — | Setup & data acquisition |
| 1 | 1 | Data types, import/export |
| 2 | 2 | Summary stats & visualization |
| 3 | 3 | Correlation & simple regression |
| 4 | 4 | Multiple regression |
| 5 | 5 | Binomial fitting |
| 6 | 6 | Normal & Poisson fitting |
| 7 | 7 | One-sample tests |
| 8 | 8 | Two-sample tests |
| 9 | 9 | Independent + paired t-test |
| 10 | 10 | Chi-square GOF & contingency |
| 11 | 11a | ANOVA — CRD |
| 12 | 11b | ANOVA — RBD |
| 13 | 11c | ANOVA — Latin Square |
| 14 | — | Consolidation & report |

## Package Reference

| Package | Used for |
|---|---|
| `dplyr` | Data manipulation, sampling |
| `ggplot2` | All charts |
| `corrplot` | Correlation heatmap (optional, Lab 3/4) |
| `MASS` | `anorexia` dataset (paired t-test) |
| `agricolae` | RBD/LSD test utilities (optional cross-check) |
| `agridat` | `goulden.latin` dataset (Latin square) |
| `car` | Regression diagnostics (optional) |

## Data Sources

- Diabetes Health Indicators Dataset (BRFSS 2015): `kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset`
- CDC Diabetes Health Indicators (UCI mirror): `archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators`
- `MASS::anorexia` — Hand, D.J. et al. (1993), *A Handbook of Small Data Sets*, Chapman & Hall
- `datasets::npk` — Imperial College, London, M.Sc. exercise sheet; Venables & Ripley (2002)
- `agridat::goulden.latin` — Goulden, C.H. (1952), *Methods of Statistical Analysis*, 2nd ed., p.216
