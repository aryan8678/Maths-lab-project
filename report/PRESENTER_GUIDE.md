# Rehearsal and viva guide

For theory from the beginning and detailed explanations of every slide, read [the complete project study guide](presentation_content.md) first. This shorter guide is for speaking practice after you understand the methods.

Use the revised presentation (one intro plus twelve content slides) for about 18–20 minutes, leaving time for questions. The PowerPoint notes contain the full explanations and source links. This guide supplies a simple speaking sequence and answers tied to the computed outputs.

## Suggested division

| Presenter | Slides | Time | Main responsibility |
|---|---|---|---|
| YASH RAJ | Intro and content 1–3 | 4 minutes | Aim, sources, preparation, outliers and removal |
| HRISHIKESH DAMODAR NAYAK | Content 4–6 | 5 minutes | Summary, graphs, correlations, regression and diagnostics |
| HARDIK LALLA | Content 7–9 | 5 minutes | Distributions, Labs 7–8 tests, then Lab 9 independent/paired examples |
| ARYAN RAJ | Content 10–12 | 5 minutes | Lab 10 chi-square, Lab 11 experimental designs, then the conclusion |

This is a suggested division, not a statement about who performed the original work. For a 15-minute slot, shorten graphical descriptions and show one important result per test. For 20 minutes, explain the assumption checks and design examples. Open the figure atlas for questions about diagnostic drawings.

## How to explain a result

Say the question, identify the response/groups and sample, explain the method in one sentence, then give the estimate and uncertainty. Finish with what the result means for the aim. A small p-value alone is not a useful conclusion.

Example for content slide 5: “We asked whether more poor physical-health days are associated with BMI. Pearson correlation is 0.102, a weak positive relationship. The fitted slope is about 0.075 BMI units per additional day, and the line explains only 1.03% of BMI variation. The association is statistically detectable but has little explanatory power.”

## Hypotheses to know

All formal comparisons use alpha 0.05 and two-sided alternatives unless the goodness-of-fit statistic naturally uses its upper tail.

| Exercise | Null hypothesis | Alternative |
|---|---|---|
| Pearson/simple regression | Population correlation/slope is zero | Nonzero correlation/slope |
| Multiple regression | The tested predictor's coefficients are jointly zero, conditional on other predictors | At least one coefficient is nonzero |
| One-sample BMI | Mean BMI = 27 | Mean BMI differs from 27 |
| One-sample proportion | Prediabetes-or-diabetes proportion = 0.11 | Proportion differs from 0.11 |
| Independent BMI or PhysHlth | Female and male population means are equal | Means differ |
| Two proportions | Never/ever-smoking combined-positive proportions are equal | Proportions differ |
| Paired t-test | Mean PostWt − PreWt = 0 | Mean change differs from zero |
| Chi-square contingency | The two categorical variables are independent | They are associated |
| Age GOF | Every one of the 13 age categories has probability 1/13 | At least one probability differs |
| Normal/binomial/Poisson fitting | Observations follow the stated fitted distribution under its assumptions | They do not |
| ANOVA treatment test | All treatment/group means are equal after the stated block adjustments | At least one differs |

The values 27 and 11% are hypothetical teaching benchmarks. The uniform age null is also a teaching choice, not a claim about the real population.

## Likely questions and clear answers

**Why this dataset?** It contains health status and lifestyle indicators suitable for the course's descriptive, correlation, regression and hypothesis-test exercises. It is a documented public derivative of CDC BRFSS 2015. We state the source, exact file, seed, checksum and dictionary.

**Why only 3,000 rows?** It keeps the lab manageable and reproducible. We sample without replacement using seed 101. The full source remains available. Similar target proportions provide a check but do not establish population representativeness.

**What does the binary diabetes variable mean?** It means prediabetes OR diabetes. There are 469 positive respondents in the sample: 48 prediabetes and 421 diabetes. Calling all 469 diagnosed diabetes would misdescribe the outcome.

**Did you remove outliers?** We calculated Q1 = 24, Q3 = 31 and IQR = 7. The fences are 13.5 and 41.5. All 114 flags are above the upper fence. We saved a separate dataset without those flags and compared it with the original. A valid extreme BMI is not automatically an error, so the primary analysis retains it.

