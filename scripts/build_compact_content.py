"""Build ten content slides plus a cover from the verified lab outputs."""
from pathlib import Path
import csv,json
ROOT=Path(__file__).resolve().parents[1]
BUILD=ROOT/'.build';BUILD.mkdir(exist_ok=True)
def rows(p):
    with (ROOT/p).open(newline='',encoding='utf-8-sig') as f:return list(csv.DictReader(f))
def met(folder):return {r['metric']:float(r['value']) for r in rows(folder+'/output/metrics.csv')}
def f(x,d=2):return f'{float(x):.{d}f}'
def p(x):return '<0.001' if float(x)<.001 else f'{float(x):.3f}'
def fig(folder,name):return folder+'/output/'+name+'.png'
A=met('Lab00_Setup');O=met('Lab01B_Outlier_Analysis');C=met('Lab03_Correlation_Regression')
M=met('Lab04_Multiple_Regression');B=met('Lab05_Binomial_Fitting');N=met('Lab06_Normal_Poisson_Fitting')
P=met('Lab09_Paired_TTest');V=met('Lab11_ANOVA_CRD');R=met('Lab12_ANOVA_RBD');L=met('Lab13_Latin_Square')
authors=['YASH RAJ - 24BDS1209','HRISHIKESH DAMODAR NAYAK - 24BDS1007','HARDIK LALLA - 24BDS1010','ARYAN RAJ - 24BDS1094']
sources={
 'cdc':'https://www.cdc.gov/brfss/annual_data/annual_2015.html',
 'kaggle':'https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset',
 'uci':'https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators',
 'paired':'https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/anorexia.html',
 'crd':'https://kwstat.github.io/agridat/reference/cochran.crd.html',
 'rbd':'https://kwstat.github.io/agridat/reference/gomez.seedrate.html',
 'latin':'https://kwstat.github.io/agridat/reference/goulden.latin.html',
 'gof':'https://www.itl.nist.gov/div898/handbook/eda/section3/eda35f.htm'}
slides=[]
def slide(title,kind,body,notes,**kw):slides.append(dict(title=title,kind=kind,body=body,notes=notes,**kw))
slide('Diabetes and lifestyle indicators','cover',
 'Statistical analysis with R\nBMAT202P Probability and Statistics Lab',
 'Introduce the project and four team members. The main dataset is the processed CDC BRFSS 2015 derivative. Experimental datasets supplement the methods that require genuine pairing or randomized designs. Suggested time: 20 seconds.')
balance=[r for r in rows('Lab00_Setup/output/class_balance.csv') if r['dataset']=='Working sample']
slide('Dataset and aim','dataset',
 'Aim: describe health patterns, study BMI relationships and apply the course statistical methods.',
 'Secondary data collection: CDC BRFSS 2015, processed by Alex Teboul on Kaggle. Exact derivative: 253680 rows, 22 raw columns (21 predictors plus target). Random sample without replacement, seed101. Combined positive status includes prediabetes OR diabetes:469/3000=15.633%. Original CDC survey441456 records. The derivative omits survey-design weights, so the study supports sample associations rather than national prevalence. Explain source, relevance, size and variables. Suggested time: 90 seconds.',
 stats=[['253,680','source records'],['3,000','sampled people'],['21','health predictors']],
 chart={'categories':['No diabetes','Prediabetes','Diabetes'],'series':[{'name':'People','values':[int(r['count']) for r in balance]}]},
 table=[['Variable','What it measures'],['BMI','Body mass index (kg/m²)'],['Mental / physical health','Poor-health days, 0–30'],['Age / income / education','Grouped categories'],['Activity / smoking','Yes / No indicators']],
 takeaway='469 people (15.63%) report prediabetes or diabetes.')
slide('Data preparation','preparation',
 'Import → sample → validate → prepare for analysis',
 'Course Experiment1: types, import/export. Labs00/01. We read CSV, select3000 with seed101, inspect schema, missingness and allowed codes/ranges, and convert categories to readable factors. Missing cells0, invalid records0. The sample has13 repeated feature profiles, which do not establish duplicated people. RDS preserves factor levels and CSV provides portable output. Scripts retain source-row lineage. BMI/health days remain numeric, age/income/education are ordered bands but regression uses category contrasts. Suggested time: 80 seconds.',
 stages=[['Import','CSV source'],['Sample','3,000 random rows'],['Validate','Codes and ranges'],['Prepare','Labels and types']],
 checks=[['Missing entries','0'],['Invalid codes / ranges','0'],['Health-day range','0–30 days'],['Sample selection','Seed 101']],
 types=[['Numeric','BMI and poor-health days'],['Categorical','Health status, sex and smoking'],['Grouped categories','Age, income and education']],
 takeaway='Readable labels and correct data types make every later analysis easier.')
