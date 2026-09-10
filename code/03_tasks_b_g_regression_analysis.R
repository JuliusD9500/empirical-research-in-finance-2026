# =======================================================
# Empirical Research in Finance - (b)-(g)
#
# Purpose: Estimate the return models and test the value effect.
# Input: data/clean/value_effect_panel_clean.rda from code/01_data_preparation.R
# Output: Tests, results/table_d.tex and results/table_b_g.tex
# =======================================================

# %% Load required packages
library(dplyr) # data wrangling
library(sandwich) # covariance matrix
library(lmtest) # coefficient tests
library(modelsummary) # regression tables (incl. TeX output)

# %% Load cleaned data
load("data/clean/value_effect_panel_clean.rda") # name: 'data'

# %% (b) Pooled OLS regression
model_b <- lm(
  excess_return_w ~ b2m_w, 
  data = data
)
print(summary(model_b))

# Test coefficient: H0: beta_B = 0; H1: beta_B != 0. Reject H0 because p ≈ 0 < 0.05
test_b <- coef(summary(model_b))["b2m_w", ]
print(test_b)

# %% (c) Add controls
model_c <- lm(
  excess_return_w ~ b2m_w + size + lev_w + prof_w + div_yield_w,
  data = data
)
print(summary(model_c))

# Test controls: H0: beta_j = 0; H1: beta_j != 0
test_c <- coef(summary(model_c))[c("size", "lev_w", "prof_w", "div_yield_w"), ]
print(test_c)

# %% (d) Small firms and the value effect
data <- data |>
  dplyr::mutate(small_firm = as.numeric(market_cap < median(market_cap)))

# Estimated model with interaction term
model_d <- lm(
  excess_return_w ~ b2m_w * small_firm + lev_w + prof_w + div_yield_w,
  data = data
)
print(summary(model_d))

# Test interaction: H0: gamma = 0; H1: gamma != 0
test_d <- coef(summary(model_d))["b2m_w:small_firm", ]
print(test_d)

# Annual counts table
table_d <- datasummary(
  Factor(year, name = "Year") ~ N, #left: rows, right: column -> number of observations
  data = data |> dplyr::filter(small_firm == 1),
  fmt = 0,
  align = "lr",
  title = "Small-firm observations by year",
  notes = "Small if market capitalisation is below the full-sample median",
  output = "tinytable"
)

# Display and export table
table_d
tinytable::save_tt(table_d, "results/table_d.tex", overwrite = TRUE)

# Book-to-market slopes by firm size (percentage points)
slopes_d_pp <- c(
  large = coef(model_d)[["b2m_w"]],
  small = coef(model_d)[["b2m_w"]] + coef(model_d)[["b2m_w:small_firm"]],
  diff = coef(model_d)[["b2m_w:small_firm"]]
) * 100 # economic interpretation
print(slopes_d_pp)


# %% (e) Estimate the model without interaction term
model_e <- lm(
  excess_return_w ~ small_firm + lev_w + prof_w + div_yield_w,
  data = data
)

# Joint F-test of no value effect (value companys: high b2m + high dividend | growth companies: low b2m + low dividend)
# H0: beta_B = gamma = 0; H1: at least one is nonzero.
test_e <- anova(model_e, model_d)
print(test_e)

# %% (f) Add year and industry dummies
model_f <- lm(
  excess_return_w ~ b2m_w * small_firm + lev_w + prof_w + div_yield_w +
    factor(year) + factor(sic2),
  data = data
)
print(summary(model_f))

# Test dummies: H0: all added coefficients = 0; H1: at least one is nonzero.
test_f <- anova(model_d, model_f)
print(test_f)

# %% (g) Firm-clustered standard errors
n_firms <- n_distinct(data$firm_id)
vcov_g <- vcovCL(model_f, cluster = ~ firm_id, type = "HC1")
model_g <- coeftest(model_f, vcov. = vcov_g, df = n_firms - 1)

# Test profitability: H0: beta_P = 0; H1: beta_P != 0.
test_g <- model_g["prof_w", ]
print(test_g)

# Return change for a 10-percentage-point increase in profitability (percentage points)
profitability_effect_pp <- coef(model_f)["prof_w"] * 0.10 * 100
print(profitability_effect_pp)

# %% Regression table
# Combine clustered inference from (g) with model fit from (f)
model_g_table <- modelsummary(model_g, output = "modelsummary_list")
model_g_table$glance <- get_gof(model_f)

# Additional rows below the regression results
table_details <- data.frame(
  term = c("Year dummies", "Industry dummies", "Standard errors", "Firms"),
  "(b)" = c("No", "No", "OLS", n_firms),
  "(c)" = c("No", "No", "OLS", n_firms),
  "(d)/(e)" = c("No", "No", "OLS", n_firms),
  "(f)" = c("Yes", "Yes", "OLS", n_firms),
  "(g)" = c("Yes", "Yes", "Clustered", n_firms),
  check.names = FALSE
)

# Consolidated regression table; (e) tests the model from (d)
table_b_g <- modelsummary(
  list("(b)" = model_b, "(c)" = model_c, "(d)/(e)" = model_d,
       "(f)" = model_f, "(g)" = model_g_table),
  coef_map = c( # select, label and order coefficients; omit year/industry dummies
    "b2m_w" = "Book-to-market",
    "size" = "Size",
    "small_firm" = "Small firm",
    "b2m_w:small_firm" = "Book-to-market x Small firm",
    "lev_w" = "Leverage",
    "prof_w" = "Profitability",
    "div_yield_w" = "Dividend yield",
    "(Intercept)" = "Constant"
  ),
  gof_map = c("nobs", "r.squared", "adj.r.squared"),
  add_rows = table_details,
  statistic = "({std.error})",
  stars = c("*" = 0.10, "**" = 0.05, "***" = 0.01),
  fmt = 3,
  align = "lrrrrr",
  width = c(0.32, 0.136, 0.136, 0.136, 0.136, 0.136),
  title = "One-year-ahead excess returns",
  notes = paste(
    "Dependent variable: excess return at t+1 (decimal). All models use the same final sample.",
    "Standard errors in parentheses. Column (g): HC1 firm-clustered SEs; t-tests use firms minus 1 degrees of freedom."
  ),
  output = "tinytable"
)

# Display and export regression table
table_b_g
tinytable::save_tt(table_b_g, "results/table_b_g.tex", overwrite = TRUE)
