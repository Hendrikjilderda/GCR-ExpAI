#eventuele package toevoegingen?
# https://cran.rstudio.com/web/packages/randomForestExplainer/vignettes/randomForestExplainer.html





setwd("C:/Users/Hendrik/Documents/Programming/R/GCR-ExpAI")

#loading dependencies
source("scripts/load_packages.R")

#data setup
source("scripts/load_dataset.R")
source("scripts/recipes.R")

#running different models
source("scripts/randomForest.R")
final_rf

#source("scripts/xgboost.R")
#final_xg

#source("scripts/svm.R")
#final_svm

#explainability
source("scripts/explainability/DALEX_functions.R")
make_vars(final_rf_fitted, GCR_train, 'Risk', label = 'RandomForest', 'Job')
source("scripts/explainability/DALEX_script.R")


#make_vars(final_xg_fitted, GCR_train, 'Risk', label = 'XGboost')
#source("scripts/explainability/DALEX_script.R")


#make_vars(final_svm_fitted, GCR_train, 'Risk', label = 'Support Vector Model')
#source("scripts/explainability/DALEX_script.R")