before=rows('Lab01B_Outlier_Analysis/output/before_after.csv')
slide('Outlier analysis and removal','outliers',
 'Q1 = 24  •  Q3 = 31  •  IQR = 7  •  Q1 − 1.5×IQR to Q3 + 1.5×IQR → 13.5 to 41.5',
 'Lab01B, additional presentation requirement. Fences are Q1−1.5IQR and Q3+1.5IQR.114 observations (3.8%) are high-side flags. The source-row ledger records their BMI/status. Demonstrate actual removal with the2886-row sensitivity dataset and compare mean, variance and status composition. Valid extreme BMI values stay in the primary analysis because being unusual does not establish error. The removal comparison is explicitly a different analysis sample. Suggested time:100 seconds.',
 figures=[fig('Lab01B_Outlier_Analysis','bmi_outlier_fences'),fig('Lab01B_Outlier_Analysis','bmi_before_after')],
 table=[['Measure','Before','After'],['People','3,000','2,886'],['Mean BMI',f(before[0]['mean']),f(before[1]['mean'])],['BMI variance',f(before[0]['variance']),f(before[1]['variance'])],['Positive status','15.63%','14.62%']],
 takeaway='114 high BMI values (3.8%) were flagged. Removing them lowers the average and spread.')
summary=rows('Lab02_Summary_Stats/output/numeric_summary.csv')
freq=rows('Lab02_Summary_Stats/output/frequencies.csv')
slide('Summary statistics and graphs','summary',
 'Mean = average  •  SD = standard deviation  •  Variance = squared spread',
 'Course Experiment2, Lab02. The numeric summary uses sample SD/variance (n−1). BMI units kg/m²; variance squared units. Mental/physical days have median0, while means3.256 and4.152 indicate right-skewness. Graphs demonstrate histogram, boxplot, density, education bar and sex pie; physical-day bar and all29 original drawings are in the atlas. The no-school group has2 respondents. Explain bar comparison, pie proportions and the density right tail. Suggested time:100 seconds.',
 table=[['Variable','Mean','Median','SD','Variance']]+[[{'BMI':'BMI','MentHlth':'Mental-health days','PhysHlth':'Physical-health days'}[r['variable']],f(r['mean']),f(r['median'],0),f(r['sd']),f(r['variance'])] for r in summary],
 education={'categories':['No school','Primary','Some HS','HS','College','Graduate'],'series':[{'name':'People','values':[int(r['count']) for r in freq if r['variable']=='Education']}]},
 sex={'categories':['Female','Male'],'series':[{'name':'Share','values':[round(float(r['proportion'])*100,4) for r in freq if r['variable']=='Sex']}]},
 figures=[fig('Lab02_Summary_Stats','density_bmi')],
 takeaway='BMI has a long right tail. Most people report few poor-health days.')
cov=rows('Lab03_Correlation_Regression/output/covariance_matrix.csv')[0]['PhysHlth']
slide('Correlation and simple regression','correlation',
 'Predicted BMI = 28.09 + 0.0749 × poor physical-health days',
 'Course Experiment3, Lab03. Pearsonr .101606,95%CI .06606–.13689,p<.001; Spearman .107897. Slope .074898,95%CI .048637–.101159. Covariance5.56044 BMI×days measures shared variation; correlation scales it. R² .0103238. A one-day increase is associated with0.075BMI units in the fitted line. Boxplots and means show higher average BMI in prediabetes/diabetes, with overlapping distributions. Prediabetesn48 limits precision. The model estimates BMI associations rather than causal effects. Suggested time:120 seconds.',
 figures=[fig('Lab03_Correlation_Regression','scatter_bmi_physhlth'),fig('Lab02_Summary_Stats','box_bmi_by_diabetes')],
 table=[['Pearson r','Spearman r','Covariance','R²'],[f(C['pearson_r'],3),f(C['spearman_r'],3),f(cov),'1.03%']],
 means=[['No diabetes','Prediabetes','Diabetes'],['27.72','32.85','31.98']],
 takeaway='r = 0.102: weak positive relation. R² = 1.03%: very little BMI variation is explained.')
