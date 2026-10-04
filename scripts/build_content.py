"""One set of verified R outputs supplies slides, report and speaker notes."""
from pathlib import Path
import csv,json

ROOT=Path(__file__).resolve().parents[1]
BUILD=ROOT/'.build'; BUILD.mkdir(exist_ok=True)
def rows(path):
    with (ROOT/path).open(newline='',encoding='utf-8-sig') as f:return list(csv.DictReader(f))
def met(folder):return {r['metric']:float(r['value']) for r in rows(folder+'/output/metrics.csv')}
def f(x,d=2):return f'{float(x):.{d}f}'
def p(x):return '<0.001' if float(x)<.001 else f'{float(x):.3f}'
def pc(x):return f'{100*float(x):.2f}%'
def fig(folder,name):return folder+'/output/'+name+'.png'
A=met('Lab00_Setup'); O=met('Lab01B_Outlier_Analysis'); C=met('Lab03_Correlation_Regression')
M=met('Lab04_Multiple_Regression'); B=met('Lab05_Binomial_Fitting'); N=met('Lab06_Normal_Poisson_Fitting')
P=met('Lab09_Paired_TTest'); V=met('Lab11_ANOVA_CRD'); R=met('Lab12_ANOVA_RBD'); L=met('Lab13_Latin_Square')
tests=rows('report/consolidated_tests.csv'); bytest={r['test']:r for r in tests}
summary=rows('Lab02_Summary_Stats/output/numeric_summary.csv')
before=rows('Lab01B_Outlier_Analysis/output/before_after.csv')
joint=rows('Lab04_Multiple_Regression/output/joint_predictor_tests.csv')[1:]
coefs=rows('Lab04_Multiple_Regression/output/coefficients.csv')
class_balance=rows('Lab00_Setup/output/class_balance.csv')
sources={
 'cdc':'https://www.cdc.gov/brfss/annual_data/annual_2015.html',
 'kaggle':'https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset',
 'uci':'https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators',
 'crd':'https://kwstat.github.io/agridat/reference/cochran.crd.html',
 'rbd':'https://kwstat.github.io/agridat/reference/gomez.seedrate.html',
 'latin':'https://kwstat.github.io/agridat/reference/goulden.latin.html',
 'paired':'https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/anorexia.html',
 'gof':'https://www.itl.nist.gov/div898/handbook/eda/section3/eda35f.htm',
}
slides=[]
authors=['YASH RAJ - 24BDS1209','HRISHIKESH DAMODAR NAYAK - 24BDS1007','HARDIK LALLA - 24BDS1010','ARYAN RAJ - 24BDS1094']
def slide(title,kind,body='',**kw):
    slides.append(dict(title=title,kind=kind,body=body,**kw))
slide('Statistical analysis of diabetes and lifestyle indicators','cover',
      'BMAT202P Probability and Statistics Lab\nCDC BRFSS 2015 with experimental design supplements',
      notes='The main investigation uses a random working sample of the processed BRFSS dataset. Separate published experiments demonstrate statistical designs absent from the cross-sectional survey. Suggested timing: 20 seconds.')
slide('Aim and course coverage','text',
      'Aim: describe BMI and health indicators, examine their associations, and apply the statistical methods prescribed in BMAT202P.\nQuestions: How does BMI vary across health groups? How much BMI variation do the regression models explain? Which probability models fit the observations?\nThe course also requires independent and paired tests, chi-square tests, CRD, RBD and Latin Square ANOVA.\nThe health study is observational. The design supplements use separate experimental data.',
      notes='Explain that the project aims to demonstrate statistical reasoning rather than diagnose a person. Every one of the 11 indicative experiments in the supplied syllabus has a matching R exercise. Outlier analysis and removal are additional presentation requirements. Suggested timing: 40 seconds.')
