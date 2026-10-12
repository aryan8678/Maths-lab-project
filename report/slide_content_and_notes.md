## Intro. Diabetes and lifestyle indicators

LABS 1–11: Probability and Statistics Lab

Statistical analysis with R
BMAT202P Probability and Statistics Lab



Speaker notes: Introduce the project and four team members. The main dataset is the processed CDC BRFSS 2015 derivative. Experimental datasets supplement the methods that require genuine pairing or randomized designs. Suggested time: 20 seconds.

## 1. Dataset and aim

LAB 1: Data types, import and export (dataset overview)

Aim: describe health patterns, study BMI relationships and apply the course statistical methods.

469 people (15.63%) report prediabetes or diabetes.

Speaker notes: Secondary data collection: CDC BRFSS 2015, processed by Alex Teboul on Kaggle. Exact derivative: 253680 rows, 22 raw columns (21 predictors plus target). Random sample without replacement, seed101. Combined positive status includes prediabetes OR diabetes:469/3000=15.633%. Original CDC survey441456 records. The derivative omits survey-design weights, so the study supports sample associations rather than national prevalence. Explain source, relevance, size and variables. Suggested time: 65 seconds.

## 2. Data preparation

LAB 1: Data types, import and export

Import → sample → validate → prepare for analysis

Readable labels and correct data types make every later analysis easier.

Speaker notes: Course Experiment1: types, import/export. Labs00/01. We read CSV, select3000 with seed101, inspect schema, missingness and allowed codes/ranges, and convert categories to readable factors. Missing cells0, invalid records0. The sample has13 repeated feature profiles, which do not establish duplicated people. RDS preserves factor levels and CSV provides portable output. Scripts retain source-row lineage. BMI/health days remain numeric, age/income/education are ordered bands but regression uses category contrasts. Suggested time: 50 seconds.

## 3. Outlier analysis and removal

LAB 1 EXTENSION: Data preparation and outlier analysis

Q1 = 24  •  Q3 = 31  •  IQR = 7  •  Q1 − 1.5×IQR to Q3 + 1.5×IQR → 13.5 to 41.5

114 high BMI values (3.8%) were flagged. Removing them lowers the average and spread.

Speaker notes: Lab01B, additional presentation requirement. Fences are Q1−1.5IQR and Q3+1.5IQR.114 observations (3.8%) are high-side flags. The source-row ledger records their BMI/status. Demonstrate actual removal with the2886-row sensitivity dataset and compare mean, variance and status composition. Valid extreme BMI values stay in the primary analysis because being unusual does not establish error. The removal comparison is explicitly a different analysis sample. Suggested time: 80 seconds.

## 4. Summary statistics and graphs

LAB 2: Summary statistics and graphical representations

Mean = average  •  SD = standard deviation  •  Variance = squared spread

BMI has a long right tail. Most people report few poor-health days.

Speaker notes: Course Experiment2, Lab02. The numeric summary uses sample SD/variance (n−1). BMI units kg/m²; variance squared units. Mental/physical days have median0, while means3.256 and4.152 indicate right-skewness. Graphs demonstrate histogram, boxplot, density, education bar and sex pie; physical-day bar and all29 original drawings are in the atlas. The no-school group has2 respondents. Explain bar comparison, pie proportions and the density right tail. Suggested time: 80 seconds.

## 5. Correlation and simple regression

LAB 3: Correlation, simple linear regression and R²

Predicted BMI = 28.09 + 0.0749 × poor physical-health days

r = 0.102: weak positive relation. R² = 1.03%: very little BMI variation is explained.

Speaker notes: Course Experiment3, Lab03. Pearsonr .101606,95%CI .06606–.13689,p<.001; Spearman .107897. Slope .074898,95%CI .048637–.101159. Covariance5.56044 BMI×days measures shared variation; correlation scales it. R² .0103238. A one-day increase is associated with0.075BMI units in the fitted line. Boxplots and means show higher average BMI in prediabetes/diabetes, with overlapping distributions. Prediabetesn48 limits precision. The model estimates BMI associations rather than causal effects. Suggested time: 90 seconds.

## 6. Multiple regression and model checks

LAB 4: Multiple linear regression

Predict BMI using age, activity, income, education and smoking. R² = variation explained.

Age, activity, income and education relate to BMI. The model explains only a small share of variation.

Speaker notes: Course Experiment4, Lab04. BMI response with factor Age/Income/Education, activity and ever100-cigarettes indicator. References age50–54, income35–50k, high school, inactive, never100. R² .068067,adjusted .059917. Joint partialF tests account for other predictors. Smoking BMI coefficient−.0633,CI−.5206 to .3940,p.786. The right-skewed residuals and uneven spread limit the approximation. Cook4/n flags140 for review. Filtering yields adjustedR²4.89%. Full coefficients, confidence intervals and VIFs remain in the report/CSV. No diabetes classification accuracy is claimed. Suggested time: 90 seconds.

## 7. Fitting probability distributions

LAB 5: Binomial fitting     LAB 6: Normal and Poisson fitting

Compare the observed pattern with the pattern each model expects.

A useful analysis explains why a model fits or fails.

