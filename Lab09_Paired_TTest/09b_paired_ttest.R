# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Experiment 9b: genuine pairing in the MASS anorexia supplement
out <- lab_output("Lab09_Paired_TTest")
if (!requireNamespace("MASS",quietly=TRUE)) stop("Install recommended package MASS for this supplement.")
data("anorexia",package="MASS"); d <- subset(anorexia,Treat=="CBT")
change <- d$Postwt-d$Prewt; t <- t.test(d$Postwt,d$Prewt,paired=TRUE)
rank_sensitivity <- wilcox.test(change,mu=0,exact=FALSE)
csv(data.frame(pair=seq_len(nrow(d)),pre=d$Prewt,post=d$Postwt,change=change),file.path(out,"paired_weights.csv"))
csv(test_row("Paired CBT weights",t,mean(change),nrow(d),"Post minus pre lb","H0 mean paired change = 0","Within CBT group; uncontrolled before-after change is not a causal efficacy estimate"),file.path(out,"paired_test.csv"))
metrics(c(n=nrow(d),pre_mean=mean(d$Prewt),post_mean=mean(d$Postwt),change_mean=mean(change),change_sd=sd(change),shapiro_difference_p=shapiro.test(change)$p.value,wilcoxon_sensitivity_p=rank_sensitivity$p.value),out)
draw(file.path(out,"paired_weights.png"),{
 matplot(t(as.matrix(d[c("Prewt","Postwt")])),type="l",lty=1,col=adjustcolor(blue,.35),xaxt="n",xlab="Measurement",ylab="Weight (lb)",main="Paired weight measurements in the CBT group")
 axis(1,at=1:2,labels=c("Before","After")); lines(1:2,c(mean(d$Prewt),mean(d$Postwt)),col=orange,lwd=4)
})
draw(file.path(out,"paired_difference_qq.png"),{qqnorm(change,pch=16,col=blue,main="Normal Q-Q plot of paired changes");qqline(change,col=orange,lwd=3)})
log_text(file.path(out,"lab09_paired_ttest.txt"),{print(t);print(shapiro.test(change));print(rank_sensitivity);cat("Each line joins the same patient. Analyse differences, not independent pre/post samples.\n")})
