#setting all the right variables
make_fairness_vars <- function(model_fitted, 
                      data, target_variable, label = NULL, 
                      cp_variables = NULL, 
                      pdp_variables = NULL){
  .GlobalEnv$fairness_model_fitted <- model_fitted
  .GlobalEnv$fairness_train <- data
  .GlobalEnv$fairness_target_variable <- target_variable
  .GlobalEnv$fairness_label <- label
  .GlobalEnv$fairness_case <- data[sample(1:nrow(data),1),]
  .GlobalEnv$CP_var <- cp_variables
  .GlobalEnv$PDP_var <- pdp_variables
}

################################################################################

# explainer stuff
custom_y_expl <- function(recipe_workflow, dataset, target_variable) { 
  data_return <- prep(recipe_workflow$pre$actions$recipe$recipe, dataset) %>% 
    (dataset) %>% 
    mutate(target_variable = ifelse(target_variable == 'good', 1, 0))  %>% 
    pull(target_variable)
  return(data_return)
}

gen_tidy_explainer <- function(model_fitted, 
                               train, 
                               target_variable, 
                               label=NULL){
  generated_explainer <- 
    DALEXtra::explain_tidymodels(
      model = fairness_model_fitted,
      data = fairness_train,
      y = custom_y_expl(fairness_model_fitted, fairness_train, fairness_target_variable),
      label = fairness_label)
  
  return(generated_explainer)
}



gen_explainer <- function(model_fitted, 
                          train, 
                          target_variable, 
                          label=NULL){
  generated_explainer <- explain(
    model = fairness_model_fitted,
    data = fairness_train,
    y = custom_y_expl(fairness_model_fitted, fairness_train, fairness_target_variable),
    label = fairness_label)
  
  return(generated_explainer)
}

################################################################################

fairness_check <- function(explainer){
  fairness_object <- fairness_check(explainer,
                                    protected = fairness_train$fairness_target_variable)
  return(fairness_object)
}



