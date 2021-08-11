#eventuele package toevoegingen?
# https://cran.rstudio.com/web/packages/randomForestExplainer/vignettes/randomForestExplainer.html

#https://rdrr.io/cran/ingredients/man/ceteris_paribus.html




setwd("C:/Users/Hendrik/Documents/Programming/R/GCR-ExpAI")

#loading dependencies
source("scripts/load_packages.R")

#data setup
source("scripts/load_dataset.R")
source("scripts/recipes.R")


#training and tuning RF
source("scripts/randomForest.R")
final_rf

#fairness RF
source("scripts/explainability/fairness_functions.R")
make_fairness_vars(final_rf_fitted, GCR_train, 'Risk', label = 'RandomForest', 'Housing', 'Housing')
source("scripts/explainability/fairness_script.R")

#explainabiliy RF
source("scripts/explainability/DALEX_functions.R")
make_vars(final_rf_fitted, GCR_train, 'Risk', label = 'RandomForest', 'Housing', 'Housing')
source("scripts/explainability/DALEX_script.R")





#testing ##############

resids_decisiontree <- DALEX::model_performance(explainer)

plot(resids_decisiontree)

bd_decisiontree <- breakDown::break_down(explainer, case, keep_distributions = TRUE)  #nog toevoegen

plot(bd_decisiontree)

# ook probleem met conversion
local_model_randomforest <- localModel::individual_surrogate_model(explainer, case, size = 1000, seed = 1313)

plot()








#################

source("scripts/xgboost.R")
final_xg

make_vars(final_xg_fitted, GCR_train, 'Risk', label = 'XGboost')
source("scripts/explainability/DALEX_script.R")

####

source("scripts/svm.R")
final_svm

make_vars(final_svm_fitted, GCR_train, 'Risk', label = 'Support Vector Model')
source("scripts/explainability/DALEX_script.R")

