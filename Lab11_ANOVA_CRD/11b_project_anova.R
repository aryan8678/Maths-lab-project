# Project-only ANOVA illustrations for the second-last presentation slide.
# These are observational survey models, not randomized CRD/RBD/Latin designs.
common <- if (file.exists("R/common.R")) "R/common.R" else "../R/common.R"
source(common, local = TRUE)
out <- lab_output("Lab11_ANOVA_CRD")
df <- load_clean()

# The additive formulas mirror zero, one and two nuisance-factor adjustments.
# Age/Income are observed categories: no random assignment, complete-block
# structure or Latin balance is asserted or manufactured.
models <- list(
  "One-way: Education" = lm(BMI ~ Education, data = df),
  "Age-adjusted: Age + Education" = lm(BMI ~ Age + Education, data = df),
  "Age/income-adjusted: Age + Income + Education" = lm(BMI ~ Age + Income + Education, data = df)
)
results <- do.call(rbind, lapply(names(models), function(label) {
  model <- models[[label]]
  test <- drop1(model, test = "F")["Education", ]
  data.frame(model = label, tested_factor = "Education", n = nobs(model),
    education_df = test$Df, residual_df = df.residual(model),
    F = test$`F value`, p = test$`Pr(>F)`, r_squared = summary(model)$r.squared)
}))
csv(results, file.path(out, "project_anova_models.csv"))
groups <- group_summary(df$BMI, df$Education)
csv(groups, file.path(out, "project_education_groups.csv"))

welch <- oneway.test(BMI ~ Education, data = df)
variance <- variance_check(df$BMI, df$Education)
pairs <- pairwise.t.test(df$BMI, df$Education,
                        pool.sd = FALSE, p.adjust.method = "holm")
gmean <- setNames(groups$mean, groups$group)
checks <- data.frame(
  test = c("Welch one-way ANOVA", "Fligner equal-spread test",
           "Graduate minus high school (Holm)", "Graduate minus some college (Holm)"),
  estimate = c(unname(welch$statistic), unname(variance$statistic),
    gmean["College graduate"] - gmean["High school"],
    gmean["College graduate"] - gmean["Some college"]),
  p = c(welch$p.value, variance$p.value,
    pairs$p.value["College graduate", "High school"],
    pairs$p.value["College graduate", "Some college"])
)
csv(checks, file.path(out, "project_anova_checks.csv"))
stopifnot(all(results$n == 3000), all(results$education_df == 5),
          all(is.finite(results$F)), all(results$p >= 0 & results$p <= 1))
log_text(file.path(out, "project_anova_explanation.txt"), {
  print(results); print(checks)
  cat("The tested factor is Education in every model. Additional factors adjust for recorded age/income groups.\n")
  cat("OLS partial F comparisons assume a suitable independent-error model. Survey weights/design are unavailable.\n")
  cat("Unequal spreads motivate the separate Welch and Holm checks. Welch here checks the unadjusted comparison only.\n")
  cat("No randomized CRD, complete RBD or Latin Square design is claimed for the health survey.\n")
})
cat("Completed project-only education ANOVA models and follow-up checks.\n")