slide('Dataset source and working sample','classchart',
      f"The derivative contains {int(A['full_n']):,} respondents, 21 predictors and one three-class target.\nWe sampled 3,000 records without replacement using seed 101.\nCombined positive status is {pc(A['sample_combined_rate'])} in the sample and {pc(A['full_combined_rate'])} in the full derivative.",
      chart={'categories':['No diabetes','Prediabetes','Diabetes'],
             'series':[{'name':label,'values':[round(float(r['proportion'])*100,4) for r in class_balance if r['dataset']==label]} for label in ['Full derivative','Working sample']]},
      takeaway='These are unweighted dataset proportions. They do not estimate national prevalence.',
      notes=f"Sources: {sources['cdc']}\n{sources['kaggle']}\n{sources['uci']}\nThe CDC original has 441,456 records. The 253,680-row file is a processed derivative. The exact CSV has 22 raw columns. Sample classes: 2,531 no diabetes, 48 prediabetes, 421 diabetes. The combined label includes 469 positive respondents. Suggested timing: 45 seconds.")
slide('Variable definitions','table',
      'The codebook distinguishes measurements, counts and coded categories.',
      table=[['Variable','Meaning','Statistical type'],['Diabetes_012','No diabetes / prediabetes / diabetes','Categorical outcome'],['Diabetes_binary','Prediabetes OR diabetes = Yes','Binary outcome'],['BMI','Body mass index in kg/m²','Continuous measure'],['MentHlth / PhysHlth','Poor-health days in a 30-day window','Bounded count'],['Age / Income / Education','Bands with unequal spacing','Ordinal categories'],['Smoker','Ever smoked at least 100 cigarettes','Binary indicator']],
      notes=f"Source: {sources['uci']}. See Lab01_Data_Types/output/variable_dictionary.csv. Age is a band, not years. Income is a band, not an exact salary. Smoker does not necessarily mean currently smoking. Factors preserve the intended types in RDS. Suggested timing: 40 seconds.")
slide('Data preparation','process',
      'Validation checks column names, allowed codes, missing values and measurement ranges.\nNo invalid or missing records occurred in the 3,000-person working sample.\nWe preserve source-row identifiers and factor types in RDS. Identical feature profiles can belong to different people, so we retain them.',
      steps=[['Import','253,680 rows'],['Sample','3,000 rows'],['Validate','3,000 retained'],['Sensitivity','2,886 retained']],
      takeaway='The original sample remains available alongside the separate BMI-filtered dataset.',
      notes='Source: Labs 0, 1 and 1B. The sample has 13 repeated feature profiles, which do not establish duplicate respondents. Acquisition records a SHA-256 checksum. RDS retains categorical levels. Each script uses common helpers and a master runner. Suggested timing: 45 seconds.')
slide('BMI outlier analysis','figure',
      f"Q1 = {f(O['q1'],1)} and Q3 = {f(O['q3'],1)}, giving IQR = {f(O['iqr'],1)}.\nThe 1.5 IQR fences are {f(O['lower_fence'],1)} and {f(O['upper_fence'],1)}.\n{int(O['flagged_n'])} respondents ({f(O['flagged_percent'],1)}%) fall outside the fences.",
      figures=[fig('Lab01B_Outlier_Analysis','bmi_outlier_fences')],
      takeaway='An unusual but valid BMI is not automatically a recording error.',
      notes='Source: Lab01B_Outlier_Analysis. Formula: lower fence = Q1 - 1.5 IQR, upper fence = Q3 + 1.5 IQR. Observed BMI range 15-89. No low-side flags occurred. The ledger saves source row, BMI and health status. We do not apply IQR removal to binary or ordinal codes. Suggested timing: 45 seconds.')
slide('Outlier removal and its effect','figuretable',
      'We removed the 114 BMI flags only in a sensitivity dataset. The primary analysis retains all valid records.',
      figures=[fig('Lab01B_Outlier_Analysis','bmi_before_after')],
      table=[['Measure','Full sample','Filtered'],['Respondents','3,000','2,886'],['Mean BMI',f(before[0]['mean']),f(before[1]['mean'])],['BMI variance',f(before[0]['variance']),f(before[1]['variance'])],['Positive status',pc(before[0]['combined_rate']),pc(before[1]['combined_rate'])],['Pearson r',f(before[0]['r'],3),f(before[1]['r'],3)]],
      takeaway='Filtering lowers both average BMI and the positive-status proportion. It changes the sample composition.',
      notes='Source: Lab01B_Outlier_Analysis/output/before_after.csv. SD changes from 6.35 to 4.96. Simple slope changes from 0.0749 to 0.0327. Simple R² falls from 1.03% to 0.31%. This is why automatic removal could bias the health story. Suggested timing: 55 seconds.')
