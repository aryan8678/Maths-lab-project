> Historical initial audit. The missing components and corrections identified here have now been implemented. Current completion evidence and rubric mapping are in report/FINAL_REVIEW.md.

# Project audit and draft completion plan

Audited on 4 October 2026 against the supplied evaluation image and the user's presentation-topic list.

Repository: https://github.com/aryan8678/Maths-lab-project
Audited revision: `2bfebaedd34c387206d70c8a362234e1cd425c2d` (`main`).
Scope: all 12 R scripts, README, running guide, implementation plan, tracked files and local directory contents. This is an audit and proposed plan; the statistical scripts have not been changed.

## Verdict

The project has a useful course-exercise structure, but it does **not yet fully implement the requested presentation or establish that the analyses are statistically sound**. Several core operations exist in code, but results, interpretations, outlier handling, and part of the course coverage are missing. Some existing calculations need correction before they can support conclusions.

Keep the separate exercise files. Improve their common data pipeline and connect their results to a clear project aim. A presentation should explain one investigation; the appendix can demonstrate exhaustive exercise coverage.

### What was actually verified

- The workspace was initially empty, so the requested repository was cloned here. A subsequent `git pull --ff-only` succeeded and reported “Already up to date.”
- All 12 R scripts were read. The checkout has no raw/sample/clean CSV, generated result tables, PNG plots, PPT, or mini thesis. `data/.gitkeep` and `report/.gitkeep` are placeholders. CSV exclusion is intentional in `.gitignore`; missing data does not prove that the team has never run the analyses elsewhere.
- None of the Lab 1–11 `output` directories exists in this checkout, and none of the scripts creates one. They are required by `sink()`, `png()`, and `ggsave()`.
- R/Rscript was not found on PATH or in the common installation locations checked. Consequently **no R execution or numerical result verification was performed**. No p-values, model quality, actual missing-value rates, or outlier counts are inferred from the scripts.
- A mathematical check confirms that Lab 5 necessarily has a sparse expected tail cell for its planned 300 blocks of 10: at least one of the 0-success or 10-success expected counts is at most `300 × (1/2)^10 = 0.29296875`.

The rubric is evaluation evidence, not a separate instruction to submit or publish anything. Its four categories are Collection of Data, Analysis, Review, and Final Submission, each worth 5 marks. Its review dates appear to be **6 October and 13 October 2026**; the first date in the image has a formatting typo. The official course handout was not supplied: coverage of individual exercises below is assessed against the repository's own syllabus mapping.

## 1. Required presentation topics: coverage and evidence

“Implemented” below means code exists, not that it has successfully run or produced a defensible result.

| Required topic | Current state | Evidence and completion needed |
|---|---|---|
| About the dataset | Partial | README and implementation plan name BRFSS and a 3,000-row sample. Add exact file/version, source lineage, row/feature counts, codebook, population, inclusion rules, class counts and limitations. Resolve contradictory shape/file descriptions. |
| Aim | Partial | Title and general overview exist. State specific questions and distinguish describing associations from predicting diabetes. Current regressions predict BMI. |
| Data preparation | Partial | Labs 0–1 sample, inspect missingness, recode factors and export CSV. Add schema/range checks, invalid-value decisions, stable identifiers, a row-count log and a loader that preserves types. |
| Outlier analysis | Missing as an analysis | Lab 2's boxplot displays potential BMI extremes but does not calculate fences, identify records, count flags or examine influence. |
| Removing outliers | Missing | No filtering, removal log, revised dataset or before/after comparison exists. Implement a justified policy and a clearly labelled sensitivity dataset. |
| Graphical analysis | Code present; results unverified | Lab 2 has five chart types; Labs 3, 5, 6, 8, 10, 11 add plots. Add units, meaningful labels, denominators and findings; improve displays for bounded counts. |
| Correlation and variances | Partial | Lab 3 computes one Pearson correlation. Lab 2 reports SD, but not a variance table; Lab 6 prints only PhysHlth variance. Add a numeric variance/covariance table and a small, appropriately chosen correlation analysis. |
| Regression | Code present; corrections needed | Lab 3 simple BMI regression and Lab 4 multiple BMI regression exist. Lab 4 loses ordinal factor definitions through CSV and treats category codes as linear numeric predictors. Diagnostics and interpretations are incomplete. |
| Other model-related slides | Partial | Distribution fits, t-tests, proportion tests, chi-square and one-way ANOVA exist. Some test implementations need repair; paired t-test, RBD and Latin Square are only planned. |
| Conclusion | Missing as a deliverable | No consolidated numerical findings, limitations discussion, aim-linked conclusion, PPT or mini thesis exists in the checkout. |

