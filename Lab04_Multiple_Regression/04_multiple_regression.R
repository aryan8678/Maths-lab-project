# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Experiment 4: multiple linear regression with categorical predictors
out <- lab_output("Lab04_Multiple_Regression"); df <- load_clean()
df$Age <- relevel(df$Age,"50-54")
df$Income <- relevel(df$Income,"35-50k")
df$Education <- relevel(df$Education,"High school")
model <- lm(BMI~Age+PhysActivity+Income+Education+Smoker,data=df)
filtered <- load_clean(TRUE)
filtered$Age <- relevel(filtered$Age,"50-54")
filtered$Income <- relevel(filtered$Income,"35-50k")
filtered$Education <- relevel(filtered$Education,"High school")
filtered_model <- lm(BMI~Age+PhysActivity+Income+Education+Smoker,data=filtered)
csv(coef_table(model),file.path(out,"coefficients.csv"))
csv(coef_table(filtered_model),file.path(out,"filtered_coefficients.csv"))
partial <- drop1(model,test="F")
csv(data.frame(term=rownames(partial),partial,row.names=NULL),file.path(out,"joint_predictor_tests.csv"))
influence <- data.frame(source_row=df$source_row,leverage=hatvalues(model),cooks_distance=cooks.distance(model))
csv(influence[order(-influence$cooks_distance),],file.path(out,"influence.csv"))
# VIF of design-matrix columns is a diagnostic, not a whole-factor GVIF.
design <- model.matrix(model)[,-1,drop=FALSE]
vif <- sapply(seq_len(ncol(design)),function(i) 1/(1-summary(lm(design[,i]~design[,-i,drop=FALSE]))$r.squared))
csv(data.frame(column=colnames(design),vif=vif),file.path(out,"design_column_vif.csv"))
metrics(c(n=nobs(model),r_squared=summary(model)$r.squared,adjusted_r_squared=summary(model)$adj.r.squared,
 residual_sd=summary(model)$sigma,filtered_r_squared=summary(filtered_model)$r.squared,
 filtered_adjusted_r_squared=summary(filtered_model)$adj.r.squared,
 influential_n=sum(cooks.distance(model)>4/nobs(model)),max_cook=max(cooks.distance(model)),max_column_vif=max(vif)),out)
draw(file.path(out,"residuals_vs_fitted.png"),plot(model,which=1,id.n=0))
model_diagnostics(model,out,"multiple")
log_text(file.path(out,"lab04_multiple_regression.txt"),{
 cat("Response: BMI. References: age 50-54, income 35-50k, high school, inactive, never 100 cigarettes.\n")
 cat("Age/Income/Education are factors; coefficients are category contrasts, not per-year or per-dollar changes.\n")
 print(summary(model)); print(partial); cat("IQR sensitivity:\n"); print(summary(filtered_model))
 cat("Column VIFs depend on categorical coding; do not interpret them as whole-factor GVIFs.\n")
})
