# BMAT202P Probability and Statistics Lab Project

**Statistical analysis of diabetes and lifestyle indicators**

The completed project covers all 11 experiments in the supplied BMAT202P syllabus, plus BMI outlier analysis. Seventeen separate R scripts produce the results, tables and 29 drawings. The primary health analysis uses 3,000 sampled respondents from the processed CDC BRFSS 2015 data. Published experiments provide genuine paired measurements, CRD, RBD and Latin Square designs.

## Submission files

- [One intro + 12 content slides, with speaker notes](submission/Diabetes_Statistics_Presentation.pptx)
- [Presentation PDF](submission/Diabetes_Statistics_Slides.pdf)
- [18-page mini project report, Word](submission/Diabetes_Statistics_Report.docx)
- [Report PDF](submission/Diabetes_Statistics_Report.pdf)
- [Complete 29-page figure atlas](submission/Complete_Figure_Atlas.pdf)
- [All original drawings](submission/All_Drawings.zip)
- [Rubric and implementation review](report/FINAL_REVIEW.md)
- [Rehearsal and viva guide](report/PRESENTER_GUIDE.md)
- [Complete beginner study guide for every slide](report/presentation_content.md)

The presentation has one intro plus twelve numbered content slides and is designed for 15–20 minutes. Labs 7–8 and Lab 9 now have separate results slides. Lab 10 and Lab 11 remain separate, followed by the expanded conclusion. Each slide names its syllabus exercise at the top. Its notes contain explanations, sources and timing suggestions. Tables and the dataset comparison chart are editable PowerPoint objects. Original R figures are embedded and supplied separately.

For faculty-review preparation, start with [the complete study guide](report/presentation_content.md). It teaches the statistical foundations, explains all slides and all 29 drawings, works through the actual results, maps them to the R implementation, and includes 48 practice questions with answers. The generated [short slide text and notes](report/slide_content_and_notes.md) are separate, so rebuilding the deck preserves the study guide.

## Run the analysis

Use Python 3.8+ for acquisition and R with the recommended MASS package for analysis. No other external R packages are needed. From the project root:

```powershell
python scripts/acquire_data.py
Rscript run_all.R
Rscript tests/validate_project.R
```

In RStudio, set the working directory to this project and run `source("run_all.R")`, then `source("tests/validate_project.R")`. See [RUNNING_GUIDE.md](RUNNING_GUIDE.md) for script paths and the locally supplied runtime.

Acquisition verifies the raw CSV's SHA-256 checksum. The derivative has 253,680 rows and 22 raw columns: 21 predictors and a three-class target. Sampling uses `set.seed(101)`, without replacement. All 3,000 valid sampled rows remain in the primary analysis. A separate BMI-filtered sensitivity dataset contains 2,886 rows after removing 114 IQR flags.

The raw CSV and generated CSV/RDS data are available locally but ignored by Git because they are reproducible. A fresh clone must run acquisition. Three small experimental TSVs and `data/provenance.json` document the supplements. MASS supplies the paired anorexia data.

## Course coverage

| Syllabus experiment | Implementation |
|---|---|
| 1 Data types, import/export | Labs 00 and 01 |
| 2 Summary and graphical representations | Lab 02 |
| 3 Correlation, simple regression and R² | Lab 03 |
| 4 Multiple regression | Lab 04 |
| 5 Binomial fitting | Lab 05 |
| 6 Normal and Poisson fitting | Lab 06 |
| 7 One-sample mean and proportion | Lab 07 |
| 8 Two-sample mean and proportion | Lab 08 |
| 9 Independent and dependent t-tests | Labs 09a and 09b |
| 10 Chi-square GOF and contingency | Lab 10 |
| 11 CRD, RBD and Latin Square ANOVA | Labs 11–13 |
| Presentation outlier requirement | Lab 01B |
| Consolidation | Lab 14 |

Each lab keeps its source, CSV tables, text results and PNG figures. `R/common.R` provides paths, typed input, summaries and plotting helpers. `report/execution_log.txt` records all 17 completed scripts and the R session.

## Interpretation

The positive outcome includes **prediabetes or diabetes**. The smoking indicator means **ever smoked at least 100 cigarettes**. Age, education and income bands use categorical contrasts in regression. The survey results describe unweighted sample associations and do not estimate national prevalence or causal effects. The multiple model predicts BMI, explains about 6.8% of its variation, and does not classify diabetes.

Hypothetical test benchmarks are labelled. Normal and Poisson fits are inadequate. Valid extreme BMI values remain in the primary sample with a separate removal comparison. The report explains uncertainty, design assumptions, sparse categories and sensitivity results.

The agridat 1.26 supplements are `cochran.crd`, `gomez.seedrate` and `goulden.latin`. They remain separate from the health data. Gomez's rice experiment gives a simple complete-block design suited to the syllabus.

## Document sources

`scripts/build_content.py` reads the saved results. `scripts/build_report.py` builds Word, the atlas and drawing ZIP. `scripts/build_pitch_figures.R` draws the compact charts. `scripts/build_presentation.mjs` runs the compact builder using the Codex presentation runtime. `scripts/render_compact_deck.ps1` exports the current slide PDF and previews through PowerPoint; `scripts/render_office.ps1` also renders the Word report. Document rebuilding requires the Codex dependencies referenced in those scripts; running the analysis does not.

The [original plan](Maths_implementation.md) and [initial audit](AUDIT_AND_PRESENTATION_PLAN.md) remain historical records. Current completion evidence is in `report/FINAL_REVIEW.md`.

## Rebuild the revised presentation

After running the analysis, draw the compact charts with `Rscript scripts/build_pitch_figures.R`, prepare the content with `python scripts/build_content.py`, and build with `node scripts/build_presentation.mjs` using the documented Codex runtime. Export its PDF with `scripts/render_compact_deck.ps1`. The slide coverage checklist is in [report/PRESENTATION_COVERAGE.md](report/PRESENTATION_COVERAGE.md).
