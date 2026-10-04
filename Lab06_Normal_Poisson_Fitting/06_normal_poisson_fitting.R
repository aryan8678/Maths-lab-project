# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Experiment 6: normal and ordinary Poisson fits
out <- lab_output("Lab06_Normal_Poisson_Fitting"); df <- load_clean()
normal <- shapiro.test(df$BMI)
lambda <- mean(df$PhysHlth)
observed <- c(as.numeric(table(factor(df$PhysHlth,levels=0:30))),0)
prob <- function(lam)c(dpois(0:30,lam),ppois(30,lam,lower.tail=FALSE))
expected <- nrow(df)*prob(lambda)
gof <- fitted_gof(observed,prob,lambda,c(.01,30),c(as.character(0:30),">30"))
csv(data.frame(day=c(as.character(0:30),">30"),observed=observed,expected=expected),file.path(out,"poisson_frequencies.csv"))
csv(gof$table,file.path(out,"poisson_pooled.csv"))
metrics(c(n=nrow(df),normal_mean=mean(df$BMI),normal_sd=sd(df$BMI),shapiro_W=unname(normal$statistic),shapiro_p=normal$p.value,
 lambda=lambda,variance=var(df$PhysHlth),dispersion=var(df$PhysHlth)/lambda,zero_percent=100*mean(df$PhysHlth==0),
 day30_percent=100*mean(df$PhysHlth==30),grouped_lambda=gof$estimate,poisson_chi_squared=gof$statistic,
 poisson_df=gof$df,poisson_p=gof$p,min_expected=min(gof$table$expected)),out)
draw(file.path(out,"normal_bmi_hist.png"),{
 hist(df$BMI,breaks=seq(0,100,2),freq=FALSE,col=blue,border="white",main="BMI with a fitted normal curve",xlab="BMI (kg/m^2)")
 curve(dnorm(x,mean(df$BMI),sd(df$BMI)),add=TRUE,col=orange,lwd=3)
})
draw(file.path(out,"normal_bmi_qq.png"),{qqnorm(df$BMI,pch=16,col=adjustcolor(blue,.3),main="Normal Q-Q plot of BMI"); qqline(df$BMI,col=orange,lwd=3)})
draw(file.path(out,"poisson_physhlth.png"),{
 barplot(rbind(observed,expected),beside=TRUE,names.arg=c(0:30,">30"),col=c(blue,orange),main="Ordinary Poisson fit to PhysHlth",xlab="Days (including theoretical upper tail)",ylab="Respondents")
 legend("topright",c("Observed","Expected"),fill=c(blue,orange),bty="n")
})
log_text(file.path(out,"lab06_normal_poisson_fitting.txt"),{
 print(normal); print(gof)
 cat("Poisson is a teaching hypothesis. PhysHlth is bounded 0-30 and has excess zeros.\n")
 cat("Variance/mean:",var(df$PhysHlth)/lambda,"\n")
 cat("The ordinary Poisson upper tail is included in pooling. Parameter is fitted to pooled counts.\n")
})
