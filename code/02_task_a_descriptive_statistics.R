# =======================================================
# Empirical Research in Finance - (a)
#
# Purpose: Describe the final sample, including units and sample size.
# Input: data/clean/value_effect_panel_clean.rda from code/01_data_preparation.R
# Output: results/table_a.tex (descriptive statistics table)
# =======================================================

# %% Load required packages
library(tidyverse) # data wrangling
library(modelsummary) # descriptive statistics table (incl. TeX output)

# %% Load cleaned data
load("data/clean/value_effect_panel_clean.rda")

# %% Choose features for task
task_a_df <- data |>
  haven::zap_label() |>
  transmute(
    `Excess return ¹ ²`         = excess_return_w * 100,
    `Book-to-market ²`          = b2m_w,
    `Leverage ²`                = lev_w * 100,
    `Profitability ²`           = prof_w * 100,
    `Dividend yield ²`          = div_yield_w * 100,
    `Size`                      = size,
    `Market capitalisation`     = market_cap
  )

# Define function for percentiles
percentile <- function(x, p) {
  return(quantile(x, probs = p))
}

# Calculate 10th and 90th percentiles
P10 <- function(x) percentile(x, 0.1) # reminder: Python equivalent to lambda x: ...
P90 <- function(x) percentile(x, 0.9)

# Units-Column for descriptive table
table_units <- data.frame(
  Unit = c("%", "ratio", "%", "%", "%", "ln(EUR mn)", "EUR mn")
)
attr(table_units, "position") <- 2

# Final sample size
n_observations <- nrow(data)
n_firms <- n_distinct(data$firm_id)

# Descriptive statistics table
table_a <- datasummary(
  All(task_a_df) ~ Mean + SD + Min + P10 + Median + P90 + Max,
  data = task_a_df,
  add_columns = table_units,
  fmt = 2,
  align = "llrrrrrrr",
  title = "Final-sample descriptive statistics",
  notes = paste("Observations:", n_observations, "|| Firms:", n_firms, "|| ¹ Returns refer to t+1 || ² Winsorized variables at 1% in each tail || All statistics use the single final sample"),
  output = "tinytable"
)

# Display and export tiny table
table_a
tinytable::save_tt(table_a, "results/table_a.tex", overwrite = TRUE)