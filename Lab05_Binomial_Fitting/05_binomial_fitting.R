# BMAT202P Probability and Statistics Lab
# Run from the project root or this lab directory. See RUNNING_GUIDE.md.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
# Experiment 5: fitted binomial distribution with pooled chi-square GOF
out <- lab_output("Lab05_Binomial_Fitting"); df <- load_clean()
block_size <- 10; usable_n <- floor(nrow(df)/block_size)*block_size
status <- as.integer(df$Diabetes_binary[seq_len(usable_n)]=="Yes")
successes <- colSums(matrix(status,nrow=block_size))
observed <- as.numeric(table(factor(successes,levels=0:10)))
p_hat <- mean(status); expected <- length(successes)*dbinom(0:10,10,p_hat)
gof <- fitted_gof(observed,function(p)dbinom(0:10,10,p),p_hat,c(.001,.999),as.character(0:10))
csv(data.frame(successes=0:10,observed=observed,expected=expected),file.path(out,"unpooled_frequencies.csv"))
csv(gof$table,file.path(out,"pooled_frequencies.csv"))
metrics(c(blocks=length(successes),omitted_incomplete_block=nrow(df)-usable_n,p_hat=p_hat,
 grouped_p=gof$estimate,chi_squared=gof$statistic,df=gof$df,p=gof$p,min_expected=min(gof$table$expected)),out)
draw(file.path(out,"binomial_observed_vs_expected.png"),{
 barplot(rbind(observed,expected),beside=TRUE,names.arg=0:10,col=c(blue,orange),xlab="Positive statuses per block of ten",ylab="Blocks",main="Binomial fit to artificial respondent blocks")
 legend("topright",c("Observed","Expected"),fill=c(blue,orange),bty="n")
})
log_text(file.path(out,"lab05_binomial_fitting.txt"),{
 cat("Artificial blocks for a course demonstration. Common-probability and independence are approximations.\n")
 cat("Parameter fitted to pooled bin counts. df = pooled bins - 1 - 1 estimated parameter.\n")
 print(gof); cat("A non-significant test does not prove homogeneous individual risk.\n")
})
