# =======================================================
# Empirical Research in Finance - Group Assignment
#
# Purpose: Filter the sample, create variables and winsorize.
# Input: data/raw/value_effect_panel.dta
# Output: data/clean/value_effect_panel_clean.rda
# =======================================================

library(haven) # read Stata data
library(dplyr) # data manipulation

data <- read_dta("data/raw/value_effect_panel.dta")

# Filter data (balance sheet identity is violated; german firms only, no country filter needed)

data <- data |>
  filter(
!(sic2 >= 60 & sic2 <= 69), # exclude financial firms
total_assets > 0, # for meaningful 'lev' and 'prof'
num_shares > 0,   # for 'market_cap'
share_price > 0,  # for meaningful 'market_cap'
!is.na(ebitda)    # for 'prof'
)

# Create variables
data <- data |>
  mutate(
    market_cap = share_price * num_shares,
    b2m = book_equity / market_cap,
    lev = (lt_debt + debt_current) / total_assets,
    prof = ebitda / total_assets,
    div_yield = dividends_total / market_cap,
    size = log(market_cap)
  )

# Winsorize variables (1% in each tail, no interpolation as in the lecture)
winsorize <- function(x) {
  sorted_x <- sort(x)
  n <- length(sorted_x)
  k <- floor(0.01 * n)

  lower <- sorted_x[k + 1]
  upper <- sorted_x[n - k]

  x[x < lower] <- lower
  x[x > upper] <- upper

  return(x)
}

data <- data |> # keep original variables and add winsorized ones
  mutate(
    b2m_w = winsorize(b2m), 
    lev_w = winsorize(lev),
    prof_w = winsorize(prof),
    div_yield_w = winsorize(div_yield),
    excess_return_w = winsorize(excess_return)
  )

# Save cleaned data
save(data, file = "data/clean/value_effect_panel_clean.rda")
