# End-to-end checks of data lineage and statistical reporting conventions.
source("R/common.R")
df <- load_clean(); filtered <- load_clean(TRUE)
stopifnot(nrow(df)==3000, !anyNA(df), !anyDuplicated(df$source_row),
 is.factor(df$Age),is.factor(df$Income),is.factor(df$Education),
 identical(levels(df$Diabetes_binary),c("No","Yes")),nrow(filtered)<nrow(df),
 all(filtered$source_row %in% df$source_row))
raw <- read.csv(data_path("diabetes_012_health_indicators_BRFSS2015.csv"))
stopifnot(all((df$Diabetes_binary=="Yes")==(raw$Diabetes_012[df$source_row]>0)))
# Pearson slope identity provides an independent consistency check.
coeff <- read.csv(file.path(root,"Lab03_Correlation_Regression/output/coefficients.csv"))
stopifnot(abs(coeff$estimate[2]-cor(df$BMI,df$PhysHlth)*sd(df$BMI)/sd(df$PhysHlth))<1e-10)
# Explicit-event proportions must agree with the positive status counts.
rates <- positive_rates(df,"Smoker")
prop <- prop.test(rates$positive,rates$n)
stopifnot(all(abs(unname(prop$estimate)-rates$rate)<1e-12))
reported <- read.csv(file.path(root,"Lab08_TwoSample_Tests/output/tests.csv"))
stopifnot(abs(reported$estimate[2]-(rates$rate[1]-rates$rate[2]))<1e-12)
# Poisson probabilities cover the entire ordinary support, including >30.
lambda <- mean(df$PhysHlth)
stopifnot(abs(sum(dpois(0:30,lambda))+ppois(30,lambda,lower.tail=FALSE)-1)<1e-12)
for(folder in c("Lab05_Binomial_Fitting","Lab06_Normal_Poisson_Fitting")) {
 file <- if(folder=="Lab05_Binomial_Fitting") "pooled_frequencies.csv" else "poisson_pooled.csv"
 tab <- read.csv(file.path(root,folder,"output",file))
 stopifnot(all(tab$expected>=5),abs(sum(tab$expected)-sum(tab$observed))<1e-6,nrow(tab)-2>=1)
}
# The design supplement must have actual complete blocks / Latin balance.
rbd <- read.delim(data_path("gomez.seedrate.tsv")); latin <- read.delim(data_path("goulden.latin.tsv"))
stopifnot(all(table(rbd$rep,rbd$rate)==1),all(table(latin$row,latin$trt)==1),all(table(latin$col,latin$trt)==1))
pair <- read.csv(file.path(root,"Lab09_Paired_TTest/output/paired_weights.csv"))
stopifnot(all(abs(pair$change-(pair$post-pair$pre))<1e-10))
inventory <- read.csv(file.path(root,"Lab14_Consolidation/output/figure_inventory.csv"))
stopifnot(all(file.exists(file.path(root,inventory$figure))))
cat("PASS: lineage, preserved factors, positive event, slope identity, GOF support/counts, experimental designs and pairing.\n")
