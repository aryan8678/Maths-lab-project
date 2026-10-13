# Balanced, observational design-layout demonstrations using BRFSS records only.
# Sampling existing respondents does not randomize their education or exposures.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
out <- lab_output("Lab11_ANOVA_CRD")
df <- load_clean()
edu_levels <- c("Some high school", "High school", "Some college", "College graduate")
df$age_block <- cut(as.integer(df$Age), breaks=c(0,4,7,10,13),
                    labels=c("18-39","40-54","55-69","70+"))
df$income_block <- cut(as.integer(df$Income), breaks=c(0,3,5,7,8),
                       labels=c("<20k","20-35k","35-75k","75k+"))
eligible <- df[df$Education %in% edu_levels, ]
eligible$Education <- factor(eligible$Education, levels=edu_levels)

# RBD structure: four observed age blocks and four common education levels.
# Ten actual respondents per block x education cell; selection ignores BMI.
set.seed(10111)
rbd_parts <- list()
for (age in levels(eligible$age_block)) {
  for (edu in edu_levels) {
    candidates <- which(eligible$age_block == age & eligible$Education == edu)
    stopifnot(length(candidates) >= 10)
    rbd_parts[[length(rbd_parts)+1]] <- eligible[sample(candidates,10), ]
  }
}
rbd <- do.call(rbind,rbd_parts)
stopifnot(nrow(rbd)==160, !anyDuplicated(rbd$source_row),
          all(table(rbd$age_block,rbd$Education)==10))
rbd_model <- lm(BMI ~ age_block + Education, data=rbd)
rbd_no_block <- lm(BMI ~ Education, data=rbd)
csv(rbd[c("source_row","BMI","Education","age_block","income_block")],
    file.path(out,"survey_rbd_records.csv"))
rbd_means <- aggregate(BMI ~ age_block + Education,data=rbd,FUN=mean)
csv(rbd_means,file.path(out,"survey_rbd_means.csv"))
balance <- table(rbd$age_block,rbd$Education)
csv(data.frame(age_block=rownames(balance),as.data.frame.matrix(balance)),file.path(out,"survey_rbd_balance.csv"))

# A cyclic 4x4 Latin layout. Each letter denotes an observed education group.
# Select one existing record matching each age x income x education cell.
# The layout is a retrospective matched subset, not assigned treatments.
grid <- outer(0:3,0:3,function(r,c)(r+c)%%4+1)
set.seed(10112)
latin_parts <- list()
for (row in 1:4) {
  for (col in 1:4) {
    trt <- grid[row,col]
    candidates <- which(eligible$age_block==levels(eligible$age_block)[row] &
      eligible$income_block==levels(eligible$income_block)[col] &
      eligible$Education==edu_levels[trt])
    stopifnot(length(candidates)>0)
    chosen <- eligible[candidates[sample.int(length(candidates),1)], ]
    chosen$letter <- LETTERS[trt]
    chosen$layout_row <- row; chosen$layout_col <- col
    latin_parts[[length(latin_parts)+1]] <- chosen
  }
}
latin <- do.call(rbind,latin_parts)
stopifnot(nrow(latin)==16,!anyDuplicated(latin$source_row),
          all(table(latin$age_block,latin$Education)==1),
          all(table(latin$income_block,latin$Education)==1),
          all(table(latin$age_block,latin$income_block)==1))
latin_model <- lm(BMI ~ age_block + income_block + Education,data=latin)
csv(latin[c("source_row","BMI","Education","age_block","income_block","letter","layout_row","layout_col")],
    file.path(out,"survey_latin_records.csv"))

full_model <- lm(BMI ~ Education,data=df)
models <- list("CRD-form: all survey education groups"=full_model,
               "RBD layout: age blocks"=rbd_model,
               "Latin layout: age and income blocks"=latin_model)
results <- do.call(rbind,lapply(names(models),function(label) {
  m <- models[[label]]; test <- drop1(m,test="F")["Education", ]
  data.frame(model=label,n=nobs(m),education_df=test$Df,residual_df=df.residual(m),
             F=test$`F value`,p=test$`Pr(>F)`,r_squared=summary(m)$r.squared)
}))
csv(results,file.path(out,"survey_design_tests.csv"))
csv(data.frame(term=rownames(anova(rbd_model)),anova(rbd_model)),file.path(out,"survey_rbd_anova.csv"))
csv(data.frame(term=rownames(anova(latin_model)),anova(latin_model)),file.path(out,"survey_latin_anova.csv"))
layout_metrics <- c(rbd_n=160,rbd_seed=10111,latin_n=16,latin_seed=10112,
          rbd_mse=deviance(rbd_model)/df.residual(rbd_model),
          rbd_unblocked_mse=deviance(rbd_no_block)/df.residual(rbd_no_block),
          rbd_residual_shapiro_p=shapiro.test(residuals(rbd_model))$p.value,
          latin_residual_shapiro_p=shapiro.test(residuals(latin_model))$p.value)
csv(data.frame(metric=names(layout_metrics),value=unname(layout_metrics)),
    file.path(out,"survey_layout_metrics.csv"))
log_text(file.path(out,"survey_layout_explanation.txt"), {
  print(results); print(table(rbd$age_block,rbd$Education))
  print(latin[c("age_block","income_block","Education","letter","BMI","source_row")])
  cat("All BMI values and categories are observed BRFSS data. No synthetic outcomes or treatment assignments.\n")
  cat("Age strata:18-39,40-54,55-69,70+. Income:<20k,20-35k,35-75k,75k+.\n")
  cat("Education letters:A Some high school,B High school,C Some college,D College graduate.\n")
  cat("Seeds10111/10112 choose respondents within eligible cells. BMI is not used for selection.\n")
  cat("Balanced blocked and Latin layouts demonstrate additive ANOVA structure only. Education was not randomized.\n")
  cat("Small matched Latin subset n16 is exploratory; model assumptions and matching limit inference.\n")
})
cat("Created real-data balanced RBD and Latin layouts, with observational ANOVA tests.\n")
