# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Experiment 10: exact uniform-null GOF and categorical associations
out <- lab_output("Lab10_ChiSquare_Tests"); df <- load_clean()
age <- chisq.test(table(df$Age))
tables <- list(HighBP=table(df$Diabetes_binary,df$HighBP),Smoker=table(df$Diabetes_binary,df$Smoker))
rows <- list(test_row("Age uniform GOF",age,NA,nrow(df),"X-squared","H0 equal probabilities across all 13 age bands","Hypothetical null; unequal-width age bands do not imply uniformity"))
for(v in names(tables)) {
 test <- chisq.test(tables[[v]],correct=FALSE)
 stopifnot(all(test$expected>=5))
 effect <- sqrt(unname(test$statistic)/(sum(tables[[v]])*min(dim(tables[[v]])-1)))
 rows[[length(rows)+1]] <- test_row(paste("Status and",v),test,effect,nrow(df),"Cramer's V","H0 categorical independence")
 csv(data.frame(status=rownames(test$expected),test$expected),file.path(out,paste0(v,"_expected.csv")))
 csv(positive_rates(df,v),file.path(out,paste0(v,"_rates.csv")))
}
csv(do.call(rbind,rows),file.path(out,"tests.csv"))
rates <- positive_rates(df,"HighBP")
draw(file.path(out,"stacked_diabetes_by_highbp.png"),{
 barplot(rbind(1-rates$rate,rates$rate),names.arg=c("No high BP","High BP"),col=c(blue,orange),ylab="Proportion",main="Combined health status by blood pressure status")
 legend("topright",c("No combined status","Prediabetes or diabetes"),fill=c(blue,orange),bty="n")
})
log_text(file.path(out,"lab10_chisquare_tests.txt"),{print(age);print(do.call(rbind,rows));cat("Contingency tests use Pearson chi-square without continuity correction.\n")})
