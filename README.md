# Empirical Research in Finance — Summer 2026

Coursework by Julius Diesing (636509) and Angeliki Tsekoura (633571)
at Humboldt-Universität zu Berlin.

The group report examines the value effect in a simulated panel of German listed
firms and market reactions to Brexit. The individual proposals focus on corporate
investment after Hurricane Helene.

## Reports

- [Julius Diesing — group report and individual proposal](paper/Diesing_636509.pdf)
- [Angeliki Tsekoura — group report and individual proposal](paper/Tsekoura_633571.pdf)

## Run the analysis

Using R 4.6.1, run the following from the repository root. The setup script restores
the required packages with `renv`.

```r
source("code/00_setup.R")
source("code/01_data_preparation.R")
source("code/02_task_a_descriptive_statistics.R", print.eval = TRUE)
source("code/03_tasks_b_g_regression_analysis.R", print.eval = TRUE)
source("code/04_task_h_event_study.R", print.eval = TRUE)
```

## Repository structure

- `code/` — R analysis scripts
- `data/` — original datasets and the prepared sample
- `paper/` — reports and source files