A large correlation heatmap, machine-learning algorithms, and a predictive diabetes model are **not explicitly required** by the supplied list. Add them only if they answer the stated aim. Completion of the existing methods and interpretation takes priority.

## 2. In-depth audit of the R exercises

### Lab 0 — acquisition and reproducibility

Evidence: [00_setup.R](C:/Users/yasha/Documents/probability_lab/Lab00_Setup/00_setup.R:16).

What works in principle: fixed seed 101, a 3,000-person random sample, a shared sample export, and package setup.

Gaps and decisions:

1. The script requires `diabetes_012_health_indicators_BRFSS2015.csv`; the original plan tells users to download the binary file instead. A fresh clone cannot run without the specified raw file. Provide an exact acquisition instruction and checksum/version record; do not silently switch variants.
2. The expected file structure is **21 predictors plus one target**, normally 22 columns before the new binary label and 23 after retaining both targets. The plan says 21 total variables and Lab 0's comment incorrectly suggests the binary variant has one fewer column. Validate the real CSV rather than trusting comments.
3. `Diabetes_012 > 0` combines **prediabetes and diabetes**. This is compatible with UCI's binary definition, but the scripts repeatedly call it simply “diabetes prevalence.” Either name it “prediabetes-or-diabetes status” throughout, or use `Diabetes_012 == 2` for a diabetes-only question and record the change. The existing combined label is not automatically an error; its interpretation is the issue. [UCI variable definitions](https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators).
4. The 253,680-row derivative is not the complete original CDC survey. The original 2015 survey has 441,456 records and uses survey weighting. Document the derivative's preprocessing and avoid calling unweighted sample proportions national prevalence estimates. The scripts use ordinary unweighted procedures. [CDC 2015 data and methodology](https://www.cdc.gov/brfss/annual_data/annual_2015.html).
5. Record full-data and sample class proportions, group sizes, sampling rationale, R/package versions and sampled source-row identifiers. A seed alone does not document input version or sample membership.
6. Setup installs optional packages and loads Phase 2 datasets before those exercises exist. Separate package installation from normal analysis and avoid making the BRFSS pipeline depend on unused supplements.

### Lab 1 — typing is not yet comprehensive cleaning

Evidence: [01_data_types.R](C:/Users/yasha/Documents/probability_lab/Lab01_Data_Types/01_data_types.R:21).

The named lookup for the type table avoids relying on the input column order. Binary levels and ordinal factors are explicitly defined in memory. However:

- The type table calls `Diabetes_012` a “count (12-class label pre-binarize).” It is a three-category diagnostic status, not a count. Correct its description and model handling.
- The text log shows structure/classes **before** recoding; it does not verify the exported analysis types.
- Only missing-value counts are checked. There are no required-column, allowed-code, day-range, positive-BMI or non-finite checks, and no action on detected problems.
- Converting invalid binary codes to factors can introduce new NAs after the recorded missingness check. Validate codes before conversion and repeat checks afterward.
- CSV does not preserve factor levels or ordered-factor metadata. Later `read.csv()` calls undo most typing; Lab 4 is directly affected. Use a shared loader with an explicit schema, or store analysis data as RDS and keep CSV for exchange. Merely switching to RDS is not enough: deliberately choose the model contrasts for ordinal predictors.
- Summarize duplicate rows, but do not automatically delete identical responses: separate survey participants can have identical observed attributes, and the exported features do not establish person identity.
- Retain raw data and log every exclusion/imputation rule and the resulting sample size. “Clean” currently mostly means “recoded.”

