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

# (3) Statistical tests -- UK sales exposure

# CAR = cumulative abnormal return, SE = standard error,
# t-stat = CAR / SE, sig = significance stars based on the t-stat

windows <- list(
  "Event day" = 0,
  "[-1,+1]"   = -1:1,
  "[-2,+2]"   = -2:2
)

# sum daily AARs into CAR, scale SE by sqrt(window length), and get
# treated/control/difference. for the difference row we add variances
# (not SEs directly) since treated and control are independent groups
car_table_exposure <- map_dfr(names(windows), function(win_name) {
  win_days <- windows[[win_name]]

  cars |>
    filter(def == "uk_exposure", evttime %in% win_days) |>
    group_by(group) |>
    summarise(
      CAR = sum(aar_m),
      SE  = unique(aar_se) * sqrt(length(win_days)),
      .groups = "drop"
    ) |>
    pivot_wider(names_from = group, values_from = c(CAR, SE)) |>
    mutate(
      CAR_difference = CAR_treated - CAR_control,
      SE_difference  = sqrt(SE_treated^2 + SE_control^2),
      window = win_name
    )
}) |>
  pivot_longer(
    cols = c(CAR_treated, CAR_control, CAR_difference, SE_treated, SE_control, SE_difference),
    names_to = c(".value", "group"),
    names_pattern = "(CAR|SE)_(.*)"
  ) |>
  mutate(
    t_stat = CAR / SE,
    sig = case_when(
      2 * (1 - pnorm(abs(t_stat))) < 0.01 ~ "***",
      2 * (1 - pnorm(abs(t_stat))) < 0.05 ~ "**",
      2 * (1 - pnorm(abs(t_stat))) < 0.10 ~ "*",
      TRUE ~ ""
    )
  ) |>
  select(window, group, CAR, SE, t_stat, sig)

car_table_exposure

# results:
# treated firms drop around 4.7-4.9% in every window and it's super
# significant (t around -13 to -29). control firms barely move at all
# and aren't significant. the difference between the two groups is
# also huge and significant (t around -12 to -25), so UK sales
# exposure really does seem to explain a big chunk of the reaction

# ============================================================
# (4) Robustness check -- UK listing status
# ============================================================
# same test as (3), just swapping in the UK listing dummy instead
car_table_listed <- map_dfr(names(windows), function(win_name) {
  win_days <- windows[[win_name]]

  cars |>
    filter(def == "uk_listed", evttime %in% win_days) |>
    group_by(group) |>
    summarise(
      CAR = sum(aar_m),
      SE  = unique(aar_se) * sqrt(length(win_days)),
      .groups = "drop"
    ) |>
    pivot_wider(names_from = group, values_from = c(CAR, SE)) |>
    mutate(
      CAR_difference = CAR_treated - CAR_control,
      SE_difference  = sqrt(SE_treated^2 + SE_control^2),
      window = win_name
    )
}) |>
  pivot_longer(
    cols = c(CAR_treated, CAR_control, CAR_difference, SE_treated, SE_control, SE_difference),
    names_to = c(".value", "group"),
    names_pattern = "(CAR|SE)_(.*)"
  ) |>
  mutate(
    t_stat = CAR / SE,
    sig = case_when(
      2 * (1 - pnorm(abs(t_stat))) < 0.01 ~ "***",
      2 * (1 - pnorm(abs(t_stat))) < 0.05 ~ "**",
      2 * (1 - pnorm(abs(t_stat))) < 0.10 ~ "*",
      TRUE ~ ""
    )
  ) |>
  select(window, group, CAR, SE, t_stat, sig)

car_table_listed

# results:
# this time both treated AND control firms drop by about the same
# amount (around 1-1.2%), and both are significant on their own. but
# the difference between them is tiny and never significant (t only
# around 0.36-0.40). so being UK-listed doesn't really separate firms
# that got hit harder from ones that didn't -- unlike sales exposure,
# this definition doesn't seem to capture real Brexit exposure
