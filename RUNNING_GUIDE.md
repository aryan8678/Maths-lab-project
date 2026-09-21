# Running Guide — Execution Order & Experiment Descriptions

This file is the single reference for (1) running every lab script in the
correct order so the outputs are ready to drop into the final report, and
(2) what each experiment does and why, so report-writing doesn't require
re-reading the code. It also lists what's still needed for Phase 2.

---

## How to run (RStudio)

For **every** script below:
1. Open the `.R` file in RStudio.
2. `Session > Set Working Directory > To Source File Location` (scripts use
   relative paths like `../data/...` and `output/...`, so this step is
   required each time you switch labs).
3. Run the whole script (`Ctrl+Alt+R` / `Source`).
4. Check the lab's `output/` folder: a `.txt` file with all printed
   results, plus one or more chart `.png` files.

Run them **strictly in this order** — each lab after Lab 1 reads
`data/brfss_clean.csv`, which Lab 1 produces from `data/brfss_sample.csv`,
which Lab 0 produces:

| Order | Script | Produces |
|---|---|---|
| 1 | `Lab00_Setup/00_setup.R` | installs packages; writes `data/brfss_sample.csv` |
| 2 | `Lab01_Data_Types/01_data_types.R` | writes `data/brfss_clean.csv` (everything below depends on this) |
| 3 | `Lab02_Summary_Stats/02_summary_stats.R` | |
| 4 | `Lab03_Correlation_Regression/03_correlation_regression.R` | |
| 5 | `Lab04_Multiple_Regression/04_multiple_regression.R` | |
| 6 | `Lab05_Binomial_Fitting/05_binomial_fitting.R` | |
| 7 | `Lab06_Normal_Poisson_Fitting/06_normal_poisson_fitting.R` | |
| 8 | `Lab07_OneSample_Tests/07_onesample_tests.R` | |
| 9 | `Lab08_TwoSample_Tests/08_twosample_tests.R` | |
| 10 | `Lab09_Paired_TTest/09_independent_ttest.R` | independent-samples half only (see Phase 2 note below) |
| 11 | `Lab10_ChiSquare_Tests/10_chisquare_tests.R` | |
| 12 | `Lab11_ANOVA_CRD/11_anova_crd.R` | |

Labs 3–11 (after Lab 1 has run once) don't depend on each other and can be
re-run in any order or individually — the table above is just the sequence
that mirrors the syllabus and the final report's section order.

---

## Experiment-by-experiment description (for the report)

**Lab 0 — Environment Setup & Data Acquisition**
No syllabus number; preparation only. Installs required packages, loads the
full 253,680-row BRFSS 2015 dataset, derives the binary diabetes label, and
draws a reproducible n=3000 working subsample (`set.seed(101)`) so every
later chart/test runs fast and is exactly reproducible.

**Lab 1 — Data Types, Import & Export** *(Exp. 1)*
Classifies every variable as binary, ordinal, continuous, or count;
converts columns to R factors accordingly; checks for missing values;
exports the typed dataset. Purpose: establishing correct variable types is
a prerequisite for every statistical procedure that follows (e.g. you
can't run ANOVA meaningfully on a variable R still thinks is numeric when
it's really a categorical code).

**Lab 2 — Summary Statistics & Visualization** *(Exp. 2)*
Computes mean/median/SD/min/max for the continuous and count variables
(BMI, MentHlth, PhysHlth) and frequency/proportion tables for categoricals
(Sex, Diabetes_binary). Produces five different chart types — histogram,
bar chart, pie chart, boxplot, density plot — to show the same data can be
read multiple ways depending on the question being asked.

**Lab 3 — Correlation & Simple Linear Regression** *(Exp. 3)*
Measures the linear association between BMI and days of poor physical
health (PhysHlth) with Pearson's r, then fits a simple linear regression
`BMI ~ PhysHlth` and interprets the slope, R², and p-value. Purpose:
moving from "are two variables related" (correlation) to "how much does
one predict the other" (regression).

**Lab 4 — Multiple Linear Regression** *(Exp. 4)*
Extends Lab 3 to several predictors at once (`BMI ~ Age + PhysActivity +
Income + Education + Smoker`), reporting multiple R², adjusted R², and a
residuals-vs-fitted diagnostic plot. Purpose: isolating each predictor's
effect on BMI while holding the others constant, and checking whether the
linear model's assumptions (constant variance, no obvious pattern in
residuals) roughly hold.

**Lab 5 — Fitting the Binomial Distribution** *(Exp. 5)*
Splits the sample into blocks of 10, counts how many people in each block
have diabetes, and compares that observed distribution of "successes per
block" against the theoretical Binomial(10, p̂) distribution using a
chi-square goodness-of-fit test. Purpose: testing whether a real binary
outcome behaves like the textbook Binomial model it's supposed to
approximate.