### Lab 2 — descriptive statistics and plots

Evidence: [02_summary_stats.R](C:/Users/yasha/Documents/probability_lab/Lab02_Summary_Stats/02_summary_stats.R:11).

The script covers mean/median/quartiles/min/max through `summary()`, SD, two categorical frequency tables, a target proportion table, and five plot types. This is useful exercise coverage.

Add a machine-readable table with valid n, missing n, mean, median, SD, variance, quartiles and IQR for BMI/MentHlth/PhysHlth. Add class-specific BMI summaries and frequencies for predictors actually discussed. `sd()` and summaries need a defined missing-value policy, rather than assuming data are complete.

Replace or supplement the smooth PhysHlth density with a count/proportion plot over 0–30 days: smoothing a discrete bounded variable obscures its zeros and boundary mass. Use an education codebook and label BMI units. A boxplot alone does not constitute outlier investigation or removal. Ensure each chosen slide chart answers a question and includes a numerical interpretation.

### Lab 3 — correlation and simple regression

Evidence: [03_correlation_regression.R](C:/Users/yasha/Documents/probability_lab/Lab03_Correlation_Regression/03_correlation_regression.R:11).

Pearson's r, `BMI ~ PhysHlth`, the model summary and a fitted-line plot exist. No confidence interval for r, residual analysis, influence assessment, sensitivity analysis, or written equation/interpretation exists.

Keep Pearson correlation for the exercise. Add Spearman correlation as a sensitivity check for skewed variables and extremes; use the same documented analysis rows for comparisons. A small correlation/covariance table for BMI, MentHlth and PhysHlth can support the requested slide. Do not treat every ordinal/binary column as a continuous measure in a blanket Pearson matrix.

Interpret PhysHlth as days, the slope in BMI units per day, and R² as variation in **BMI** accounted for. Correlation does not establish causation. Report uncertainty and compare fits before/after the agreed outlier treatment. Show the line on the true integer x values; if using jitter, keep it small and avoid implying negative days.

### Lab 4 — multiple regression

Evidence: [04_multiple_regression.R](C:/Users/yasha/Documents/probability_lab/Lab04_Multiple_Regression/04_multiple_regression.R:5).

The formula, coefficient summary, R²/adjusted R² and residuals-versus-fitted plot exist. After CSV import, Age, Income and Education are numeric codes. Their coefficients therefore assume constant increments between category codes; Age is not measured in years and Income is not measured in currency. This is a substantive modelling assumption, not a harmless formatting problem.

Explicitly encode them as categorical factors with stated reference groups, or justify and test an ordinal-score model. Ordered factors in R normally use polynomial contrasts, so blindly restoring them also changes coefficient interpretation. PhysActivity's numeric 0/1 coding is acceptable for a two-level contrast; Smoker's character labels will be treated categorically by the model, but its reference level should be explicit.

Add residual Q-Q and scale-location plots, leverage/Cook's distance, collinearity checks and coefficient confidence intervals. Use robust uncertainty or an appropriate alternative if diagnostics warrant it. Separate marginal associations from adjusted associations and avoid causal language.

This model predicts BMI, **not diabetes**. Keep that if the aim is BMI/lifestyle associations. If the team promises to model the binary health status, add a separate logistic regression with a defined outcome, adjusted odds ratios and uncertainty. Held-out performance, a simple baseline, class imbalance and calibration matter if making predictive claims; a train/test split is not compulsory for every explanatory lab model.

### Lab 5 — binomial distribution fitting

