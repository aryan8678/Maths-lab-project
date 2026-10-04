## 1. Statistical analysis of diabetes and lifestyle indicators

BMAT202P Probability and Statistics Lab
CDC BRFSS 2015 with experimental design supplements



Speaker notes: The main investigation uses a random working sample of the processed BRFSS dataset. Separate published experiments demonstrate statistical designs absent from the cross-sectional survey. Suggested timing: 20 seconds.

## 2. Aim and course coverage

Aim: describe BMI and health indicators, examine their associations, and apply the statistical methods prescribed in BMAT202P.
Questions: How does BMI vary across health groups? How much BMI variation do the regression models explain? Which probability models fit the observations?
The course also requires independent and paired tests, chi-square tests, CRD, RBD and Latin Square ANOVA.
The health study is observational. The design supplements use separate experimental data.



Speaker notes: Explain that the project aims to demonstrate statistical reasoning rather than diagnose a person. Every one of the 11 indicative experiments in the supplied syllabus has a matching R exercise. Outlier analysis and removal are additional presentation requirements. Suggested timing: 40 seconds.

## 3. Dataset source and working sample

The derivative contains 253,680 respondents, 21 predictors and one three-class target.
We sampled 3,000 records without replacement using seed 101.
Combined positive status is 15.63% in the sample and 15.76% in the full derivative.

These are unweighted dataset proportions. They do not estimate national prevalence.

Speaker notes: Sources: https://www.cdc.gov/brfss/annual_data/annual_2015.html
https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset
https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators
The CDC original has 441,456 records. The 253,680-row file is a processed derivative. The exact CSV has 22 raw columns. Sample classes: 2,531 no diabetes, 48 prediabetes, 421 diabetes. The combined label includes 469 positive respondents. Suggested timing: 45 seconds.

## 4. Variable definitions

The codebook distinguishes measurements, counts and coded categories.



Speaker notes: Source: https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators. See Lab01_Data_Types/output/variable_dictionary.csv. Age is a band, not years. Income is a band, not an exact salary. Smoker does not necessarily mean currently smoking. Factors preserve the intended types in RDS. Suggested timing: 40 seconds.

## 5. Data preparation

Validation checks column names, allowed codes, missing values and measurement ranges.
No invalid or missing records occurred in the 3,000-person working sample.
We preserve source-row identifiers and factor types in RDS. Identical feature profiles can belong to different people, so we retain them.

The original sample remains available alongside the separate BMI-filtered dataset.

Speaker notes: Source: Labs 0, 1 and 1B. The sample has 13 repeated feature profiles, which do not establish duplicate respondents. Acquisition records a SHA-256 checksum. RDS retains categorical levels. Each script uses common helpers and a master runner. Suggested timing: 45 seconds.

## 6. BMI outlier analysis

Q1 = 24.0 and Q3 = 31.0, giving IQR = 7.0.
The 1.5 IQR fences are 13.5 and 41.5.
114 respondents (3.8%) fall outside the fences.

An unusual but valid BMI is not automatically a recording error.

Speaker notes: Source: Lab01B_Outlier_Analysis. Formula: lower fence = Q1 - 1.5 IQR, upper fence = Q3 + 1.5 IQR. Observed BMI range 15-89. No low-side flags occurred. The ledger saves source row, BMI and health status. We do not apply IQR removal to binary or ordinal codes. Suggested timing: 45 seconds.

## 7. Outlier removal and its effect

We removed the 114 BMI flags only in a sensitivity dataset. The primary analysis retains all valid records.

Filtering lowers both average BMI and the positive-status proportion. It changes the sample composition.

Speaker notes: Source: Lab01B_Outlier_Analysis/output/before_after.csv. SD changes from 6.35 to 4.96. Simple slope changes from 0.0749 to 0.0327. Simple R² falls from 1.03% to 0.31%. This is why automatic removal could bias the health story. Suggested timing: 55 seconds.

## 8. Summary statistics and variance

BMI has a right tail. Poor-health day counts have median zero and substantial variation.

