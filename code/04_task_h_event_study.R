# =======================================================
# Empirical Research in Finance - Group Assignment
#
# Purpose: A comparison of the stock price reaction to the Brexit referendum between UK-exposed and non-exposed German firms.
# Input:
# Output:
# =======================================================
library(tidyverse)
library(haven)

#Load cleaned firm panel 
load("data/clean/value_effect_panel_clean.rda")  

#Load event-study summary file (no cleaning needed)
cars <- haven::read_dta("data/raw/cars_summary.dta") |> haven::zap_label()

# 1. Event design 

event_date <- as.Date("2016-06-24") # Brexit announcement 
event_windows <- list(
  "[-1,+1]" = c(start = as.Date("2016-06-23"), end = as.Date("2016-06-27")),
  "[-2,+2]" = c(start = as.Date("2016-06-22"), end = as.Date("2016-06-28"))
)

# The event window [-1, +1] and [-2, +2] are defined relative to the referendum result, which was announced on Friday, 24 June 2016. Since weekends and holidays are not considered trading days, for the event window [-1, +1], -1 falls on 23 June 2016 (Thursday) and +1 falls on 27 June 2016 (Monday, since the weekend of 25-26 June is skipped). Similarly, for the vent window [-2, +2], -2 falls on 28 June 2016 (Tuesday).  

# 2. Sample composition

# sanity check: uk_exposure / uk_listed should be fixed per firm
data |>
  group_by(firm_id) |>
  summarise(n_exp = n_distinct(uk_exposure), n_listed = n_distinct(uk_listed)) |>
  filter(n_exp > 1 | n_listed > 1)   # should return 0 rows

firm_level <- data |>
  distinct(firm_id, uk_exposure, uk_listed)

# counts under each definition
firm_level |> count(uk_exposure)
firm_level |> count(uk_listed)

# cross-tabulation
cross_tab <- firm_level |>
  count(uk_exposure, uk_listed) |>
  pivot_wider(names_from = uk_listed, values_from = n, values_fill = 0)
cross_tab

# firms classified differently across the two definitions
n_different <- firm_level |>
  filter(uk_exposure != uk_listed) |>
  nrow()
n_different

# Results explained 

# Final sample: 230 firms (2664 firm-year observations)
#
# Treated/control counts under each definition:
#   UK sales exposure: ( dummy variable -> if the firm gets ≥10% of its sales from the UK. 1 = yes (exposed), 0 = no.): 54 treated (1), 176 control (0)
#   UK listing status: ( dummy variable -> the firm's shares are also traded on a UK stock exchange. 1 = yes (listed), 0 = no.)  40 treated (1), 190 control (0)
#   4 possible pairings: (0,0), (0,1), (1,0), (1,1)

# Cross-tabulation (UK sales exposure x UK listing status):
#
#                      UK not listed (0)   UK listed (1)     Total
#   UK sales exp < 10% (0)     146 (0,0)          30 (0,1)     176
#   UK sales exp >= 10% (1)     44 (1,0)          10 (1,1)      54
#   Total                      190               40           230

# The top-left cell with the number 146 means that 146 firms have less than 10% UK sales and are not UK-listed -> firms with no UK connection under either measure. 
# The bottom-right cell with the number 10 means that 10 firms have both ≥10% UK sales and are UK-listed -> firms connected to the UK under both measures.
# 74 (30+44) (32% of the sample)  
# 30 firms are UK-listed but do not meet the 10% sales-exposure threshold
# 44 firms have >=10% UK sales exposure but are not UK-listed.
# This indicates the two definitions disagree. 
# aspects of a firm's UK relationship (revenue exposure vs.listing venue), not the same underlying concept.

