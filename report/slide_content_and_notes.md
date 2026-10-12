## Intro. Diabetes and lifestyle indicators

Statistical analysis with R
BMAT202P Probability and Statistics Lab



Speaker notes: Introduce the project and four team members. The main dataset is the processed CDC BRFSS 2015 derivative. Experimental datasets supplement the methods that require genuine pairing or randomized designs. Suggested time: 20 seconds.

## 1. Dataset and aim

Aim: describe health patterns, study BMI relationships and apply the course statistical methods.

469 people (15.63%) report prediabetes or diabetes.

Speaker notes: Secondary data collection: CDC BRFSS 2015, processed by Alex Teboul on Kaggle. Exact derivative: 253680 rows, 22 raw columns (21 predictors plus target). Random sample without replacement, seed101. Combined positive status includes prediabetes OR diabetes:469/3000=15.633%. Original CDC survey441456 records. The derivative omits survey-design weights, so the study supports sample associations rather than national prevalence. Explain source, relevance, size and variables. Suggested time: 75 seconds.

## 2. Data preparation

Import → sample → validate → prepare for analysis

Readable labels and correct data types make every later analysis easier.

Speaker notes: Course Experiment1: types, import/export. Labs00/01. We read CSV, select3000 with seed101, inspect schema, missingness and allowed codes/ranges, and convert categories to readable factors. Missing cells0, invalid records0. The sample has13 repeated feature profiles, which do not establish duplicated people. RDS preserves factor levels and CSV provides portable output. Scripts retain source-row lineage. BMI/health days remain numeric, age/income/education are ordered bands but regression uses category contrasts. Suggested time: 60 seconds.

## 3. Outlier analysis and removal

Q1 = 24  •  Q3 = 31  •  IQR = 7  •  Q1 − 1.5×IQR to Q3 + 1.5×IQR → 13.5 to 41.5

114 high BMI values (3.8%) were flagged. Removing them lowers the average and spread.

Speaker notes: Lab01B, additional presentation requirement. Fences are Q1−1.5IQR and Q3+1.5IQR.114 observations (3.8%) are high-side flags. The source-row ledger records their BMI/status. Demonstrate actual removal with the2886-row sensitivity dataset and compare mean, variance and status composition. Valid extreme BMI values stay in the primary analysis because being unusual does not establish error. The removal comparison is explicitly a different analysis sample. Suggested time: 90 seconds.

## 4. Summary statistics and graphs

Mean = average  •  SD = standard deviation  •  Variance = squared spread

BMI has a long right tail. Most people report few poor-health days.

Speaker notes: Course Experiment2, Lab02. The numeric summary uses sample SD/variance (n−1). BMI units kg/m²; variance squared units. Mental/physical days have median0, while means3.256 and4.152 indicate right-skewness. Graphs demonstrate histogram, boxplot, density, education bar and sex pie; physical-day bar and all29 original drawings are in the atlas. The no-school group has2 respondents. Explain bar comparison, pie proportions and the density right tail. Suggested time: 90 seconds.

## 5. Correlation and simple regression

Predicted BMI = 28.09 + 0.0749 × poor physical-health days

r = 0.102: weak positive relation. R² = 1.03%: very little BMI variation is explained.

Speaker notes: Course Experiment3, Lab03. Pearsonr .101606,95%CI .06606–.13689,p<.001; Spearman .107897. Slope .074898,95%CI .048637–.101159. Covariance5.56044 BMI×days measures shared variation; correlation scales it. R² .0103238. A one-day increase is associated with0.075BMI units in the fitted line. Boxplots and means show higher average BMI in prediabetes/diabetes, with overlapping distributions. Prediabetesn48 limits precision. The model estimates BMI associations rather than causal effects. Suggested time: 100 seconds.

## 6. Multiple regression and model checks

Predict BMI using age, activity, income, education and smoking. R² = variation explained.

Age, activity, income and education relate to BMI. The model explains only a small share of variation.

Speaker notes: Course Experiment4, Lab04. BMI response with factor Age/Income/Education, activity and ever100-cigarettes indicator. References age50–54, income35–50k, high school, inactive, never100. R² .068067,adjusted .059917. Joint partialF tests account for other predictors. Smoking BMI coefficient−.0633,CI−.5206 to .3940,p.786. The right-skewed residuals and uneven spread limit the approximation. Cook4/n flags140 for review. Filtering yields adjustedR²4.89%. Full coefficients, confidence intervals and VIFs remain in the report/CSV. No diabetes classification accuracy is claimed. Suggested time: 100 seconds.