joint=rows('Lab04_Multiple_Regression/output/joint_predictor_tests.csv')[1:]
slide('Multiple regression and model checks','multiple',
 'Predict BMI using age, activity, income, education and smoking. R² = variation explained.',
 'Course Experiment4, Lab04. BMI response with factor Age/Income/Education, activity and ever100-cigarettes indicator. References age50–54, income35–50k, high school, inactive, never100. R² .068067,adjusted .059917. Joint partialF tests account for other predictors. Smoking BMI coefficient−.0633,CI−.5206 to .3940,p.786. The right-skewed residuals and uneven spread limit the approximation. Cook4/n flags140 for review. Filtering yields adjustedR²4.89%. Full coefficients, confidence intervals and VIFs remain in the report/CSV. No diabetes classification accuracy is claimed. Suggested time:120 seconds.',
 stats=[['6.81%','R²'],['5.99%','Adjusted R²']],
 table=[['Predictor','F','p']]+[[{'PhysActivity':'Physical activity','Smoker':'Smoking'}.get(r['term'],r['term']),f(r['F.value']),p(r['Pr..F.'])] for r in joint],
 figures=[fig('Lab04_Multiple_Regression','multiple_diagnostics')],
 takeaway='Age, activity, income and education relate to BMI. The model explains only a small share of variation.')
bins=rows('Lab05_Binomial_Fitting/output/unpooled_frequencies.csv')
def aggregate(rows,key,ranges):
    out=[]
    for low,high in ranges:
        chosen=[r for r in rows if low<=float(r[key])<=high]
        out.append([sum(float(r[v]) for r in chosen) for v in ['observed','expected']])
    return out
bt=aggregate(bins,'successes',[(0,0),(1,1),(2,2),(3,3),(4,4),(5,10)])
po=rows('Lab06_Normal_Poisson_Fitting/output/poisson_frequencies.csv')
pt=[]
for lo,hi in [(0,0),(1,2),(3,5),(6,10),(11,20),(21,30)]:
    chosen=[r for r in po if r['day'].isdigit() and lo<=int(r['day'])<=hi]
    pt.append([sum(float(r[v]) for r in chosen) for v in ['observed','expected']])
tail=[r for r in po if not r['day'].isdigit()];pt.append([sum(float(r[v]) for r in tail) for v in ['observed','expected']])
def obs_expected(vals,categories):return {'categories':categories,'series':[{'name':v,'values':[round(x[i],4) for x in vals]} for i,v in enumerate(['Observed','Expected'])]}
slide('Fitting probability distributions','distributions',
 'Compare the observed pattern with the pattern each model expects.',
 'Course Experiments5/6, Labs05/06. Binomial:300 artificial groups of10,rawpositivep .156333; pooled MLE .154999,chi .287105,df3,p .962435,expectedmin16.65. Plot aggregates5–10 into5+ for readability. NormalBMI mean28.398,SD6.351,ShapiroW.896929,p<.001. Poisson rawmeanlambda4.151667,var74.240077,dispersion17.88199,zeros62.9%,30days7.4%. Native chart aggregates full support, including>30. Formal pooled test uses grouped MLElambda1.797448,chi41781.676,df6,p<.001,expectedmin7.65. Ordinary overlay uses rawmean; the two estimation procedures are distinguished in the report. Describe why normal/Poisson fail rather than forcing a good fit. Suggested time:120 seconds.',
 binomial=obs_expected(bt,['0','1','2','3','4','5+']),
 poisson=obs_expected(pt,['0','1–2','3–5','6–10','11–20','21–30','>30']),
 figures=[fig('Lab06_Normal_Poisson_Fitting','normal_bmi_hist')],
 descriptions=[['Binomial','Positive cases in groups of 10.\np = 0.156, 300 groups.','Test p = 0.962','Fits the grouped counts reasonably.'],['Normal','BMI: mean 28.40, SD 6.35.\nThe curve misses the long tail.','Test p < 0.001','BMI is not normally distributed.'],['Poisson','Physical-health days: mean 4.15,\nvariance 74.24. Many zeros.','Test p < 0.001','Variance is far above the mean.']],
 takeaway='A useful analysis explains why a model fits or fails.')