Variance measures squared spread. Standard deviation returns that spread to the original units.

Speaker notes: Source: Lab02_Summary_Stats/output/numeric_summary.csv. All variables use n=3000. BMI variance units are (kg/m²)², and day-count variance units are days². Sample variance uses n-1. The histogram uses bins of width 2 BMI units. Suggested timing: 40 seconds.

## 9. Graphical representations of categories

Bar charts compare education counts. A pie chart demonstrates the course requirement for categorical proportions.

Group sizes matter. The no-school education category contains only two respondents.

Speaker notes: Source: Lab02_Summary_Stats frequencies and Lab11 education_groups.csv. The smallest education group is unsuitable for precise standalone conclusions. Pie, bar, histogram, boxplot and density collectively demonstrate the required range of graphical representations. Suggested timing: 30 seconds.

## 10. BMI across health-status groups

Mean BMI is 27.72 for no diabetes, 32.85 for prediabetes and 31.98 for diabetes. The distributions overlap.

The prediabetes group has only 48 respondents. Group differences describe associations.

Speaker notes: Source: Lab02_Summary_Stats/output/bmi_by_status.csv. Sample counts are 2531,48,421. Mean CIs respectively 27.49-27.95,30.71-35.00,31.29-32.68. A boxplot shows median, quartiles, whiskers and potential extremes; a density plot shows shape. No causal claim is justified. Suggested timing: 40 seconds.

## 11. Poor physical health days

62.9% report zero poor-health days.
7.4% report all 30 days.
The mean is 4.15 days, while variance is 74.24 days².

The spikes at zero and 30 are important features of this bounded count.

Speaker notes: Source: Lab02 and Lab06. The count plot preserves discrete day values rather than smoothing beyond the 0-30 range. PhysHlth denotes self-reported poor physical health in the previous 30 days. Suggested timing: 30 seconds.

## 12. Correlation and simple regression

Pearson r = 0.102, with 95% CI 0.066 to 0.137.
BMI = 28.09 + 0.0749 × PhysHlth.

A significant association explains only 1.03% of BMI variation.

Speaker notes: Source: Lab03 coefficients and metrics. PhysHlth units are days. One extra poor-health day is associated with about 0.075 BMI units on average in the fitted line. Pearson measures linear association, Spearman compares ranks. The confidence intervals use ordinary unweighted assumptions. The covariance and full three-variable correlation tables are in the report. Suggested timing: 55 seconds.

## 13. Multiple linear regression

Response: BMI. Predictors: age band, physical activity, income band, education and ever-smoking.
R² = 6.81%. Adjusted R² = 5.99%.
Joint tests compare each categorical predictor while keeping the others in the model.

The model leaves most BMI variation unexplained. Statistical adjustment does not establish causation.

Speaker notes: Source: Lab04 joint_predictor_tests.csv. Formula BMI ~ Age + PhysActivity + Income + Education + Smoker. Reference categories age50-54, income35-50k, high school, inactivity and never100 cigarettes. Full coefficients and CIs are in the report appendix/CSV. Smoking is not associated with BMI after this adjustment (p=.786), which addresses a different outcome from the status comparison. Adjusted R² penalizes model size. No classification accuracy is claimed. Suggested timing: 55 seconds.

## 14. Regression diagnostics and sensitivity

Residual plots assess linear form and changing spread. The Q-Q plot checks residual shape.
Leverage and Cook’s distance identify observations that may influence the fitted coefficients.
After BMI filtering, adjusted R² changes from 5.99% to 4.89%.

Valid extreme observations affect the fit. Model conclusions remain cautious and descriptive.

Speaker notes: Source: Lab04 diagnostics, influence.csv and filtered coefficients. Cook threshold4/n flags140 observations for review, not automatic deletion. The design-column VIF table checks dummy-column collinearity and depends on reference coding. The simple model diagnostic sheet and individual residual plot appear in the full figure atlas. Suggested timing: 45 seconds.

## 15. Fitting the normal distribution

