# Completed implementation and rubric review

Prepared 4 October 2026. The repository was pulled at commit `2bfebaedd34c387206d70c8a362234e1cd425c2d`. This review covers the revised local files and the supplied BMAT202P syllabus, version 1.0.

## Completion evidence

All 17 scripts completed through `run_all.R` in R 4.5.3 with MASS 7.3-65. The end-to-end validation passed. The execution log and statistical outputs are retained. The final pack contains a 25-slide editable PowerPoint, its PDF, an 18-page Word/PDF report, a 29-page atlas and all original PNG drawings. All slides, report pages and atlas pages were visually inspected; the presentation and report were rendered through installed PowerPoint and Word. The deck also passed package, geometry, font and native-object checks.

## Rubric evidence

| Rubric area | Evidence in the submission |
|---|---|
| Collection of Data, 5 marks | Identified CDC/Kaggle derivative, exact file checksum, full/sample class counts, seeded sampling, complete dictionary, missing/range/code checks, distinct and documented experimental sources. Report pages 2–3 and slides 3–5. |
| Analysis, 5 marks | Summary/variance, multiple plot forms, outlier ledger and removal sensitivity, correlations/covariance, regression with confidence intervals and diagnostics, corrected probability fits and hypothesis tests, genuine experimental designs. Slides 6–24; report pages 4–15; all lab outputs. |
| Review, 5 marks | Practical effect magnitudes, uncertainty, weak model explanation, distribution misfit, sensitivity to removal/method, design-specific findings and limitations linked to the aim. Report page 16 and slide 25. |
| Final Submission, 5 marks | Clear title, four students' names/IDs, aim, source/method/results/conclusion/references, course-coverage appendix, numbered pages/slides, editable artifacts, notes, complete drawings and reproduction guide. |

The mapping demonstrates evidence against the rubric; the faculty determines awarded marks.

## Main corrections and additions

- Imported the verified raw source and added a reproducible acquisition script. Output directories are now created automatically.
- Preserved factor types with RDS. Age, education and income are category contrasts; they are not assumed to have equal numeric spacing.
- Added BMI IQR analysis, a source-row removal ledger and the separate 2,886-row filtered sample. Kept valid extremes in the 3,000-row primary analysis and compared the consequences.
- Corrected the positive-event definition and count orientation. The target combines prediabetes and diabetes; smoking means ever smoked 100 cigarettes.
- Corrected fitted-model chi-square calculations: full support, pooled expected counts, grouped parameter estimation and fitted-parameter degrees of freedom. The ordinary and grouped Poisson estimates are explicitly distinguished.
- Added correlation/slope confidence intervals, covariance, categorical joint regression tests, influence and residual diagnostics. Model explanation is reported as R², not classification accuracy.
- Labelled one-sample values as hypothetical classroom benchmarks. Used Welch comparisons and reported estimates, uncertainty and signs consistently.
- Added an actual paired t-test on 29 CBT pre/post weights. Non-normal changes and a signed-rank sensitivity result are openly discussed.
- Separated observational education ANOVA from genuine CRD. Added Welch and unequal-variance/Holm sensitivity, plus a genuine Cochran sulfur CRD.
- Added a simple Gomez complete-block rice RBD, with balance checks and blocked/unblocked MSE comparison. Added Goulden's 5×5 Latin Square with row/column checks and treatment follow-ups.
- Consolidated tests and all 29 drawings. Updated the execution guide, report, slides and rehearsal material.

## Findings to present

| Finding | Interpretation |
|---|---|
| Mean BMI: 27.72 without diabetes, 32.85 prediabetes, 31.98 diabetes | Group means differ with considerable individual overlap; prediabetes has only 48 sampled respondents. |
| BMI–PhysHlth r = 0.102; simple R² = 1.03% | A statistically detectable but weak positive relationship. |
| Multiple BMI model R² = 6.81%, adjusted R² = 5.99% | Most BMI variation remains unexplained; this is an explanatory classroom model. |
| 114 BMI flags, 3.8%; filtering changes combined-positive proportion from 15.63% to 14.62% | Removal changes the analysis population and should not be treated as neutral cleaning. |
| Normal BMI and ordinary Poisson day-count fits inadequate | Skewness, zeros, the day-count bound and variance greater than the mean matter. |
| Paired mean gain +3.01 lb, t-test p = 0.035; rank sensitivity p = 0.064 | A modest within-group change with sensitivity to the method, not proof of treatment efficacy. |
| RBD treatment p = 0.113; blocking reduces MSE by 44.8% | Blocking is useful even though the rate effect is not significant. |
| Latin treatment p < 0.001; C mean 13.12 | Weekly dusting C exceeds the other treatments in this experiment's Tukey comparisons. Source yield units are unspecified. |

## Limits and course scope

The main health data are historical, self-reported and observational. The derivative omits survey weights and design information. Results are unweighted, exploratory associations. Confounding, sparse subgroups, class imbalance, model departures and repeated testing limit inference. The experimental supplements remain separate and use their own units and assumptions.

The analysis stays close to base R and the prescribed statistical exercises. Sensitivity checks clarify conclusions, while advanced machine learning, complex survey estimation and causal claims are outside this course project. All 11 prescribed experiments have implemented evidence; see README.md and report page 18 for the mapping.

## Files to submit

Use `submission/Diabetes_Statistics_Presentation.pptx` and `submission/Diabetes_Statistics_Report.pdf` as the main files. The editable Word report, slide PDF, figure atlas and original drawings are included. Names and registration numbers match the four supplied students. Faculty/class details were not supplied and have not been invented.