pair=rows('Lab09_Paired_TTest/output/paired_weights.csv')
slide('Hypothesis tests and paired measurements','tests',
 'At α = 0.05, p < 0.05 supports a difference. Read the size of the change too.',
 'Course Experiments7/8/9, Labs07/08/09a/09b. All alternatives two-sided. BMI27 and positive proportion11% are hypothetical classroom benchmarks. Welch BMI differencefemale−male−.6494,CI−1.0958 to−.2030,p.004368; smokerpositive14.087% versus17.361%,difference−3.273pp,CI−5.953 to−.594,p.015765 using continuity correction. PhysHlthfemale−male1.2463days,CI.6343 to1.8584,p<.001. Genuine paired example uses29 CBT patients from MASS anorexia, postminuspre mean3.0069lb,CI.2269 to5.7869,t2.2156,df28,p.0350. Non-normal differences Shapiro.00795 and signed-rank sensitivityp.0645 make this result method-sensitive. A within-group change does not prove treatment efficacy. Patient trajectories are blue and average orange. Suggested time:150 seconds.',
 table=[['Question / comparison','Method','Result','p'],['Mean BMI vs 27','One-sample t','28.40','<0.001'],['Positive share vs 11%','One proportion','15.63%','<0.001'],['BMI: female − male','Welch t','−0.65','0.004'],['Positive share: never / ever smoked','Two proportions','14.09% / 17.36%','0.016'],['Poor-health days: female − male','Independent t','+1.25 days','<0.001'],['Weight: after − before','Paired t','+3.01 lb','0.035']],
 paired={'categories':['Before','After'],'series':[{'name':f"Patient {r['pair']}",'values':[float(r['pre']),float(r['post'])]} for r in pair]+[{'name':'Mean','values':[round(P['pre_mean'],4),round(P['post_mean'],4)]}]},
 takeaway='Paired tests compare the same people twice. Independent tests compare different groups.')
slide('Findings and conclusion','review',
 'BMI differs across health groups, but the fitted lifestyle model explains little of its variation.',
 'Review rubric: connect findings to the aim. Values come from Lab02/03/04/01B/06. Group means differ with overlap, not diagnostic separation. Discuss practical magnitude alongside significance. The survey is self-reported/historical with omitted survey weights, confounding and sparse subgroups; these belong in the technical notes/report. Explain simple visible limitations: self-report, small groups, associations not causation. Further work could add useful predictors and repeat/check the models. Detailed chi-square/ANOVA/design findings are confined to the final slide, as requested. Suggested time:80 seconds.',
 findings=[['BMI by health group','27.72 → 32.85 / 31.98','Average BMI is higher in the prediabetes and diabetes groups.'],['Regression strength','1.03% → 6.81% R²','Using more predictors helps, but most BMI variation is unexplained.'],['Outlier removal','Mean 28.40 → 27.65','Extreme values noticeably affect the average and spread.']],
 limits=['Health measures are self-reported.','Some groups contain few people.','An association does not prove a cause.'],
 takeaway='The graphs, effect sizes and model checks together give the most useful conclusion.')
