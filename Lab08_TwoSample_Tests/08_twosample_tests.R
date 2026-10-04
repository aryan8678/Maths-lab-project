# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Experiment 8: Welch mean comparison and explicit positive-event proportions
out <- lab_output("Lab08_TwoSample_Tests"); df <- load_clean()
t <- t.test(BMI~Sex,data=df)
rates <- positive_rates(df,"Smoker")
p <- prop.test(x=rates$positive,n=rates$n)
csv(group_summary(df$BMI,df$Sex),file.path(out,"bmi_by_sex.csv")); csv(rates,file.path(out,"smoking_rates.csv"))
csv(rbind(test_row("BMI by sex",t,unname(diff(rev(t$estimate))),nrow(df),"Female minus male BMI","H0 female and male mean BMI equal"),
 test_row("Positive status by ever-smoking",p,rates$rate[1]-rates$rate[2],nrow(df),"No minus Yes proportion","H0 combined status proportions equal")),file.path(out,"tests.csv"))
draw(file.path(out,"box_bmi_by_sex.png"),boxplot(BMI~Sex,data=df,col=c(blue,orange),ylab="BMI (kg/m^2)",main="BMI by sex"))
draw(file.path(out,"bar_diabetes_by_smoker.png"),{
 barplot(100*rates$rate,names.arg=c("Never 100 cigarettes","Ever 100 cigarettes"),col=c(blue,orange),ylim=c(0,max(rates$rate)*120),ylab="Combined positive status (%)",main="Prediabetes or diabetes by ever-smoking status")
})
log_text(file.path(out,"lab08_twosample_tests.txt"),{print(t); print(p); cat("Positive column used explicitly. Smoking means ever 100 cigarettes.\n")})
