# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Experiment 3: association, slope and coefficient of determination
out <- lab_output("Lab03_Correlation_Regression"); df <- load_clean()
pearson <- cor.test(df$BMI,df$PhysHlth,method="pearson")
spearman <- cor.test(df$BMI,df$PhysHlth,method="spearman",exact=FALSE)
model <- lm(BMI~PhysHlth,data=df)
csv(coef_table(model),file.path(out,"coefficients.csv"))
vars <- c("BMI","MentHlth","PhysHlth")
csv(data.frame(variable=vars,cor(df[vars])),file.path(out,"correlation_matrix.csv"))
csv(data.frame(variable=vars,cov(df[vars])),file.path(out,"covariance_matrix.csv"))
metrics(c(n=nrow(df),pearson_r=unname(pearson$estimate),r_lower=pearson$conf.int[1],r_upper=pearson$conf.int[2],
 pearson_p=pearson$p.value,spearman_r=unname(spearman$estimate),intercept=coef(model)[1],slope=coef(model)[2],r_squared=summary(model)$r.squared),out)
draw(file.path(out,"scatter_bmi_physhlth.png"),{
 plot(df$PhysHlth,df$BMI,pch=16,col=adjustcolor(blue,.16),xlab="Poor physical health days (0-30)",ylab="BMI (kg/m^2)",main="Simple regression of BMI on PhysHlth")
 abline(model,col=orange,lwd=3)
})
model_diagnostics(model,out,"simple")
log_text(file.path(out,"lab03_correlation_regression.txt"),{print(pearson); print(spearman); print(summary(model)); cat("R-squared describes variation in BMI. This association is not a causal effect.\n")})
