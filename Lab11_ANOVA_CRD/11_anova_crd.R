# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Experiment 11a: observational ANOVA plus a genuinely randomized CRD
out <- lab_output("Lab11_ANOVA_CRD"); df <- load_clean()
model <- aov(BMI~Education,data=df); welch <- oneway.test(BMI~Education,data=df)
csv(data.frame(term=rownames(anova(model)),anova(model)),file.path(out,"education_anova.csv"))
csv(group_summary(df$BMI,df$Education),file.path(out,"education_groups.csv"))
csv(data.frame(comparison=rownames(TukeyHSD(model)$Education),TukeyHSD(model)$Education),file.path(out,"education_tukey.csv"))
# Unequal variances: use separate-variance pairwise tests with Holm adjustment
# for the substantive education comparison. Retain Tukey as the lab exercise.
pairwise <- pairwise.t.test(df$BMI,df$Education,pool.sd=FALSE,p.adjust.method="holm")
csv(data.frame(group=rownames(pairwise$p.value),pairwise$p.value),file.path(out,"education_holm_pairs.csv"))
crd <- read.delim(data_path("cochran.crd.tsv")); crd$trt <- factor(crd$trt)
cm <- aov(inf~trt,data=crd)
csv(data.frame(term=rownames(anova(cm)),anova(cm)),file.path(out,"crd_anova.csv"))
csv(group_summary(crd$inf,crd$trt),file.path(out,"crd_groups.csv"))
csv(data.frame(comparison=rownames(TukeyHSD(cm)$trt),TukeyHSD(cm)$trt),file.path(out,"crd_tukey.csv"))
metrics(c(education_F=anova(model)$`F value`[1],education_p=anova(model)$`Pr(>F)`[1],
 education_eta_squared=anova(model)$`Sum Sq`[1]/sum(anova(model)$`Sum Sq`),
 education_variance_p=variance_check(df$BMI,df$Education)$p.value,education_welch_p=welch$p.value,
 crd_n=nrow(crd),crd_F=anova(cm)$`F value`[1],crd_p=anova(cm)$`Pr(>F)`[1],
 crd_variance_p=variance_check(crd$inf,crd$trt)$p.value,crd_residual_shapiro_p=shapiro.test(residuals(cm))$p.value),out)
draw(file.path(out,"box_bmi_by_education.png"),{par(mar=c(8,5,3,1));boxplot(BMI~Education,data=df,col=blue,las=2,ylab="BMI (kg/m^2)",main="Observational BMI comparison by education")})
draw(file.path(out,"crd_infection.png"),boxplot(inf~trt,data=crd,col=blue,ylab="Potato surface with scab (%)",main="CRD: seven sulfur treatments"))
model_diagnostics(cm,out,"crd")
log_text(file.path(out,"lab11_anova_crd.txt"),{
 cat("Education comparison is observational. Sulfur treatments use the documented Cochran CRD.\n")
 print(summary(model)); print(welch); print(pairwise); print(TukeyHSD(model)); print(summary(cm)); print(TukeyHSD(cm))
 cat("CRD control has 8 replicates; six sulfur treatments have 4 each.\n")
})
