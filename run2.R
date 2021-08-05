custom_predict <- function(object, newdata, positive_value) { pred <- predict(object, newdata, type = 'prob')
response <- as.vector(t(pred[paste('.pred_', positive_value, sep = '')]))
return(response)}

custom_data_expl <- function(recipe_workflow, dataset, target_variable) { 
  data_return <- as.data.frame(prep(recipe_workflow$pre$actions$recipe$recipe, dataset) %>% bake(dataset) %>% select(-target_variable))
  return(data_return)
}
custom_y_expl <- function(recipe_workflow, dataset, target_variable) { 
  data_return <- prep(recipe_workflow$pre$actions$recipe$recipe, dataset) %>% bake(dataset) %>% mutate(target_variable = ifelse(target_variable == 'good', 1, 0))  %>% pull(target_variable)
  return(data_return)
}
custom_model_expl <- function(recipe_workflow) {return(recipe_workflow$fit$fit)}

custom_new_obs <- function(recipe_workflow, dataset, target_variable, rownumber) {
  new_obs <- as.data.frame(prep(recipe_workflow$pre$actions$recipe$recipe, dataset) %>% bake(dataset) %>% select(-target_variable))[rownumber,]
  return(new_obs)
}

train <- GCR_train

explainer_randomforest <- DALEX::explain(
  model = custom_model_expl(model_fitted),
  data = custom_data_expl(model_fitted, train, "Risk"),
  y = custom_y_expl(model_fitted, train, "Risk"),
  label = "randomforest")

resids_randomforest <- DALEX::model_performance(explainer_randomforest)
resids_randomforest

test_explainer <- gen_explainer(model_fitted, train, 'Risk', label = 'label')

var <- train$Job

target_variable <- 'Risk'

setwd("C:/Users/Hendrik/Documents/Programming/R/GCR-ExpAI/scripts/explainability")

source("DALEX_script.R")

# Nieuwe functie!
####
make_vars(model_fitted, GCR_train, 'Risk', label = 'RandomForest')

