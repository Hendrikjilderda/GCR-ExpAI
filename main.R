
setwd("C:/Users/Hendrik/Documents/Programming/R/GCR-ExpAI")

#loading dependencies
source("scripts/load_packages.R")

#preloading explainability functions
source("scripts/explainability_functions.R")


#data setup
source("scripts/load_dataset.R")
source("scripts/recipes.R")


#running different models
source("scripts/randomForest.R")
final_rf

source("scripts/xgboost.R")
final_xg

source("scripts/svm.R")
final_svm

#explainers setup
source('scripts/explainer.R')


