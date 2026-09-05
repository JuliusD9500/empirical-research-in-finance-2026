# =======================================================
# Empirical Research in Finance - (a)
#
# Purpose: Import data and clean it
# Input: data/clean/value_effect_panel_clean.rda
# Output: ---
# =======================================================

library(dplyr)
library(modelsummary)

load("data/clean/value_effect_panel_clean.rda")

# 1. Variablen sauber auswählen und benennen
df_stats <- data |>
  select(
    `Excess return ($t+1$)` = excess_return_w,
    `Book-to-market`        = b2m_w,
    `Leverage`              = lev_w,
    `Profitability`         = prof_w,
    `Dividend yield`        = div_yield_w,
    `Size`                  = size,
    `Market cap (EUR mn)`   = market_cap
  )

# 2. Kennzahlen definieren (inklusive p10, p90)
p10 <- function(x) quantile(x, 0.10, na.rm = TRUE)
p90 <- function(x) quantile(x, 0.90, na.rm = TRUE)

# 3. Formel für datasummary (Zeilen ~ Spalten)
# Exportiert direkt als LaTeX-Fragment mit booktabs-Linien
datasummary(
  All(df_stats) ~ Mean + SD + Min + p10 + Median + p90 + Max,
  data = df_stats,
  output = "output/tables/table_1_descriptive_statistics.tex",
  fmt = 3 # 3 Nachkommastellen
)