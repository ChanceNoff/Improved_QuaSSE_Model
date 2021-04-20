source("R/packages.model.R")  # loads packages
source("R/functions.model.R") # defines the create_plot() function
source("R/plan.model.R")      # creates the drake plan


make(
  plan.model
)
