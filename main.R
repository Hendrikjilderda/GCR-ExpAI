
setwd("C:/Users/Hendrik/Documents/Programming/R/GCR-ExpAI")

#loading dependencies
source("scripts/load_packages.R")

#preloading explainability functions
source('scripts/explainer.R')
source("scripts/explainability_functions.R")


#data setup
source("scripts/load_dataset.R")
source("scripts/recipes.R")

source("scripts/randomForest.R")
source("scripts/xgboost.R")
source("scripts/svm.R")