slide('Summary statistics and variance','figuretable',
      'BMI has a right tail. Poor-health day counts have median zero and substantial variation.',
      figures=[fig('Lab02_Summary_Stats','hist_bmi')],
      table=[['Variable','Mean','Median','SD','Var.']]+[[{'BMI':'BMI','MentHlth':'Mental days','PhysHlth':'Physical days'}[r['variable']],f(r['mean']),f(r['median'],0),f(r['sd']),f(r['variance'])] for r in summary],
      takeaway='Variance measures squared spread. Standard deviation returns that spread to the original units.',
      notes='Source: Lab02_Summary_Stats/output/numeric_summary.csv. All variables use n=3000. BMI variance units are (kg/m²)², and day-count variance units are days². Sample variance uses n-1. The histogram uses bins of width 2 BMI units. Suggested timing: 40 seconds.')
slide('Graphical representations of categories','twofig',
      'Bar charts compare education counts. A pie chart demonstrates the course requirement for categorical proportions.',
      figures=[fig('Lab02_Summary_Stats','bar_education'),fig('Lab02_Summary_Stats','pie_sex')],
      takeaway='Group sizes matter. The no-school education category contains only two respondents.',
      notes='Source: Lab02_Summary_Stats frequencies and Lab11 education_groups.csv. The smallest education group is unsuitable for precise standalone conclusions. Pie, bar, histogram, boxplot and density collectively demonstrate the required range of graphical representations. Suggested timing: 30 seconds.')
slide('BMI across health-status groups','twofig',
      'Mean BMI is 27.72 for no diabetes, 32.85 for prediabetes and 31.98 for diabetes. The distributions overlap.',
      figures=[fig('Lab02_Summary_Stats','box_bmi_by_diabetes'),fig('Lab02_Summary_Stats','density_bmi')],
      takeaway='The prediabetes group has only 48 respondents. Group differences describe associations.',
      notes='Source: Lab02_Summary_Stats/output/bmi_by_status.csv. Sample counts are 2531,48,421. Mean CIs respectively 27.49-27.95,30.71-35.00,31.29-32.68. A boxplot shows median, quartiles, whiskers and potential extremes; a density plot shows shape. No causal claim is justified. Suggested timing: 40 seconds.')
slide('Poor physical health days','figure',
      f"{f(N['zero_percent'],1)}% report zero poor-health days.\n{f(N['day30_percent'],1)}% report all 30 days.\nThe mean is {f(N['lambda'])} days, while variance is {f(N['variance'])} days².",
      figures=[fig('Lab02_Summary_Stats','bar_phys_days')],
      takeaway='The spikes at zero and 30 are important features of this bounded count.',
      notes='Source: Lab02 and Lab06. The count plot preserves discrete day values rather than smoothing beyond the 0-30 range. PhysHlth denotes self-reported poor physical health in the previous 30 days. Suggested timing: 30 seconds.')
slide('Correlation and simple regression','figuretable',
      f"Pearson r = {f(C['pearson_r'],3)}, with 95% CI {f(C['r_lower'],3)} to {f(C['r_upper'],3)}.\nBMI = {f(C['intercept'])} + {f(C['slope'],4)} × PhysHlth.",
      figures=[fig('Lab03_Correlation_Regression','scatter_bmi_physhlth')],
      table=[['Statistic','Result'],['Pearson r',f(C['pearson_r'],3)],['Spearman r',f(C['spearman_r'],3)],['Slope CI','0.0486 to 0.1012'],['R²',pc(C['r_squared'])],['Slope p','<0.001']],
      takeaway='A significant association explains only 1.03% of BMI variation.',
      notes='Source: Lab03 coefficients and metrics. PhysHlth units are days. One extra poor-health day is associated with about 0.075 BMI units on average in the fitted line. Pearson measures linear association, Spearman compares ranks. The confidence intervals use ordinary unweighted assumptions. The covariance and full three-variable correlation tables are in the report. Suggested timing: 55 seconds.')