The fitted normal model uses mean 28.40 and SD 6.35.
Shapiro-Wilk gives W = 0.897 and p < 0.001 for all 3,000 BMI values.

The right tail departs from a normal distribution. Model residuals need their own checks.

Speaker notes: Source: Lab06. A normality test on the raw response is not a blanket decision about all t-tests or regressions. We assess each model and use Welch comparisons where appropriate. Suggested timing: 40 seconds.

## 16. Fitting the binomial distribution

We count combined-positive statuses in 300 artificial blocks of ten.
The individual sample proportion is 0.1563.
After pooling and fitting to bin counts, χ² = 0.287, df = 3, p = 0.962.

The pooled test does not reject the binomial teaching model. It does not prove identical individual risk.

Speaker notes: Source: Lab05. GOF guidance: https://www.itl.nist.gov/div898/handbook/eda/section3/eda35f.htm. The five pooled bins have minimum expected frequency16.65. One fitted parameter yields df5-1-1=3. Grouped fitted p is .1550. Original sparse endpoint cells would invalidate the unpooled approximation. Blocks are arbitrary; independence and common probability are approximations. Suggested timing: 45 seconds.

## 17. Fitting the Poisson distribution

The ordinary Poisson mean estimate is λ = 4.15.
Variance/mean = 17.88, far above the Poisson value of one.
The pooled test refits λ = 1.80 and gives χ² = 41781.7, df = 6, p < 0.001.

The Poisson model poorly describes these bounded, zero-heavy day counts.

Speaker notes: Source: Lab06. The ordinary Poisson upper tail >30 is included. Grouped-bin maximum likelihood gives lambda1.797, different from raw mean4.152 because of pooling and severe misfit. The chart overlays ordinary Poisson at the raw mean, while the inferential statistic uses the explicitly documented grouped fit. Both support the same inadequacy conclusion. Minimum fitted expected bin7.65. p underflows to zero numerically, so report p<.001 rather than p=0. Suggested timing: 45 seconds.

## 18. One-sample hypothesis tests

We use two-sided alternatives and α = 0.05. The values 27 and 11% are hypothetical classroom benchmarks.

Both teaching nulls are rejected. The 11% value is not a sourced national prevalence claim.

Speaker notes: Source: Lab07. BMI test df2999. Proportion test df1 with continuity correction. State H0 and H1, compare p to alpha, and interpret the effect/CI. The proportion outcome includes prediabetes. These unweighted analyses demonstrate syllabus methods. Suggested timing: 40 seconds.

## 19. Two-sample and independent comparisons

Female minus male mean BMI is −0.65, with 95% CI −1.10 to −0.20 (p = 0.004).
Combined-positive proportions are 14.09% for never-smoking and 17.36% for ever-smoking (p = 0.016).

The independent PhysHlth test finds 1.25 more poor-health days for females, CI 0.63 to 1.86.

Speaker notes: Source: Labs08 and09a. BMI uses Welch t, p .004368. The explicit positive-event proportion difference never minus ever is -3.27 percentage points, CI -5.95 to -.59. PhysHlth female minusmale Welch p .0000669. Smoker means ever100 cigarettes. These are unadjusted observational comparisons. Suggested timing: 50 seconds.

## 20. Paired t-test supplement

The CBT group in MASS::anorexia has 29 paired before/after weights.
Mean change is +3.01 lb, with 95% CI +0.23 to +5.79 lb. The paired t-test gives p = 0.035.
The signed-rank sensitivity test gives p = 0.064; the evidence depends on the method.

Pairing compares each patient with herself. The difference distribution is non-normal, so interpretation is cautious.

Speaker notes: Source: https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/anorexia.html. Lab09b. t2.216,df28. Before mean82.69lb and after85.70lb. Shapiro p .00795 for differences. Signed-rank sensitivity p 0.0645 tests a related distributional hypothesis rather than the same mean. An uncontrolled within-group change does not by itself demonstrate treatment efficacy. Suggested timing: 45 seconds.

## 21. Chi-square tests and categorical association

Combined-positive status is 6.93% among respondents without high BP and 27.06% among those with high BP.

