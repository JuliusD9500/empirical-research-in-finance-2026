# =======================================================
# Empirical Research in Finance - (a)
#
# Purpose: Import data and clean it
# Input: data/raw/value_effect_panel.dta
# Output: ---
# =======================================================

# 1. Import Packages ------------------------------------

library(haven) # read Stata files
library(tidyverse) # drop n.a.'s

# 2. Import raw data ------------------------------------
firm_year_panel <- read_dta("data/raw/value_effect_panel.dta")

# 3. Filter data ----------------------------------------

firm_year_panel <- firm_year_panel |>
  filter(
    total_assets > 0,
    share_price > 0,
    num_shares > 0,
    book_equity > 0
)

# Variable 0: 
firm_year_panel$market_cap <- firm_year_panel$share_price * firm_year_panel$num_shares

# Variable 1: 
firm_year_panel$book2market <- firm_year_panel$book_equity / firm_year_panel$market_cap

# Variable 2: 
firm_year_panel$leverage <- (firm_year_panel$lt_debt + firm_year_panel$debt_current) / firm_year_panel$total_assets

# Variable 3: 
firm_year_panel <- drop_na(firm_year_panel, ebitda)

firm_year_panel$profitability <- firm_year_panel$ebitda / firm_year_panel$total_assets

# Variable 4: 
firm_year_panel$dividend <- (firm_year_panel$dividends_total / firm_year_panel$num_shares) / firm_year_panel$share_price

# Variable 5: 
firm_year_panel$size <- log(firm_year_panel$market_cap)