slide('Multiple linear regression','table',
      f"Response: BMI. Predictors: age band, physical activity, income band, education and ever-smoking.\nR² = {pc(M['r_squared'])}. Adjusted R² = {pc(M['adjusted_r_squared'])}.\nJoint tests compare each categorical predictor while keeping the others in the model.",
      table=[['Predictor','df','Partial F','p']]+[[r['term'],r['Df'],f(r['F.value']),p(r['Pr..F.'])] for r in joint],
      takeaway='The model leaves most BMI variation unexplained. Statistical adjustment does not establish causation.',
      notes='Source: Lab04 joint_predictor_tests.csv. Formula BMI ~ Age + PhysActivity + Income + Education + Smoker. Reference categories age50-54, income35-50k, high school, inactivity and never100 cigarettes. Full coefficients and CIs are in the report appendix/CSV. Smoking is not associated with BMI after this adjustment (p=.786), which addresses a different outcome from the status comparison. Adjusted R² penalizes model size. No classification accuracy is claimed. Suggested timing: 55 seconds.')
slide('Regression diagnostics and sensitivity','figure',
      'Residual plots assess linear form and changing spread. The Q-Q plot checks residual shape.\nLeverage and Cook’s distance identify observations that may influence the fitted coefficients.\nAfter BMI filtering, adjusted R² changes from 5.99% to 4.89%.',
      figures=[fig('Lab04_Multiple_Regression','multiple_diagnostics')],
      takeaway='Valid extreme observations affect the fit. Model conclusions remain cautious and descriptive.',
      notes='Source: Lab04 diagnostics, influence.csv and filtered coefficients. Cook threshold4/n flags140 observations for review, not automatic deletion. The design-column VIF table checks dummy-column collinearity and depends on reference coding. The simple model diagnostic sheet and individual residual plot appear in the full figure atlas. Suggested timing: 45 seconds.')
slide('Fitting the normal distribution','twofig',
      f"The fitted normal model uses mean {f(N['normal_mean'])} and SD {f(N['normal_sd'])}.\nShapiro-Wilk gives W = {f(N['shapiro_W'],3)} and p < 0.001 for all 3,000 BMI values.",
      figures=[fig('Lab06_Normal_Poisson_Fitting','normal_bmi_hist'),fig('Lab06_Normal_Poisson_Fitting','normal_bmi_qq')],
      takeaway='The right tail departs from a normal distribution. Model residuals need their own checks.',
      notes='Source: Lab06. A normality test on the raw response is not a blanket decision about all t-tests or regressions. We assess each model and use Welch comparisons where appropriate. Suggested timing: 40 seconds.')
slide('Fitting the binomial distribution','figure',
      f"We count combined-positive statuses in 300 artificial blocks of ten.\nThe individual sample proportion is {f(B['p_hat'],4)}.\nAfter pooling and fitting to bin counts, χ² = {f(B['chi_squared'],3)}, df = {int(B['df'])}, p = {p(B['p'])}.",
      figures=[fig('Lab05_Binomial_Fitting','binomial_observed_vs_expected')],
      takeaway='The pooled test does not reject the binomial teaching model. It does not prove identical individual risk.',
      notes=f"Source: Lab05. GOF guidance: {sources['gof']}. The five pooled bins have minimum expected frequency16.65. One fitted parameter yields df5-1-1=3. Grouped fitted p is .1550. Original sparse endpoint cells would invalidate the unpooled approximation. Blocks are arbitrary; independence and common probability are approximations. Suggested timing: 45 seconds.")
slide('Fitting the Poisson distribution','figure',
      f"The ordinary Poisson mean estimate is λ = {f(N['lambda'])}.\nVariance/mean = {f(N['dispersion'])}, far above the Poisson value of one.\nThe pooled test refits λ = 1.80 and gives χ² = {f(N['poisson_chi_squared'],1)}, df = {int(N['poisson_df'])}, p < 0.001.",
      figures=[fig('Lab06_Normal_Poisson_Fitting','poisson_physhlth')],
      takeaway='The Poisson model poorly describes these bounded, zero-heavy day counts.',
      notes='Source: Lab06. The ordinary Poisson upper tail >30 is included. Grouped-bin maximum likelihood gives lambda1.797, different from raw mean4.152 because of pooling and severe misfit. The chart overlays ordinary Poisson at the raw mean, while the inferential statistic uses the explicitly documented grouped fit. Both support the same inadequacy conclusion. Minimum fitted expected bin7.65. p underflows to zero numerically, so report p<.001 rather than p=0. Suggested timing: 45 seconds.')