**What changes after removal?** Mean BMI falls from 28.40 to 27.65; variance falls from 40.34 to 24.59. The positive proportion falls from 15.63% to 14.62%, and BMI–PhysHlth correlation falls from 0.102 to 0.056. Filtering changes the composition as well as the spread.

**Why use factors for age and income?** They are coded bands. Treating the code as a continuous number assumes equal spacing and one constant effect per band. Category contrasts avoid that assumption. The data remain ordinal in meaning, but the regression allows each level its own effect.

**What is the difference between variance and covariance?** Variance measures one variable's squared spread. Covariance measures shared variation in original units. Correlation scales covariance into a value between −1 and +1, making comparisons easier.

**Why can the regression be significant but weak?** With many observations, even a small association can be statistically detectable. R² measures how much variation the model explains. Here the simple model explains 1.03%, while the multiple model explains 6.81%.

**What do the diagnostic panels check?** Residual-versus-fitted checks shape and spread; Q-Q compares residuals to a normal pattern; scale-location checks changing spread; leverage/Cook's distance identify potentially influential observations. Flags prompt review, not automatic deletion.

**Does the multiple model predict diabetes?** Its response is BMI. It describes BMI associations and does not produce diabetes classification accuracy. The report and slide titles make that distinction.

**Why does Poisson fit poorly?** PhysHlth ranges only from 0 to 30, with 62.9% zeros and 7.4% at 30. Mean is 4.15 but variance is 74.24, whereas a Poisson model requires equality. Its support is unbounded. We retain the upper tail in the calculation and show the discrepancy.

**Why two Poisson lambda values?** The ordinary overlay estimates lambda by the raw mean, 4.152. The formal pooled-bin test refits lambda using the grouped frequencies, giving 1.797. The report identifies these as different estimation procedures. Both show inadequacy; the chart's raw fit should not be presented as the exact fit used for the test statistic.

**Why pool chi-square categories?** Very small expected frequencies weaken the chi-square approximation. We combine adjacent bins, refit the parameter and use df = bins − 1 − fitted parameters. Each final expected count is at least five. Including the full theoretical support keeps total expected and observed frequencies equal.

**Why use another dataset for pairing?** The BRFSS extract has different people at one time point, not repeated measures of the same person. The MASS CBT data have genuine before/after weights for 29 patients. Randomly matching survey rows would not create a paired experiment.

**What does the paired result show?** Mean gain is +3.01 lb with 95% CI +0.23 to +5.79 lb. The t-test gives p = 0.035, but non-normal differences and a rank sensitivity p = 0.064 call for caution. The rank test addresses a related distributional question. Within-group change alone does not prove treatment efficacy.

**Why are two smoking p-values slightly different?** The two-proportion test uses continuity correction, whereas the contingency Pearson chi-square does not. Both use the same explicit positive event. Their p-values are approximately 0.016 and 0.014.

**What distinguishes CRD, RBD and Latin Square?** CRD assigns treatments without an explicit blocking factor. RBD controls one nuisance factor through complete blocks. A Latin Square controls two nuisance factors, with each treatment once in each row and column. The agricultural supplements demonstrate genuine designs; education categories in the health survey are observational.

**What did blocking achieve?** Rice rate p = 0.113, while block p = 0.007. Residual MSE falls from 200,152 to 110,558, a 44.8% reduction. Blocking improves precision even when the treatment test is not significant. The data do not establish an optimal rate.

**What is the Latin Square conclusion?** Treatment p < 0.001 after row/column adjustment. Weekly dusting C has mean yield 13.12 and exceeds each other treatment in Tukey comparisons. The source does not specify yield units, so we use its original scale and limit the conclusion to that experiment.

**What is the main limitation?** These are historical, self-reported survey associations without the original survey weights/design. Confounding and sparse subgroups limit inference. We show uncertainty, weak model explanation and sensitivity rather than making causal or national prevalence claims.

## Closing sentence

“Our project applies the complete course sequence to documented data. It finds higher average BMI in the positive health groups, weak regression explanation, and inadequate normal/Poisson fits. The separate experiments demonstrate pairing and nuisance-factor control. The conclusions follow the data's design and limitations.”
