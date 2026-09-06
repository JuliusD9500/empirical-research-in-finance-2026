# =======================================================
# Empirical Research in Finance - Group Assignment
#
# Purpose: Filter the sample, create variables and winsorize.
# Input: data/raw/value_effect_panel.dta
# Output: data/clean/value_effect_panel_clean.rda (final sample)
# =======================================================

library(tidyverse) # data wrangling
library(labelled) # variable labels

# Load raw data
data <- haven::read_dta("data/raw/value_effect_panel.dta") |>
  haven::zap_label()

# Filter data (balance sheet identity is violated; german firms only, no country filter needed)
data <- data |>
  filter(
    !(sic2 >= 60 & sic2 <= 69), # exclude financial firms
    total_assets > 0,           # for 'lev' and 'prof'
    num_shares > 0,             # for 'market_cap'
    share_price > 0,            # for 'market_cap' and 'size'
    complete.cases(             
      firm_id, year, sic2, excess_return,
      total_assets, num_shares, share_price,
      book_equity, lt_debt, debt_current, ebitda, dividends_total
    )
  )

# Create variables
data <- data |>
  mutate( # keep original and add new variables
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
    excess_return_w = winsorize(excess_return),
    b2m_w = winsorize(b2m), 
    lev_w = winsorize(lev),
    prof_w = winsorize(prof),
    div_yield_w = winsorize(div_yield),
    # not size bc. logarithm weakens large variations (span is plausibly)
  )

# Label variables
data <- data |>
  labelled::set_variable_labels(
    firm_id           = "Firm identifier",
    year              = "Calendar year",
    sic2              = "Industry (2-digit SIC)",

    total_assets      = "Total assets (EUR mn)",
    book_equity       = "Book equity (EUR mn)",
    lt_debt           = "Long-term debt (EUR mn)",
    debt_current      = "Debt in current liabilities (EUR mn)",
    total_liabilities = "Total liabilities (EUR mn)",
    ebitda            = "EBITDA (EUR mn)",
    num_shares        = "Shares outstanding (mn)",
    share_price       = "Year-end share price (EUR)",
    dividends_total   = "Total dividends (EUR mn)",
    total_sales       = "Net sales (EUR mn)",
    rf                = "Risk-free rate (decimal)",
    excess_return     = "Excess return at t+1 (decimal)",

    uk_exposure       = "UK sales share >= 10% in 2015",
    uk_listed         = "UK listing in 2015",

    # Constructed variables
    market_cap        = "Market capitalisation (EUR mn)",
    b2m               = "Book-to-market (ratio)",
    lev               = "Leverage (ratio)",
    prof              = "Profitability (ratio)",
    div_yield         = "Dividend yield (ratio)",
    size              = "Firm size (ln market capitalisation in EUR mn)",

    # Winsorized variables
    excess_return_w   = "Excess return at t+1 (winsorized, decimal)",
    b2m_w             = "Book-to-market (winsorized, ratio)",
    lev_w             = "Leverage (winsorized, ratio)",
    prof_w            = "Profitability (winsorized, ratio)",
    div_yield_w       = "Dividend yield (winsorized, ratio)"
  )

# Save cleaned data
save(data, file = "data/clean/value_effect_panel_clean.rda")