slide('One-sample hypothesis tests','table',
      'We use two-sided alternatives and α = 0.05. The values 27 and 11% are hypothetical classroom benchmarks.',
      table=[['Question','Estimate and 95% CI','Statistic','p'],['Mean BMI = 27','28.40 [28.17, 28.63]','t = 12.06','<0.001'],['Positive proportion = 11%','15.63% [14.36%, 16.99%]','χ² = 65.31','<0.001']],
      takeaway='Both teaching nulls are rejected. The 11% value is not a sourced national prevalence claim.',
      notes='Source: Lab07. BMI test df2999. Proportion test df1 with continuity correction. State H0 and H1, compare p to alpha, and interpret the effect/CI. The proportion outcome includes prediabetes. These unweighted analyses demonstrate syllabus methods. Suggested timing: 40 seconds.')
slide('Two-sample and independent comparisons','twofig',
      'Female minus male mean BMI is −0.65, with 95% CI −1.10 to −0.20 (p = 0.004).\nCombined-positive proportions are 14.09% for never-smoking and 17.36% for ever-smoking (p = 0.016).',
      figures=[fig('Lab08_TwoSample_Tests','box_bmi_by_sex'),fig('Lab08_TwoSample_Tests','bar_diabetes_by_smoker')],
      takeaway='The independent PhysHlth test finds 1.25 more poor-health days for females, CI 0.63 to 1.86.',
      notes='Source: Labs08 and09a. BMI uses Welch t, p .004368. The explicit positive-event proportion difference never minus ever is -3.27 percentage points, CI -5.95 to -.59. PhysHlth female minusmale Welch p .0000669. Smoker means ever100 cigarettes. These are unadjusted observational comparisons. Suggested timing: 50 seconds.')
slide('Paired t-test supplement','twofig',
      'The CBT group in MASS::anorexia has 29 paired before/after weights.\nMean change is +3.01 lb, with 95% CI +0.23 to +5.79 lb. The paired t-test gives p = 0.035.\nThe signed-rank sensitivity test gives p = 0.064; the evidence depends on the method.',
      figures=[fig('Lab09_Paired_TTest','paired_weights'),fig('Lab09_Paired_TTest','paired_difference_qq')],
      takeaway='Pairing compares each patient with herself. The difference distribution is non-normal, so interpretation is cautious.',
      notes=f"Source: {sources['paired']}. Lab09b. t2.216,df28. Before mean82.69lb and after85.70lb. Shapiro p .00795 for differences. Signed-rank sensitivity p {P['wilcoxon_sensitivity_p']:.4f} tests a related distributional hypothesis rather than the same mean. An uncontrolled within-group change does not by itself demonstrate treatment efficacy. Suggested timing: 45 seconds.")
slide('Chi-square tests and categorical association','figuretable',
      'Combined-positive status is 6.93% among respondents without high BP and 27.06% among those with high BP.',
      figures=[fig('Lab10_ChiSquare_Tests','stacked_diabetes_by_highbp')],
      table=[['Test','χ²','Effect size','p'],['Status and HighBP','226.28','V = 0.275','<0.001'],['Status and Smoker','6.07','V = 0.045','0.014'],['Uniform age-band GOF','678.12','df = 12','<0.001']],
      takeaway='HighBP has the stronger sample association. The age test uses a hypothetical equal-probability null.',
      notes='Source: Lab10. All contingency expected counts exceed5. Pearson contingency tests omit continuity correction, while Lab08 prop.test retains it; small p differences are expected. CramersV measures association strength, not causal impact. Age categories have unequal widths. Suggested timing: 50 seconds.')
slide('One-way ANOVA and CRD','twofig',
      'Education-group BMI differs in the sample (F = 14.41). Unequal variances motivate the Welch sensitivity result (p < 0.001).\nThe separate sulfur experiment is a genuine CRD: 32 plots and seven treatments (F = 3.61, p = 0.010).',
      figures=[fig('Lab11_ANOVA_CRD','box_bmi_by_education'),fig('Lab11_ANOVA_CRD','crd_infection')],
      takeaway='The education comparison is observational. The sulfur dataset supports the randomized-design exercise.',
      notes=f"Source: Lab11 and {sources['crd']}. Education eta-squared .02349, about2.35% variation. Fligner variance p .00013, Welch p .000351. No-school n2 makes reference contrasts imprecise. Use separate-variance Holm-adjusted comparisons for interpretation; Tukey remains in course output. CRD controlO has8 replicates and each sulfur treatment4. Tukey finds O minusF12 infection16.875 percentage points, CI3.74-30.01,p .005965. CRD residual normality/variance diagnostics are in the full atlas. Suggested timing: 60 seconds.")