Evidence: [05_binomial_fitting.R](C:/Users/yasha/Documents/probability_lab/Lab05_Binomial_Fitting/05_binomial_fitting.R:8).

Counting status-positive respondents in blocks of 10 and plotting fitted binomial frequencies is a valid teaching demonstration if block formation and the approximate independent/common-probability assumptions are explained. The blocks are artificial groupings of survey records, not natural populations or repeated patient observations.

The current goodness-of-fit p-value should not be used as final evidence:

- With 300 blocks, at least one endpoint's expected count is at most 0.293, regardless of the fitted p. Other tail cells can also be sparse. This is a mathematical finding, not a result computed from the missing dataset.
- The fitted p is estimated from the same observations. Base `chisq.test()` treats supplied probabilities as specified and uses `k - 1` degrees of freedom; it does not adjust for an estimated p. [R source](https://raw.githubusercontent.com/wch/r-source/trunk/src/library/stats/R/chisq.test.R).
- A classroom pooled-bin calculation generally accounts for one fitted parameter (`k - 1 - 1` degrees of freedom), but parameter estimation and bin pooling must be handled consistently. A parametric bootstrap that repeats estimation and the chosen statistic is a safer way to calibrate the fitted-model test. Simply setting `simulate.p.value=TRUE` leaves the supplied probabilities fixed and does not implement that bootstrap. [NIST goodness-of-fit guidance](https://www.itl.nist.gov/div898/handbook/eda/section3/eda35f.htm), [R simulation behavior](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/chisq.test.html).
- If filtering changes n, the last block can have fewer than 10 respondents. Explicitly handle incomplete blocks and report the number excluded from this demonstration.

Export observed and expected frequencies, the pooling map, fitted p, effective block count, test method and a qualified conclusion. A good fit would not prove that individual risk is homogeneous.

### Lab 6 — normal and Poisson fits

Evidence: [06_normal_poisson_fitting.R](C:/Users/yasha/Documents/probability_lab/Lab06_Normal_Poisson_Fitting/06_normal_poisson_fitting.R:17).

The BMI histogram/normal overlay, Q-Q plot and seeded 500-person Shapiro-Wilk check are implemented. The 500-person choice is not necessary solely because of the function's 5,000-person ceiling when n is 3,000. Explain the sample or use all eligible rows. A significant normality test does not by itself invalidate every mean-based analysis; examine residuals and group distributions for the relevant models.

For PhysHlth, the observed/expected chart and mean/variance are useful, but:

- Days of poor health in a 30-day window have bounded support. Ordinary Poisson support is unbounded, and zeros, rounding/heaping and the 30-day endpoint need inspection. The Poisson exercise can legitimately demonstrate an inadequate fit.
- The test normalizes probabilities on 0–30, effectively testing a conditional/truncated distribution, while the chart uses ordinary unnormalized probabilities. Make the statistical hypothesis and displayed expectations consistent. For an ordinary Poisson test include the upper tail, usually pooled into a final bin; if testing a truncated model, estimate and label it accordingly.
- Sparse expected cells and fitting lambda from the same data require the same goodness-of-fit repairs as Lab 5.
- The text prints that variance is much larger than mean without checking the actual ratio. Compute and report dispersion (`variance/mean`, when mean > 0); make conclusions conditional on the result.

A negative binomial or other bounded/zero-aware alternative is an optional extension if explaining model inadequacy, not a prerequisite for finishing the course exercise.

### Lab 7 — one-sample tests

Evidence: [07_onesample_tests.R](C:/Users/yasha/Documents/probability_lab/Lab07_OneSample_Tests/07_onesample_tests.R:10).

Two-sided one-sample t and proportion tests are present, and their hypotheses are printed. BMI=27 and proportion=11% have no documented source or substantive rationale. Label them hypothetical classroom benchmarks unless a comparable reference is found. In particular, a diabetes-only benchmark should not be applied to the combined prediabetes-or-diabetes target without justification.

Report estimate, reference, difference, confidence interval, test statistic and p-value. `prop.test()` prints a Pearson chi-square statistic; do not label its printed statistic z. Interpret inference as an unweighted exercise on this dataset, with the survey-design limitation described above. [R proportion-test documentation](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/prop.test.html).

### Lab 8 — two-sample comparisons

Evidence: [08_twosample_tests.R](C:/Users/yasha/Documents/probability_lab/Lab08_TwoSample_Tests/08_twosample_tests.R:18).

BMI-by-sex Welch t-test and two comparison charts exist. Welch's unequal-variance test is a sensible default; add group n/means/SDs, the difference and its CI, distribution checks and practical interpretation.

**The proportion comparison currently reverses the event being reported.** The table columns are `No`, then `Yes`, but `prop.test(tab)` treats the first column as successes. It tests the proportion without the condition while the heading and chart describe the positive condition. For a two-sided equality test, complementing both proportions leaves the p-value unchanged, but estimates and the CI direction do not describe the advertised event. Use explicit positive counts, e.g. `prop.test(x = tab[, "Yes"], n = rowSums(tab))`, and state the group order for the difference. [R success-column convention](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/prop.test.html).

“Smoker” in this source means ever having smoked at least 100 cigarettes, not necessarily current smoking. Use the codebook wording and avoid causal conclusions from this unadjusted comparison. [UCI codebook](https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators).

### Lab 9 — independent and paired t-tests

Evidence: [09_independent_ttest.R](C:/Users/yasha/Documents/probability_lab/Lab09_Paired_TTest/09_independent_ttest.R:5).

The independent PhysHlth-by-sex Welch test exists. Inspect the bounded/skewed distributions and group sizes, report the mean difference/CI and consider a suitable sensitivity analysis.

The paired test is expressly deferred; having a folder named `Lab09_Paired_TTest` does not implement it. Add genuine pre/post data using the planned `MASS::anorexia` supplement. Define change as Postwt minus Prewt, inspect the **differences**, show paired lines and state treatment group and n. A within-treatment example is easier to interpret than pooling different treatment groups and implying one treatment effect. Do not manufacture pairs in BRFSS. Verify the dataset description from its package documentation when implementing it.

### Lab 10 — chi-square tests

Evidence: [10_chisquare_tests.R](C:/Users/yasha/Documents/probability_lab/Lab10_ChiSquare_Tests/10_chisquare_tests.R:14).

The age goodness-of-fit test and two contingency tests exist. `chisq.test(age_tab)` tests **exactly equal category probabilities**, not “uniform-ish.” That is a hypothetical null, not evidence of a representative age distribution; age bands are not all equal widths. State it accurately or justify a reference distribution. [R default null](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/chisq.test.html).

Export expected-cell tables, explicitly check sparse cells, and use an appropriate exact/simulated procedure when warranted. Add an association effect size (e.g. Cramer's V) and positive-condition group proportions; small p-values alone do not quantify strength. These contingency procedures do not need the fitted-univariate-distribution df adjustment discussed in Labs 5–6.

Only the HighBP plot is generated here, but the smoking chart exists in Lab 8 and can be reused. Make that cross-reference explicit. Label the outcome consistently and distinguish unadjusted association from independent risk factors.

### Lab 11 — one-way ANOVA and the CRD label

Evidence: [11_anova_crd.R](C:/Users/yasha/Documents/probability_lab/Lab11_ANOVA_CRD/11_anova_crd.R:9).

One-way ANOVA, Tukey HSD and the education boxplot exist. This demonstrates the one-way ANOVA computation, but BRFSS respondents were **not randomly assigned to education levels**. Describe it as observational one-way ANOVA; it is not evidence of an actual completely randomized experiment or an education treatment effect.

Add group sizes/means/SDs, residual checks and a variance-homogeneity check. Sparse groups or unequal variances may call for Welch ANOVA and compatible follow-up comparisons, rather than blindly keeping standard Tukey. Report effect size and intervals, and explain which pairwise results survive the multiple-comparison procedure.

If the faculty requires an actual CRD dataset, use an appropriately documented experimental supplement; do not relabel observational groups as randomized treatments.

### Missing supplements and consolidation

The paired half of Lab 9, Lab 12 RBD, Lab 13 Latin Square and Lab 14 consolidation exist only in prose. These matter for the team's stated goal of demonstrating every lab concept, subject to checking the actual course handout.

- **RBD:** The planned `npk` dataset is a blocked factorial experiment with a confounded NPK interaction, not a simple complete block containing every treatment combination. The proposed additive formula can demonstrate adjustment for blocks, but its simplification must be explained. If the exercise strictly requires a textbook RCBD, choose a dataset whose design actually matches it. [Official npk documentation](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/npk.html).
- **Latin Square:** The planned `goulden.latin` dataset and row/column/treatment formula agree with its package documentation. Verify the five treatments occur once per row and column, show the layout, fit the additive model and discuss its assumptions. [Package author's documentation](https://kwstat.github.io/agridat/reference/goulden.latin.html).
- **Consolidation:** There is no assembled findings table or report. A master runner can source the individual exercises while keeping each exercise file separately reviewable. Combining all code into one monolithic script is unnecessary for execution unless the faculty explicitly requires that submission format.

## 3. Outlier analysis and removal: proposed design

Add a separate preparation exercise, such as `Lab01B_Outlier_Analysis/01b_outlier_analysis.R`, between Lab 1 and all downstream analysis. Keep the original sample unchanged.

1. **Validate first.** Check allowed category values, day counts in 0–30, positive and finite BMI, missingness, and parsing. A range error and an unusually high valid BMI are different problems.
2. **Flag BMI extremes transparently.** Compute Q1, Q3, IQR and 1.5×IQR fences on validated BMI. Export row identifiers, BMI, diagnostic status and the reason for each flag. Inspect flagged values and group composition. Add a histogram/boxplot with fences and an outlier-count table.
3. **Avoid automatic IQR filtering for all columns.** Binary and ordinal codes should be validated by their codebook. In zero-heavy MentHlth/PhysHlth, IQR can be zero and flag every positive day count. Such observations are not automatically errors.
4. **Document the removal policy.** Exclude verifiable invalid records according to fixed rules; retain valid extremes in the primary analysis unless a substantive exclusion is justified. Produce a separate, explicitly named BMI-IQR-filtered dataset to demonstrate the requested removal operation and measure sensitivity. State that this restriction changes the analysed population and may remove genuine high-BMI respondents.
5. **Keep an exclusion ledger.** Record original n, reason-specific and combined exclusions, final n, missingness and class proportions. Avoid double-counting a record flagged by several rules. Do not overwrite the raw or original typed data.
6. **Compare before and after.** Show BMI mean/SD/variance, correlation, key regression coefficients/CI and model fit using validated full versus filtered data. If claims change, explain why. Label every subsequent table with its dataset and n.
7. **Distinguish influence.** Use Cook's distance/leverage for regression sensitivity. A flagged BMI observation need not be influential, and an influential observation need not be an erroneous record.

Completion evidence: an auditable flag/removal CSV, two explicitly identified analysis datasets, before/after plots and one sensitivity-results table. No fabricated outlier counts or a rule selected to achieve a preferred p-value.

## 4. Rubric assessment

This is a readiness assessment, **not a predicted mark**. The actual data, results and final artifacts have not been evaluated.

| Rubric category | Evidence already present | What currently threatens a strong evaluation | Required deliverable |
|---|---|---|---|
| Collection of Data — 5 | Named public data source and reproducible sample code | Raw file absent; exact variant and provenance incomplete; misleading outcome/count descriptions; no sample-quality evidence | Source/codebook reference, file hash/version, correct dictionary, inclusion flow and full-versus-sample counts |
| Analysis — 5 | Broad range of exercise scripts and plot commands | Fresh-clone execution failures; no outputs; missing outlier work; factor/type problem; defective GOF calibration; incomplete diagnostics | Successful run, reproducible result tables/plots, corrected tests and documented assumptions |
| Review — 5 | Planned experiment explanations | No actual findings tied to aim, effect-size discussion, sensitivity, limitations or consolidated conclusion | Finding-to-question table, practical interpretations, uncertainty and limitations |
| Final Submission — 5 | README, running guide and report outline | No PPT/mini thesis, captions, assembled references or verified presentation layout | Consistent slide deck and mini thesis with title, objectives, methods, findings, conclusion, references and code appendix |

## 5. Prioritized completion plan

### Priority 0 — make the current work reproducible and correct

Do this before using any existing p-values in slides.

- Obtain and verify the exact 3-class CSV; record provenance and checksum. Correct conflicting README/plan/setup counts and names.
- Create required output directories in the scripts or common setup. Add helpful missing-file/package errors and reliable root-relative paths.
- Add a shared data dictionary/loader and schema checks. Preserve intended types across exercises; explicitly choose factor references and ordinal treatment.
- Decide the primary health outcome and state a precise aim. Fix Lab 8 success counts and source or label the Lab 7 benchmarks.
- Repair Labs 5–6 sparse cells, fitted-parameter calibration and Poisson support; label Lab 10's null and Lab 11's observational design accurately.

**Done when:** from a clean R session and verified input, a runner generates all existing lab outputs without directory/type errors; all warnings are reviewed; event definitions, n and test methods are explicit. Preserve a run log and `sessionInfo()`. Statistical warnings must be resolved or explained, not suppressed.

### Priority 1 — fill the required presentation gaps

- Implement the outlier workflow above and route downstream exercises through the shared loader.
- Add variance/covariance summaries, selected correlation analysis and group descriptions.
- Add regression diagnostics, uncertainty and sensitivity comparisons; add an outcome model only if the aim requires it.
- Export a common results table with question, dataset, n, method, estimate/effect size, CI, p-value, assumption caveat and interpretation.

**Done when:** every required presentation topic points to an actual table, chart or documented decision, including demonstrable removal and before/after comparison.

### Priority 2 — finish the course-concept coverage

- Cross-check the repository mapping against the actual faculty exercise list.
- Complete a genuine paired t-test supplement, the correctly described blocked-design exercise, and the Latin Square exercise.
- Present them as separate methodological demonstrations. Do not combine unrelated datasets into a common health conclusion.

**Done when:** each required course concept has a script, stated design/assumptions, output and interpretation. Distinguish observational ANOVA from genuine randomization.

### Priority 3 — assemble and verify the submission

- Build slides and mini thesis from the same approved results table so numbers and sample definitions agree.
- Use informative captions, sources, units and limitations; place full exercise outputs/code in an appendix.
- Verify chart readability, slide/report consistency, equation/coefficient interpretation and that every conclusion is traceable to a result.
- Rehearse why each method was chosen, why valid extremes were retained or filtered, what R² measures, and why association does not prove causation.

**Done when:** the PPT and mini thesis are readable, internally consistent, referenced and accompanied by reproducible code and data-acquisition instructions.

### Suggested review milestones

- **By 6 October 2026:** resolve Priority 0, establish dataset provenance and aim, and show the outlier method plus available descriptive plots. Clearly identify supplements that are still pending.
- **Between 6 and 13 October:** complete Priority 1 and the confirmed course supplements, generate verified outputs, and assemble the narrative.
- **By 13 October 2026:** have the complete slides/mini thesis, consolidated findings and limitations ready for review, subject to the faculty's exact submission schedule.

These are proposed milestones based on the attached dates, not a claim about any additional faculty deadline. If time is limited, accurate interpretation and reproducibility take precedence over optional extra models.

## 6. Draft presentation sequence

Use the following as an outline, not a requirement to fit one slide per exercise. Adjust length to the allotted presentation time; split or combine slides where needed.

| Slide | Purpose | Evidence to include |
|---|---|---|
| 1. Title and aim | State the specific investigation | Team/course, primary question, descriptive/associational versus predictive scope |
| 2. About the dataset | Establish relevance and provenance | Original CDC source, chosen derivative, year, exact file, row counts and sampling |
| 3. Variables and outcome | Make codes interpretable | Compact dictionary, 0/1/2 target meanings, combined-label decision, BMI/day units |
| 4. Data preparation | Show quality and reproducibility | Import → validation → typing → sample/analysis flow with n at each stage |
| 5. Outlier analysis | Explain what was flagged | BMI fences/plot, flag counts and valid-extreme versus invalid-record distinction |
| 6. Outlier removal and sensitivity | Satisfy removal requirement transparently | Removal rule/ledger, retained and filtered n, before/after summaries and class proportions |
| 7. Graphical analysis | Describe the sample | BMI distribution, status proportions and relevant group plot; caption each finding |
| 8. Correlation and variances | Quantify association and spread | Mean/variance/covariance table, selected correlations with uncertainty/sensitivity |
| 9. Simple regression | Explain the Lab 3 model | Equation, slope CI, R², scatter/line and interpretation of the BMI response |
| 10. Multiple regression | Show adjusted associations | Chosen coding/references, readable coefficient plot/table, adjusted R² and key effects |
| 11. Model diagnostics | Demonstrate critical assessment | Residual/influence evidence, sensitivity findings and relevant model limitations |
| 12. Distribution fitting | Cover probability-model concepts | Binomial and normal evidence, Poisson fit/dispersion and appropriately calibrated GOF |
| 13. Hypothesis tests and categorical associations | Cover core inference | Compact selected test/effect/CI table; correct event definitions and benchmark rationale |
| 14. ANOVA | Compare multiple groups | Education group means/CI, ANOVA/effect size, justified follow-up and observational caveat |
| 15. Paired and design supplements | Show missing course concepts once completed | Pre/post pairing; blocked-design evidence; Latin Square layout, each with its own dataset |
| 16. Consolidated findings and conclusion | Answer the aim | Three to five verified findings, practical magnitude, uncertainty, limitations and next step |
| References and appendix | Support questions and full course coverage | Sources/codebook, all-exercise mapping, full diagnostics/output tables, code and runtime record |

If adding a diabetes-status logistic model, place it after the BMI regression material and state its distinct response. Do not present BMI R² as diabetes classification accuracy. Optional predictive metrics should use held-out data and a baseline.

For the mini thesis, use the same progression in prose, with a fuller methods section and an appendix mapping each faculty exercise to its script and output. Each result paragraph should state the question, numerical result, practical meaning, uncertainty and limitation. Do not write the conclusion until the outputs have been generated and checked.

## 7. Verification checklist for the implementation stage

- [ ] Exact raw file available; schema, source and checksum recorded.
- [ ] Dataset dimensions measured rather than copied from contradictory comments.
- [ ] Missing/invalid values handled and row counts reconcile.
- [ ] Shared types and factor references verified after loading.
- [ ] Outcome definition and group/event labels agree across all results.
- [ ] Output directories and runner work from a fresh clone/session.
- [ ] Outlier flags, exclusions and before/after comparisons saved.
- [ ] Correlation and variance tables generated for appropriate variables.
- [ ] GOF expected counts, support and parameter estimation accounted for.
- [ ] Test/model assumptions checked; effect sizes and CIs reported.
- [ ] All faculty-required exercises confirmed and implemented.
- [ ] Each slide conclusion traceable to a verified result.
- [ ] PPT and mini thesis use the same numbers, labels, sources and limitations.

At this audit stage, these boxes deliberately remain unchecked: successful statistical execution and finished submission artifacts have not been established.
