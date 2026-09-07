# =======================================================
# Empirical Research in Finance - Group Assignment
#
# Purpose:
# Input:
# Output:
# =======================================================
library(tidyverse)
library(haven)

#Load cleaned firm panel 
load("data/clean/value_effect_panel_clean.rda")  

#Load event-study summary file (no cleaning needed)
cars <- haven::read_dta("data/raw/cars_summary.dta") |> haven::zap_label()

# 1 . Event design 

event_date <- as.Date("2016-06-24") # Brexit announcement 
event_windows <- list(
  "[-1,+1]" = c(start = as.Date("2016-06-23"), end = as.Date("2016-06-27")),
  "[-2,+2]" = c(start = as.Date("2016-06-22"), end = as.Date("2016-06-28"))
)

The event window [-1, +1] and [-2, +2] are defined relative to the referendum result, which was announced on Friday, 24 June 2016. Since weekends and holidays are not considered trading days, for the event window [-1, +1], -1 falls on 23 June 2016 (Thursday) and +1 falls on 27 June 2016 (Monday, since the weekend of 25-26 June is skipped). Similarly, for the vent window [-2, +2], -2 falls on 28 June 2016 (Tuesday).  