slide('Randomized block design','figuretable',
      'The rice experiment includes six seeding rates in each of four complete blocks. The additive model separates block and rate effects.',
      figures=[fig('Lab12_ANOVA_RBD','rbd_yield_by_rate')],
      table=[['Term','df','F','p'],['Block','3','5.86','0.007'],['Seeding rate','5','2.17','0.113'],['Residual','15','MSE = 110,558','']],
      takeaway='Blocking lowers residual MSE by 44.8%. The rate effect is not significant at α = 0.05.',
      notes=f"Source: {sources['rbd']}. Gomez and Gomez1984 p26,24 plots. Yieldkg/ha, seedingratekg/ha. No-block MSE200152 versus blocked110558. Rate means highest75kg/ha but non-significant overall result cannot establish an optimum. Additive model assumes no treatment-by-block interaction. This complete-block dataset replaces the original npk proposal. Suggested timing: 50 seconds.")
slide('Latin Square design','figuretable',
      'Five wheat treatments occur once in every row and every column. The model controls two nuisance factors.',
      figures=[fig('Lab13_Latin_Square','latin_square_layout')],
      table=[['Term','df','p'],['Row','4','0.013'],['Column','4','0.263'],['Treatment','4','<0.001'],['Residual','12','']],
      takeaway='Weekly dusting (C) has the highest mean yield, 13.12, and exceeds each other treatment in Tukey comparisons.',
      notes=f"Source: {sources['latin']}. Goulden1952 p216. A before rains,B after rains,C weekly dusting,D weekly drifting,E untreated. Mean yields6.84,6.46,13.12,7.96,4.92. Source does not specify yield units, so retain source scale. TreatmentF21.03,p .00002366. The additive Latin model assumes no interactions. Layout verifies treatment balance. Diagnostics and treatment boxplot are in the figure atlas. Suggested timing: 50 seconds.")
slide('Findings and conclusion','text',
      'BMI is higher on average in the prediabetes and diabetes groups, with substantial overlap between respondents.\nPoor-health days have a weak positive BMI association. The multiple model explains 6.8% of BMI variation.\nOutlier filtering changes estimates and health-status composition. Normal and Poisson fits are inadequate for these observations.\nThe experimental supplements demonstrate pairing and nuisance-factor control.\nLimitations include self-report, historical data, missing survey weights, confounding, sparse subgroups and multiple exploratory tests.',
      takeaway='The project answers descriptive and statistical questions. It supports cautious associations and course-method demonstrations.',
      notes='Suggested timing: 55 seconds. Answer the aim and distinguish practical magnitude from statistical significance. The RBD rate test is non-significant even though blocks matter. Final sources: '+ '\n'.join(sources.values())+'\nCourse source: supplied BMAT202P syllabus PDF, version1.0. Rubric: four categories, five marks each. All reported numbers originate in the saved R outputs.')
assert len(slides)==25
payload={'title':'Statistical analysis of diabetes and lifestyle indicators','authors':authors,'slides':slides,'sources':sources,
         'metrics':{'setup':A,'outliers':O,'correlation':C,'multiple':M,'binomial':B,'fits':N,'paired':P,'anova':V,'rbd':R,'latin':L},
         'tables':{'summary':summary,'before_after':before,'tests':tests,'coefficients':coefs,'joint':joint}}
(BUILD/'content.json').write_text(json.dumps(payload,indent=2,ensure_ascii=False),encoding='utf-8')
(ROOT/'report'/'presentation_content.md').write_text('\n\n'.join(f"## {i}. {s['title']}\n\n{s['body']}\n\n{s.get('takeaway','')}\n\nSpeaker notes: {s.get('notes','')}" for i,s in enumerate(slides,1)),encoding='utf-8')
print('Prepared 25 slides from verified R outputs.')
