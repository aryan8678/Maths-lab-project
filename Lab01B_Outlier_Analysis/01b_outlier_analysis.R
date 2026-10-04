# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Presentation requirement: outlier detection, removal and sensitivity
out <- lab_output("Lab01B_Outlier_Analysis"); df <- load_clean()
q <- quantile(df$BMI,c(.25,.75)); spread <- diff(q)
lower <- q[1]-1.5*spread; upper <- q[2]+1.5*spread
flag <- df$BMI < lower | df$BMI > upper
csv(data.frame(source_row=df$source_row[flag],BMI=df$BMI[flag],
 status=df$Diabetes_012[flag],reason="Outside BMI 1.5 IQR fences"),file.path(out,"outlier_ledger.csv"))
filtered <- df[!flag,]; saveRDS(filtered,data_path("brfss_bmi_filtered.rds")); csv(filtered,data_path("brfss_bmi_filtered.csv"))
compare <- function(d,label) {
 m <- lm(BMI~PhysHlth,data=d)
 data.frame(dataset=label,n=nrow(d),mean=mean(d$BMI),sd=sd(d$BMI),variance=var(d$BMI),
 combined_rate=mean(d$Diabetes_binary=="Yes"),r=cor(d$BMI,d$PhysHlth),
 slope=coef(m)[2],slope_lower=confint(m)[2,1],slope_upper=confint(m)[2,2],r_squared=summary(m)$r.squared)
}
csv(rbind(compare(df,"Validated full sample"),compare(filtered,"BMI IQR filtered sensitivity")),file.path(out,"before_after.csv"))
metrics(c(q1=q[1],q3=q[2],iqr=spread,lower_fence=lower,upper_fence=upper,
 flagged_n=sum(flag),flagged_percent=100*mean(flag),retained_n=nrow(filtered),primary_n=nrow(df)),out)
draw(file.path(out,"bmi_outlier_fences.png"),{
 hist(df$BMI,breaks=seq(0,ceiling(max(df$BMI)/2)*2+2,2),col=blue,border="white",
 xlab="BMI (kg/m^2)",main="BMI and the 1.5 IQR fences")
 abline(v=c(lower,upper),col=orange,lwd=3,lty=2)
 legend("topright",legend=c("Validated sample","IQR fences"),fill=c(blue,NA),lty=c(NA,2),col=c(blue,orange),bty="n")
})
draw(file.path(out,"bmi_before_after.png"),{
 boxplot(list("Full sample"=df$BMI,"IQR filtered"=filtered$BMI),col=c(blue,teal),
 ylab="BMI (kg/m^2)",main="BMI before and after outlier removal")
})
log_text(file.path(out,"outlier_policy.txt"),{
 cat("PRIMARY: retain valid BMI extremes. SENSITIVITY: remove all BMI IQR flags.\n")
 cat("The filtered dataset demonstrates removal, and changes the population analysed.\n")
 cat("Do not filter binary/ordinal variables using IQR. Zero-heavy day counts can have IQR zero.\n")
 cat("Fences:",lower,upper,"Flagged:",sum(flag),"Retained:",nrow(filtered),"\n")
})
