# Small shared helpers. Statistical calculations remain in the exercise files.
root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
while (!file.exists(file.path(root, "R", "common.R"))) {
  parent <- dirname(root)
  if (identical(root, parent)) stop("Run from the project root or a lab folder.")
  root <- parent
}
data_path <- function(name) file.path(root, "data", name)
lab_output <- function(name) {
  path <- file.path(root, name, "output")
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  path
}
csv <- function(x, file) write.csv(x, file, row.names = FALSE, na = "")
metrics <- function(values, out) {
  names(values) <- sub("\\..*$", "", names(values))
  csv(data.frame(metric = names(values), value = unname(values)), file.path(out, "metrics.csv"))
}
log_text <- function(file, code) {
  con <- file(file, open = "wt")
  sink(con)
  on.exit({sink(); close(con)}, add = TRUE)
  force(code)
}
draw <- function(file, code, width = 1500, height = 950) {
  png(file, width = width, height = height, res = 160, bg = "white")
  on.exit(dev.off(), add = TRUE)
  par(family = "sans", col.axis = "#344456", col.lab = "#182D41",
      col.main = "#182D41", mar = c(5, 5, 3, 1), cex = 1.08, las = 1)
  force(code)
}
blue <- "#176D8C"; teal <- "#269E91"; orange <- "#D87945"
load_clean <- function(filtered = FALSE) {
  file <- data_path(if (filtered) "brfss_bmi_filtered.rds" else "brfss_clean.rds")
  if (!file.exists(file)) stop("Missing prepared data. Run Lab 0, Lab 1 and Lab 1B first.")
  readRDS(file)
}
group_summary <- function(y, group) {
  pieces <- split(y, group)
  do.call(rbind, lapply(names(pieces), function(g) {
    x <- pieces[[g]]; n <- length(x); se <- sd(x) / sqrt(n)
    data.frame(group = g, n = n, mean = mean(x), sd = sd(x), variance = var(x),
               lower = mean(x) - qt(.975, n - 1) * se, upper = mean(x) + qt(.975, n - 1) * se)
  }))
}
coef_table <- function(model) {
  s <- coef(summary(model)); ci <- confint(model)
  data.frame(term = rownames(s), estimate = s[,1], se = s[,2], statistic = s[,3],
             p = s[,4], lower = ci[,1], upper = ci[,2], row.names = NULL)
}
test_row <- function(name, test, estimate = NA_real_, n, unit, question, caveat = "Unweighted observational sample") {
  ci <- test$conf.int
  data.frame(test = name, question = question, n = n, estimate = estimate,
             lower = if (length(ci)) ci[1] else NA_real_, upper = if (length(ci)) ci[2] else NA_real_,
             statistic = unname(test$statistic), df = if (length(test$parameter)) unname(test$parameter[1]) else NA_real_,
             p = test$p.value, unit = unit, method = test$method, caveat = caveat)
}
positive_rates <- function(df, variable) {
  tab <- table(df[[variable]], df$Diabetes_binary)
  data.frame(group = rownames(tab), positive = as.numeric(tab[, "Yes"]),
             n = as.numeric(rowSums(tab)), rate = as.numeric(tab[, "Yes"] / rowSums(tab)))
}
model_diagnostics <- function(model, out, prefix) {
  draw(file.path(out, paste0(prefix, "_diagnostics.png")), {
    par(mfrow = c(2,2), mar = c(4,4,3,1))
    plot(model, which = c(1,2,3,5), id.n = 0, caption = rep("", 4))
  }, 1700, 1200)
}
# Pool adjacent cells using initial expected counts. Fit the parameter to the
# pooled frequencies, then use df = number of pooled bins - 1 - parameters.
# This keeps the course's Pearson chi-square method without advanced models.
fitted_gof <- function(observed, probability, initial, interval, labels) {
  expected <- sum(observed) * probability(initial)
  groups <- list(); current <- integer(); mass <- 0
  for (i in seq_along(expected)) {
    current <- c(current, i); mass <- mass + expected[i]
    if (mass >= 10) {groups[[length(groups) + 1]] <- current; current <- integer(); mass <- 0}
  }
  if (length(current)) {
    if (!length(groups)) stop("Too few expected observations for GOF.")
    groups[[length(groups)]] <- c(groups[[length(groups)]], current)
  }
  pooled_probability <- function(theta) {
    p <- probability(theta)
    vapply(groups, function(g) sum(p[g]), numeric(1))
  }
  repeat {
    observed_pool <- vapply(groups, function(g) sum(observed[g]), numeric(1))
    estimate <- optimize(function(theta) -sum(observed_pool * log(pmax(pooled_probability(theta), 1e-300))), interval)$minimum
    expected_pool <- sum(observed) * pooled_probability(estimate)
    if (all(expected_pool >= 5)) break
    if (length(groups) <= 3) stop("Too few adequately populated GOF bins.")
    sparse <- which.min(expected_pool)
    neighbor <- if (sparse == length(groups)) sparse - 1 else sparse + 1
    first <- min(sparse, neighbor); second <- max(sparse, neighbor)
    groups[[first]] <- c(groups[[first]], groups[[second]])
    groups <- groups[-second]
  }
  degrees <- length(groups) - 2
  if (degrees < 1) stop("Insufficient pooled bins after estimating one parameter.")
  statistic <- sum((observed_pool - expected_pool)^2 / expected_pool)
  bins <- vapply(groups, function(g) paste(labels[min(g)], labels[max(g)], sep = " to "), character(1))
  list(estimate = estimate, statistic = statistic, df = degrees,
       p = pchisq(statistic, degrees, lower.tail = FALSE),
       table = data.frame(bin = bins, observed = observed_pool, expected = expected_pool))
}
variance_check <- function(y, g) fligner.test(y, g)