## 7. Fitting probability distributions

Compare the observed pattern with the pattern each model expects.

A useful analysis explains why a model fits or fails.

Speaker notes: Course Experiments5/6, Labs05/06. Binomial:300 artificial groups of10,rawpositivep .156333; pooled MLE .154999,chi .287105,df3,p .962435,expectedmin16.65. Plot aggregates5–10 into5+ for readability. NormalBMI mean28.398,SD6.351,ShapiroW.896929,p<.001. Poisson rawmeanlambda4.151667,var74.240077,dispersion17.88199,zeros62.9%,30days7.4%. Native chart aggregates full support, including>30. Formal pooled test uses grouped MLElambda1.797448,chi41781.676,df6,p<.001,expectedmin7.65. Ordinary overlay uses rawmean; the two estimation procedures are distinguished in the report. Describe why normal/Poisson fail rather than forcing a good fit. Suggested time: 100 seconds.

## 8. Hypothesis tests and paired measurements

At α = 0.05, p < 0.05 supports a difference. Read the size of the change too.

Paired tests compare the same people twice. Independent tests compare different groups.

Speaker notes: Course Experiments7/8/9, Labs07/08/09a/09b. All alternatives two-sided. BMI27 and positive proportion11% are hypothetical classroom benchmarks. Welch BMI differencefemale−male−.6494,CI−1.0958 to−.2030,p.004368; smokerpositive14.087% versus17.361%,difference−3.273pp,CI−5.953 to−.594,p.015765 using continuity correction. PhysHlthfemale−male1.2463days,CI.6343 to1.8584,p<.001. Genuine paired example uses29 CBT patients from MASS anorexia, postminuspre mean3.0069lb,CI.2269 to5.7869,t2.2156,df28,p.0350. Non-normal differences Shapiro.00795 and signed-rank sensitivityp.0645 make this result method-sensitive. A within-group change does not prove treatment efficacy. Patient trajectories are blue and average orange. Suggested time: 120 seconds.

## 9. Findings and conclusion

BMI differs across health groups, but the fitted lifestyle model explains little of its variation.

The graphs, effect sizes and model checks together give the most useful conclusion.

Speaker notes: Review rubric: connect findings to the aim. Values come from Lab02/03/04/01B/06. Group means differ with overlap, not diagnostic separation. Discuss practical magnitude alongside significance. The survey is self-reported/historical with omitted survey weights, confounding and sparse subgroups; these belong in the technical notes/report. Explain simple visible limitations: self-report, small groups, associations not causation. Further work could add useful predictors and repeat/check the models. Detailed chi-square/ANOVA/design findings are confined to the final slide, as requested. Suggested time: 60 seconds.

## 10. Chi-square and ANOVA

Experiments 10 and 11: category relationships, group means and experimental designs.

CRD compares treatments. RBD controls one block factor. Latin Square controls rows and columns.

Speaker notes: Final content slide ONLY covers Course Experiments10/11. Lab10: exactuniform13-agebandnullchi678.125,df12,p<.001; status×HighBPchi226.282,df1,p<.001,V.27464; status×smokerchi6.07459,df1,p.013714,V.0449985. All expectedcounts>5, no continuity correction. EducationANOVA is observational,F14.406,p<.001,eta².02349; unequal variances motivate Welchp.000351 and Holm comparisons. Genuine CRD Cochran:32potato plots,7sulfur treatments,F3.608,p.010262; Tukey controlOminusF12difference16.875pp,p.005965. RCBD Gomez rice:24plots,6rates,4completeblocks; blockF5.862,p.007416,rateF2.168,p.112809; residualMSE falls200152 to110558 (44.76%). Latin Goulden:5trts,5rows,5cols,25plots; rowp.01328,colp.26343,treatmentF21.032,p.00002366; Cweeklydustmean13.12 exceeds allotherTukeycomparisons; sourceyieldunitsunspecified. Additive designs assume no interactions. Clearly distinguish survey-group ANOVA from real randomization. Suggested time: 180 seconds. Data sources: https://kwstat.github.io/agridat/reference/cochran.crd.html
https://kwstat.github.io/agridat/reference/gomez.seedrate.html
https://kwstat.github.io/agridat/reference/goulden.latin.html