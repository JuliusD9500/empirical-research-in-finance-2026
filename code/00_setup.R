# package installation
install.packages("renv")

# create package environment 
renv::init()

install.packages("haven") # read Stata files
install.packages("tidyverse") # collection for data science


renv::snapshot()