Speaker notes: Course Experiments5/6, Labs05/06. Binomial:300 artificial groups of10,rawpositivep .156333; pooled MLE .154999,chi .287105,df3,p .962435,expectedmin16.65. Plot aggregates5–10 into5+ for readability. NormalBMI mean28.398,SD6.351,ShapiroW.896929,p<.001. Poisson rawmeanlambda4.151667,var74.240077,dispersion17.88199,zeros62.9%,30days7.4%. Native chart aggregates full support, including>30. Formal pooled test uses grouped MLElambda1.797448,chi41781.676,df6,p<.001,expectedmin7.65. Ordinary overlay uses rawmean; the two estimation procedures are distinguished in the report. Describe why normal/Poisson fail rather than forcing a good fit. Suggested time: 90 seconds.

## 8. Hypothesis tests and paired measurements

LAB 7: One-sample tests     LAB 8: Two-sample tests     LAB 9: Independent and paired t-tests

At α = 0.05, p < 0.05 supports a difference. Read the size of the change too.

Paired tests compare the same people twice. Independent tests compare different groups.

Speaker notes: Course Experiments7/8/9, Labs07/08/09a/09b. All alternatives two-sided. BMI27 and positive proportion11% are hypothetical classroom benchmarks. Welch BMI differencefemale−male−.6494,CI−1.0958 to−.2030,p.004368; smokerpositive14.087% versus17.361%,difference−3.273pp,CI−5.953 to−.594,p.015765 using continuity correction. PhysHlthfemale−male1.2463days,CI.6343 to1.8584,p<.001. Genuine paired example uses29 CBT patients from MASS anorexia, postminuspre mean3.0069lb,CI.2269 to5.7869,t2.2156,df28,p.0350. Non-normal differences Shapiro.00795 and signed-rank sensitivityp.0645 make this result method-sensitive. A within-group change does not prove treatment efficacy. Patient trajectories are blue and average orange. Suggested time: 110 seconds.

## 9. Chi-square: category patterns and relationships

LAB 10: Chi-square goodness of fit and contingency tables

Goodness of fit checks category counts. Independence tests check whether two categories are related.

Positive status is more closely related to high blood pressure than to ever-smoking in this sample.

Speaker notes: Course Experiment 10. Equal-frequency age GOF is a hypothetical teaching null across 13 unequal-width bands: chi-square 678.1247, df12, p<.001. Status means prediabetes or diabetes. Independence tests use Pearson chi-square without continuity correction: status×HighBP 226.2818, df1, p<.001, Cramer V .27464; status×Smoker 6.0746, df1, p .013714, V .0449985. Expected cells exceed five. No-high-BP positive share 118/1703=6.929%; high-BP 351/1297=27.062%. Never/ever100-cigarette shares 14.087% and17.361%. Compare association magnitudes, not p-values alone. These are observational relationships. Suggested time: 90 seconds.

## 10. ANOVA and experimental designs

LAB 11: ANOVA in completely randomized designs, randomized blocks and Latin Square

ANOVA compares means. CRD has no blocks. RBD controls one factor and Latin Square controls two.

Blocks reduce unexplained error. Weekly dusting (C) has the highest wheat yield in its experiment.

Speaker notes: Course Experiment 11. BMI by education is observational ANOVA, F14.4064,p<.001,eta-square .02349. Unequal variances motivate Welch p .000351 and Holm separate-variance pair comparisons. Genuine Cochran potato CRD:32 plots,7 sulfur treatments,F3.6081,p .010262; control8 replicates,others4 each; Tukey control-minus-F12 difference16.875 percentage points,p .005965. Gomez rice complete-block design:24 plots,6 rates,4 blocks. Block F5.8622,p .007416; rate F2.1678,p .112809. Residual MSE decreases from200152 to110558,44.76%. Goulden wheat Latin Square:5 treatments in5 rows and5 columns. Row p .01328,column p .26343,treatment F21.0321,p .00002366; Cweeklydusting mean13.12 exceeds each other treatment with Tukey adjustment. Yield units unspecified for wheat, kg/ha for rice. Models are additive with negligible interaction assumed; genuine published designs are separate from survey data. Suggested time: 150 seconds.

## 11. Conclusion: findings and next steps

LABS 1–11: Findings, limitations and next steps

We described health patterns and applied every course method using documented data.

All 11 labs are covered. The findings follow the data and their limitations.

Speaker notes: Final review of all course experiments. Mean BMI is higher in prediabetes/diabetes groups with overlapping individual distributions. Pearson r .102 and simple R-square1.03% show a weak association; the different multiple specification explains6.81%, not validated prediction accuracy. Removing114BMI flags changes mean28.40to27.65 and variance40.34to24.59. Binomial grouped fit is adequate to this test; normal and ordinary Poisson descriptions fail. BP status association V .275 exceeds smoking .045. Published paired/design supplements demonstrate the appropriate data structure. Rice blocks reduce residual MSE44.8%; weekly-dusting C has greatest wheat yield mean13.12 with significant adjusted pair comparisons. Limitations:historical,self-report,omitted complex survey design,sparse categories,confounding,model diagnostics and method-sensitive paired result. Next steps:more recent/better data, useful predictors, evaluation on unseen observations, repeat model checks. Explain findings as associations and course demonstrations. Suggested time: 100 seconds.