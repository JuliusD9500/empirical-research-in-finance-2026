# =======================================================
# Empirical Research in Finance - Cleaning & sample construction
#
# Purpose: Import raw firm-year panel, apply finance-standard filters,
#          construct the five required explanatory variables, and
#          output the final sample.
# Input:  data/raw/value_effect_panel.dta
# Output: data/clean/firm_year_panel_clean.rds
# =======================================================

# 1. Import Packages ------------------------------------
library(haven)   # read Stata files
library(tidyverse) # data wrangling (drop_na lives in tidyr)

# 2. Import raw data ------------------------------------
raw <- read_dta("data/raw/value_effect_panel.dta")

# 3. Filters & variable construction --------------------
# Standard finance filters: drop non-positive prices, shares, assets,
# and non-positive book equity. Also drop rows with missing EBITDA
# (needed for profitability).
firm_year_panel <- raw |>
  filter(
    total_assets > 0,
    share_price > 0,
    num_shares > 0,
    book_equity > 0
  ) |>
  drop_na(ebitda) |>
  mutate(
    # 1. book-to-market: book equity / market value of equity
    market_cap  = share_price * num_shares,
    book2market = book_equity / market_cap,
    # 2. leverage: (long-term debt + current debt) / total assets
    leverage    = (lt_debt + debt_current) / total_assets,
    # 3. profitability: EBITDA / total assets
    profitability = ebitda / total_assets,
    # 4. dividend yield: dividends per share / end-of-year price
    dividend    = (dividends_total / num_shares) / share_price,
    # 5. size: log market capitalisation
    size        = log(market_cap)
  )

# 4. Write final sample ---------------------------------
dir.create("data/clean", showWarnings = FALSE)
saveRDS(firm_year_panel, "data/clean/firm_year_panel_clean.rds")

# 5. Quick sanity check --------------------------------
cat("Final sample:\n")
cat("  Observations:", nrow(firm_year_panel), "\n")
cat("  Firms:       ", n_distinct(firm_year_panel$firm_id), "\n")
cat("  Years:       ", min(firm_year_panel$year), "-", max(firm_year_panel$year), "\n")