HighBP has the stronger sample association. The age test uses a hypothetical equal-probability null.

Speaker notes: Source: Lab10. All contingency expected counts exceed5. Pearson contingency tests omit continuity correction, while Lab08 prop.test retains it; small p differences are expected. CramersV measures association strength, not causal impact. Age categories have unequal widths. Suggested timing: 50 seconds.

## 22. One-way ANOVA and CRD

Education-group BMI differs in the sample (F = 14.41). Unequal variances motivate the Welch sensitivity result (p < 0.001).
The separate sulfur experiment is a genuine CRD: 32 plots and seven treatments (F = 3.61, p = 0.010).

The education comparison is observational. The sulfur dataset supports the randomized-design exercise.

Speaker notes: Source: Lab11 and https://kwstat.github.io/agridat/reference/cochran.crd.html. Education eta-squared .02349, about2.35% variation. Fligner variance p .00013, Welch p .000351. No-school n2 makes reference contrasts imprecise. Use separate-variance Holm-adjusted comparisons for interpretation; Tukey remains in course output. CRD controlO has8 replicates and each sulfur treatment4. Tukey finds O minusF12 infection16.875 percentage points, CI3.74-30.01,p .005965. CRD residual normality/variance diagnostics are in the full atlas. Suggested timing: 60 seconds.

## 23. Randomized block design

The rice experiment includes six seeding rates in each of four complete blocks. The additive model separates block and rate effects.

Blocking lowers residual MSE by 44.8%. The rate effect is not significant at α = 0.05.

Speaker notes: Source: https://kwstat.github.io/agridat/reference/gomez.seedrate.html. Gomez and Gomez1984 p26,24 plots. Yieldkg/ha, seedingratekg/ha. No-block MSE200152 versus blocked110558. Rate means highest75kg/ha but non-significant overall result cannot establish an optimum. Additive model assumes no treatment-by-block interaction. This complete-block dataset replaces the original npk proposal. Suggested timing: 50 seconds.

## 24. Latin Square design

Five wheat treatments occur once in every row and every column. The model controls two nuisance factors.

Weekly dusting (C) has the highest mean yield, 13.12, and exceeds each other treatment in Tukey comparisons.

Speaker notes: Source: https://kwstat.github.io/agridat/reference/goulden.latin.html. Goulden1952 p216. A before rains,B after rains,C weekly dusting,D weekly drifting,E untreated. Mean yields6.84,6.46,13.12,7.96,4.92. Source does not specify yield units, so retain source scale. TreatmentF21.03,p .00002366. The additive Latin model assumes no interactions. Layout verifies treatment balance. Diagnostics and treatment boxplot are in the figure atlas. Suggested timing: 50 seconds.

## 25. Findings and conclusion

BMI is higher on average in the prediabetes and diabetes groups, with substantial overlap between respondents.
Poor-health days have a weak positive BMI association. The multiple model explains 6.8% of BMI variation.
Outlier filtering changes estimates and health-status composition. Normal and Poisson fits are inadequate for these observations.
The experimental supplements demonstrate pairing and nuisance-factor control.
Limitations include self-report, historical data, missing survey weights, confounding, sparse subgroups and multiple exploratory tests.

The project answers descriptive and statistical questions. It supports cautious associations and course-method demonstrations.

Speaker notes: Suggested timing: 55 seconds. Answer the aim and distinguish practical magnitude from statistical significance. The RBD rate test is non-significant even though blocks matter. Final sources: https://www.cdc.gov/brfss/annual_data/annual_2015.html
https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset
https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators
https://kwstat.github.io/agridat/reference/cochran.crd.html
https://kwstat.github.io/agridat/reference/gomez.seedrate.html
https://kwstat.github.io/agridat/reference/goulden.latin.html
https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/anorexia.html
https://www.itl.nist.gov/div898/handbook/eda/section3/eda35f.htm
Course source: supplied BMAT202P syllabus PDF, version1.0. Rubric: four categories, five marks each. All reported numbers originate in the saved R outputs.