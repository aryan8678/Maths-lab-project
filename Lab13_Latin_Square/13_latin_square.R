# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Experiment 11c: five treatments, with row and column nuisance factors
out <- lab_output("Lab13_Latin_Square")
d <- read.delim(data_path("goulden.latin.tsv")); d$trt<-factor(d$trt);d$row<-factor(d$row);d$col<-factor(d$col)
stopifnot(all(table(d$row,d$trt)==1),all(table(d$col,d$trt)==1),all(table(d$row,d$col)==1))
model <- aov(yield~row+col+trt,data=d)
csv(data.frame(term=rownames(anova(model)),anova(model)),file.path(out,"latin_anova.csv"))
csv(group_summary(d$yield,d$trt),file.path(out,"treatment_groups.csv"))
csv(data.frame(comparison=rownames(TukeyHSD(model)$trt),TukeyHSD(model)$trt),file.path(out,"tukey.csv"))
csv(d,file.path(out,"latin_layout.csv"))
metrics(c(n=nrow(d),treatments=nlevels(d$trt),row_p=anova(model)$`Pr(>F)`[1],column_p=anova(model)$`Pr(>F)`[2],
 treatment_F=anova(model)$`F value`[3],treatment_p=anova(model)$`Pr(>F)`[3],residual_df=df.residual(model),
 residual_shapiro_p=shapiro.test(residuals(model))$p.value),out)
draw(file.path(out,"latin_square_layout.png"),{
 grid <- matrix(NA,5,5); for(i in seq_len(nrow(d)))grid[as.integer(d$col[i]),as.integer(d$row[i])]<-d$yield[i]
 image(1:5,1:5,grid,col=hcl.colors(20,"Blues"),xlab="Column",ylab="Row",main="Latin Square: treatment and observed yield",axes=FALSE)
 axis(1,1:5);axis(2,1:5)
 # Blues becomes lighter as yield increases: use dark labels on light cells.
 for(i in seq_len(nrow(d)))text(as.integer(d$col[i]),as.integer(d$row[i]),paste0(d$trt[i],"\n",d$yield[i]),cex=1.2,col=if(d$yield[i]<7.8)"white" else "#182D41")
})
draw(file.path(out,"latin_yield_by_treatment.png"),boxplot(yield~trt,data=d,col=blue,ylab="Yield (source scale)",main="Wheat yield by fungicide treatment"))
model_diagnostics(model,out,"latin")
log_text(file.path(out,"lab13_latin_square.txt"),{
 cat("Goulden (1952), p216. Source does not specify yield units; retain source scale.\n")
 cat("A before rains, B after rains, C weekly dusting, D weekly drifting, E untreated.\n")
 print(summary(model));print(TukeyHSD(model));cat("Additive Latin Square assumes no interactions; each treatment occurs once in each row and column.\n")
})
