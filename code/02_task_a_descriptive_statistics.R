# =======================================================
# Empirical Research in Finance - (a)
#
# Purpose: Import data and clean it
# Input: data/raw/value_effect_panel.dta
# Output: ---
# =======================================================

library(haven) # read Stata data
library(dplyr) # data manipulation

value_effect_panel <- read_dta("data/raw/value_effect_panel.dta")

# filter data
value_effect_panel <- value_effect_panel |>
  filter(
    share_price > 0, # some firms have negative share prices
    !is.na(ebitda), # some firms have missing ebitda
    
)

value_effect_panel$market_cap <- value_effect_panel$share_price * value_effect_panel$num_shares

value_effect_panel$b2m <- value_effect_panel$book_equity / value_effect_panel$market_cap

value_effect_panel$lev <- (value_effect_panel$lt_debt + value_effect_panel$debt_current) / value_effect_panel$total_assets

value_effect_panel$prof <- value_effect_panel$ebitda / value_effect_panel$total_assets

value_effect_panel$div_yield <- (value_effect_panel$dividends_total / value_effect_panel$num_shares) / value_effect_panel$share_price

value_effect_panel$size <- log(value_effect_panel$market_cap)

value_effect_panel$return <- value_effect_panel$excess_return

dir.create("data/clean")
save(value_effect_panel, "data/clean/value_effect_panel_clean.rda")

