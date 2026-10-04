# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Experiment 11b: true complete blocks with six seeding rates in four blocks
out <- lab_output("Lab12_ANOVA_RBD")
d <- read.delim(data_path("gomez.seedrate.tsv")); d$rep <- factor(d$rep); d$rate <- factor(d$rate)
stopifnot(all(table(d$rep,d$rate)==1))
model <- aov(yield~rep+rate,data=d); no_block <- aov(yield~rate,data=d)
csv(data.frame(term=rownames(anova(model)),anova(model)),file.path(out,"rbd_anova.csv"))
csv(group_summary(d$yield,d$rate),file.path(out,"rate_groups.csv"))
csv(data.frame(comparison=rownames(TukeyHSD(model)$rate),TukeyHSD(model)$rate),file.path(out,"rate_tukey.csv"))
csv(d,file.path(out,"rbd_data.csv"))
metrics(c(n=nrow(d),blocks=nlevels(d$rep),treatments=nlevels(d$rate),block_F=anova(model)$`F value`[1],
 block_p=anova(model)$`Pr(>F)`[1],treatment_F=anova(model)$`F value`[2],treatment_p=anova(model)$`Pr(>F)`[2],
 residual_ss_blocked=deviance(model),residual_ss_unblocked=deviance(no_block),
 residual_mse_blocked=deviance(model)/df.residual(model),residual_mse_unblocked=deviance(no_block)/df.residual(no_block),
 residual_shapiro_p=shapiro.test(residuals(model))$p.value),out)
draw(file.path(out,"rbd_yield_by_rate.png"),{
 yr <- range(d$yield); plot(1:6,rep(NA,6),ylim=yr,xaxt="n",xlab="Seeding rate (kg/ha)",ylab="Rice yield (kg/ha)",main="RBD: seeding-rate response within each block")
 axis(1,at=1:6,labels=levels(d$rate))
 for(i in seq_along(levels(d$rep))){g<-d[d$rep==levels(d$rep)[i],]; g<-g[order(g$rate),];lines(seq_len(nrow(g)),g$yield,type="b",col=c(blue,teal,orange,"#75619B")[i],pch=15+i,lwd=2)}
 legend("topright",legend=levels(d$rep),col=c(blue,teal,orange,"#75619B"),lty=1,pch=16:19,bty="n")
})
model_diagnostics(model,out,"rbd")
log_text(file.path(out,"lab12_anova_rbd.txt"),{
 cat("Gomez and Gomez (1984), p26: 24 plots, all six rates in each of four complete blocks.\n")
 print(summary(model));print(TukeyHSD(model));cat("Additive model assumes no treatment-by-block interaction. Compare MSE as well as SS when discussing blocking.\n")
})
