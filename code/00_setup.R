# =======================================================
# Empirical Research in Finance - initial setup
#
# Purpose: Installs `renv` to create a reproducible env,
#          then the required packages (their dependencies) 
#          and restarts R session for a clean environment.
# Input: ---
# Output: ---
# =======================================================

# Prefer macOS-binaries where available, fall back to source if necessary (e.g., for Apple Silicon)
options(pkgType = "both")

renv_installed <- requireNamespace("renv", quietly = TRUE)

if (!renv_installed) { # ! is logical not
  install.packages("renv")
}

env_configured <- file.exists("renv/activate.R")

if (!env_configured) {
  renv::init(
    restart = FALSE # prevents interruption of script
    ) 
  
  renv::install(prompt = FALSE) # installs packages needed in other scripts (e.g. tidyverse, haven, etc.)
  renv::snapshot(prompt = FALSE) # makes renv.lock
} else {
  renv::restore(prompt = FALSE) # restores packages from renv.lock
}

renv::install("rstudioapi", prompt = FALSE) # to restart session afterwards

if (rstudioapi::hasFun("restartSession")) {
    rstudioapi::restartSession()
}