**Lab 6 — Fitting Normal & Poisson Distributions** *(Exp. 6)*
Two independent fits: (a) BMI against a Normal curve, checked visually
(histogram + curve, Q-Q plot) and formally (Shapiro-Wilk test); (b)
PhysHlth (a genuine 0–30 day count variable) against a Poisson(λ̂)
distribution, checked with a chi-square GOF test. Purpose: showing that
not all data fits its "natural" theoretical distribution — real count data
is typically over-dispersed relative to Poisson, which is worth reporting
honestly rather than forcing a good-fit conclusion.

**Lab 7 — Hypothesis Testing: One-Sample Mean & Proportion** *(Exp. 7)*
One-sample t-test on whether mean BMI differs from a reference value (27),
and a one-sample proportion test on whether diabetes prevalence in the
sample differs from a claimed population rate (11%). Purpose: the
foundational single-sample inference procedures — stating H₀/H₁, computing
a test statistic, and drawing a conclusion from a p-value.

**Lab 8 — Hypothesis Testing: Two-Sample Means & Proportions** *(Exp. 8)*
Two-sample t-test comparing mean BMI between men and women; two-sample
proportion test comparing diabetes prevalence between smokers and
non-smokers, each paired with a comparison chart. Purpose: extending
single-sample inference to comparing two independent groups, the most
common real-world hypothesis-testing scenario.

**Lab 9 — t-test: Independent Samples** *(Exp. 9, independent half)*
Independent-samples t-test comparing PhysHlth between men and women. This
is a genuine two independent-group comparison. **The paired-samples half
of this experiment (before/after weight in the `MASS::anorexia` data) is
Phase 2** — see below — because BRFSS is a cross-sectional survey with no
before/after structure to pair on.

**Lab 10 — Chi-Square: Goodness-of-Fit & Contingency Tests** *(Exp. 10)*
A goodness-of-fit test on the Age-band distribution, plus two contingency
(independence) tests: Diabetes × HighBP, and Diabetes × Smoker, each with
a stacked bar chart. Purpose: testing association between two categorical
variables — do diabetes and high blood pressure status move together, or
are they independent?

**Lab 11 — ANOVA: Completely Randomized Design (CRD)** *(Exp. 11a)*
One-way ANOVA testing whether mean BMI differs across Education levels
(multiple independent groups, no blocking), followed by Tukey HSD to see
*which* pairs of education levels differ. Purpose: generalizing the
two-group t-test (Lab 8) to more than two groups.

---

## Phase 2 — what's still needed

Phase 2 covers the two things the BRFSS survey **cannot** give you because
it's a single cross-sectional observational survey: a genuine paired
before/after sample, and true block-designed ANOVA. It uses three small,
real, already-published classical datasets — **all built into R packages,
so nothing needs to be downloaded from an external website.** Running
`install.packages(c("MASS", "agridat"))` (already done in Lab 0) and then
`library(...); data(...)` is enough to load them.

| Lab | Dataset | Package | What it's for | Why BRFSS can't do this |
|---|---|---|---|---|
| 9b | `anorexia` | `MASS` (CRAN) | Paired t-test (Prewt vs Postwt) | No before/after measurement exists in a cross-sectional survey |
| 12 | `npk` | `datasets` (base R — no install needed) | Randomized Block Design ANOVA | No physical blocking structure (e.g. field plots) exists in survey data |
| 13 | `goulden.latin` | `agridat` (CRAN) | Latin Square Design ANOVA | No two-way nuisance-factor blocking structure exists in survey data |

**Documentation / reference links (CRAN, not data-download links — the
data ships inside the installed package):**
- `MASS::anorexia` — https://cran.r-project.org/web/packages/MASS/MASS.pdf (see "anorexia" entry)
- `datasets::npk` — https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/npk.html
- `agridat::goulden.latin` — https://cran.r-project.org/web/packages/agridat/agridat.pdf (see "goulden.latin" entry); package homepage/vignettes: https://kwstat.github.io/agridat/

No Kaggle/UCI-style external CSV is required for Phase 2 — this is
intentional in the original plan (see `Maths_implementation.md`, "Why two
phases").

---

## Assembling the final report

Once Phase 1 (and later Phase 2) scripts have all been run, the final
report (structure in `Maths_implementation.md`, "Final Report Structure")
can be assembled by, for each lab in order: pulling the relevant tables
out of that lab's `output/*.txt`, embedding the chart PNGs from that lab's
`output/`, and adding the interpretation paragraph (the description above
for each lab is a good starting point/skeleton for that paragraph).
