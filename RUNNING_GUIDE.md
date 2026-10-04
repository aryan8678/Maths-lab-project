# Running the BMAT202P project

Run from the project root. The master runner creates output directories and executes all 17 scripts in order. Individual scripts also support their own lab directory. Downstream scripts read the factor-preserving RDS prepared by Lab 01.

## Complete run

```powershell
python scripts/acquire_data.py
Rscript run_all.R
Rscript tests/validate_project.R
```

This workspace includes an ignored local R 4.5.3 installation. If Rscript is not on PATH:

```powershell
$env:LC_ALL = 'C'
& '.tools/R/bin/Rscript.exe' run_all.R
& '.tools/R/bin/Rscript.exe' tests/validate_project.R
```

In RStudio, set the working directory to the project root and run `source("run_all.R")`. No repeated directory switching is needed. MASS is a recommended package normally supplied with R.

## Exercise order

| Order | Script | Main evidence |
|---|---|---|
| 1 | `Lab00_Setup/00_setup.R` | Seeded sample, source IDs, schema and class counts |
| 2 | `Lab01_Data_Types/01_data_types.R` | Validation, missingness, dictionary, typed RDS and CSV |
| 3 | `Lab01B_Outlier_Analysis/01b_outlier_analysis.R` | IQR fences, removal ledger and before/after sensitivity |
| 4 | `Lab02_Summary_Stats/02_summary_stats.R` | Summary, variances, frequencies and six plot forms |
| 5 | `Lab03_Correlation_Regression/03_correlation_regression.R` | Pearson/Spearman, covariance, slope CI, R² and diagnostics |
| 6 | `Lab04_Multiple_Regression/04_multiple_regression.R` | Factor predictors, coefficients, joint tests, influence and sensitivity |
| 7 | `Lab05_Binomial_Fitting/05_binomial_fitting.R` | Blocks of ten and pooled fitted-model GOF |
| 8 | `Lab06_Normal_Poisson_Fitting/06_normal_poisson_fitting.R` | Normal/Q-Q, Shapiro and full-support Poisson GOF |
| 9 | `Lab07_OneSample_Tests/07_onesample_tests.R` | Hypothetical mean/proportion nulls and confidence intervals |
| 10 | `Lab08_TwoSample_Tests/08_twosample_tests.R` | Welch BMI and positive-event proportion comparison |
| 11 | `Lab09_Paired_TTest/09_independent_ttest.R` | Independent PhysHlth comparison |
| 12 | `Lab09_Paired_TTest/09b_paired_ttest.R` | Genuine pre/post pairs and sensitivity |
| 13 | `Lab10_ChiSquare_Tests/10_chisquare_tests.R` | Uniform-null GOF, contingencies and Cramer's V |
| 14 | `Lab11_ANOVA_CRD/11_anova_crd.R` | Education ANOVA/Welch and genuine sulfur CRD/Tukey |
| 15 | `Lab12_ANOVA_RBD/12_anova_rbd.R` | Complete rice blocks and blocked/unblocked MSE |
| 16 | `Lab13_Latin_Square/13_latin_square.R` | Row/column balance, ANOVA, Tukey and layout |
| 17 | `Lab14_Consolidation/14_consolidation.R` | Consolidated tests and 29-figure inventory |

Each lab's `output/` directory contains its tables, figures and text results. `report/execution_log.txt` records completion. `data/provenance.json` records sources and the raw checksum.

## Analysis datasets

- Primary health analysis: 3,000 valid sampled respondents.
- BMI-filtered sensitivity: 2,886 rows after removing BMI outside 13.5–41.5.
- Paired example: 29 CBT patients from MASS, weights in pounds.
- CRD: 32 potato plots, seven treatments, infection percentage.
- RBD: 24 rice plots, six seeding rates, four blocks, yield kg/ha.
- Latin Square: 25 wheat plots, five treatments, five rows and five columns; source yield units unspecified.

The survey tests are exploratory and unweighted. Proportion tests explicitly count the Yes event. Fitted-model chi-square tests pool sparse categories, refit to grouped counts and use df = bins − 1 − estimated parameters. Poisson support includes the theoretical tail beyond 30. The ordinary Poisson overlay and grouped test use explicitly different estimates; the report explains both.

`tests/validate_project.R` checks lineage, factor types, positive events, the slope identity, GOF support/expected counts, genuine pairing, design balance and all drawings.

## Presenting the project

Use `submission/`. Notes are also in `report/presentation_content.md`; rehearse with `report/PRESENTER_GUIDE.md`. The atlas contains every drawing, including diagnostic sheets for questions.
