# =======================================================
# Empirical Research in Finance - initial setup
#
# Purpose: Restore the project packages at their saved versions.
# Input: renv.lock (run this script from the repository root)
# Output: Isolated project library in renv/library/
# =======================================================

renv_installed <- requireNamespace("renv", quietly = TRUE)

if (!renv_installed) { # ! is logical not
  install.packages("renv", repos = "https://cloud.r-project.org")
}

renv::load() # use this project's isolated package library
renv::restore(prompt = FALSE) # install the versions in renv.lock