rbd=rows('Lab12_ANOVA_RBD/output/rbd_data.csv')
latin=rows('Lab13_Latin_Square/output/latin_layout.csv')
grid=[[next(r['trt'] for r in latin if int(r['row'])==y and int(r['col'])==x) for x in range(1,6)] for y in range(5,0,-1)]
rates=sorted(set(int(r['rate']) for r in rbd))
slide('Chi-square and ANOVA','designs',
 'Experiments 10 and 11: category relationships, group means and experimental designs.',
 'Final content slide ONLY covers Course Experiments10/11. Lab10: exactuniform13-agebandnullchi678.125,df12,p<.001; status×HighBPchi226.282,df1,p<.001,V.27464; status×smokerchi6.07459,df1,p.013714,V.0449985. All expectedcounts>5, no continuity correction. EducationANOVA is observational,F14.406,p<.001,eta².02349; unequal variances motivate Welchp.000351 and Holm comparisons. Genuine CRD Cochran:32potato plots,7sulfur treatments,F3.608,p.010262; Tukey controlOminusF12difference16.875pp,p.005965. RCBD Gomez rice:24plots,6rates,4completeblocks; blockF5.862,p.007416,rateF2.168,p.112809; residualMSE falls200152 to110558 (44.76%). Latin Goulden:5trts,5rows,5cols,25plots; rowp.01328,colp.26343,treatmentF21.032,p.00002366; Cweeklydustmean13.12 exceeds allotherTukeycomparisons; sourceyieldunitsunspecified. Additive designs assume no interactions. Clearly distinguish survey-group ANOVA from real randomization. Suggested time:180 seconds. Data sources: '+sources['crd']+'\n'+sources['rbd']+'\n'+sources['latin'],
 chi=[['Test','χ²','p'],['Age groups: equal frequency (GOF)','678.12','<0.001'],['Status × high BP','226.28','<0.001'],['Status × smoking','6.07','0.014']],
 anova=[['Comparison','F','p'],['BMI by education (survey)','14.41','<0.001'],['Potato CRD: 32 plots, 7 groups','3.61','0.010']],
 rbd={'categories':[str(x) for x in rates],'series':[{'name':rep,'values':[float(next(r['yield'] for r in rbd if r['rep']==rep and int(r['rate'])==rate)) for rate in rates]} for rep in ['R1','R2','R3','R4']]},
 rbd_table=[['Term','F','p'],['Block','5.86','0.007'],['Rate','2.17','0.113']],
 latin=grid,
 takeaway='CRD compares treatments. RBD controls one block factor. Latin Square controls rows and columns.')
assert len(slides)==11
assert slides[-1]['kind']=='designs'
import re
for item, seconds in zip(slides, [20,75,60,90,90,100,100,100,120,60,180]):
 item['notes']=re.sub(r'Suggested time:\s*\d+\s*seconds', f'Suggested time: {seconds} seconds', item['notes'])
payload={'title':'Statistical analysis of diabetes and lifestyle indicators',
 'authors':authors,'sources':sources,'slides':slides,'requestedContentSlides':10,
 'tables':{'summary':summary,'before_after':before,'joint':joint,
           'tests':rows('report/consolidated_tests.csv'),
           'coefficients':rows('Lab04_Multiple_Regression/output/coefficients.csv')},
 'metrics':{'setup':A,'outliers':O,'correlation':C,'multiple':M,'binomial':B,'fits':N,'paired':P,'anova':V,'rbd':R,'latin':L}}
(BUILD/'compact_content.json').write_text(json.dumps(payload,indent=2,ensure_ascii=False),encoding='utf-8')
(BUILD/'content.json').write_text(json.dumps(payload,indent=2,ensure_ascii=False),encoding='utf-8')
(ROOT/'report/presentation_content.md').write_text('\n\n'.join(f"## {'Intro' if i==0 else str(i)}. {s['title']}\n\n{s['body']}\n\n{s.get('takeaway','')}\n\nSpeaker notes: {s['notes']}" for i,s in enumerate(slides)),encoding='utf-8')
coverage='''# Coverage of the revised presentation

The presentation has **one intro plus ten content slides**. Content slides are numbered 1–10; the cover is excluded. Experiments 10 and 11 appear only on content slide 10 (PowerPoint slide 11).

| Required topic | Content slide |
|---|---|
| Dataset, source, relevance and aim | 1 |
| Preparation, data types, import/export | 2 |
| Outlier analysis and actual removal comparison | 3 |
| Summary, variance and graphical analysis | 4 |
| Correlation, covariance and simple regression | 5 |
| Multiple regression and model diagnostics | 6 |
| Binomial, normal and Poisson models | 7 |
| One-/two-sample, independent and paired tests | 8 |
| Findings, limitations and conclusion | 9 |
| Experiment 10: chi-square GOF and contingency | 10 only |
| Experiment 11: one-way ANOVA, CRD, RBD, Latin Square | 10 only |

Rubric evidence: Collection of Data on 1–2; Analysis on 3–8 and 10; Review on 9 and the result explanations; Final Submission through the organized deck, references in notes, existing report and complete drawing atlas. All 29 original drawings remain attached in the atlas/ZIP. The main deck uses selected evidence to stay readable within the ten-slide limit.
'''
(ROOT/'report/PRESENTATION_COVERAGE.md').write_text(coverage,encoding='utf-8')
print('Prepared 1 intro + 10 content slides; Experiments 10 and 11 are confined to the last slide.')
