#setting all the right variables
make_vars <- function(model_fitted, 
                      data, target_variable, label = NULL, 
                      cp_variables = NULL, 
                      pdp_variables = NULL){
  .GlobalEnv$DALEX_model_fitted <- model_fitted
  .GlobalEnv$DALEX_train <- data
  .GlobalEnv$DALEX_target_variable <- target_variable
  .GlobalEnv$label <- label
  .GlobalEnv$case <- data[sample(1:nrow(data),1),]
  .GlobalEnv$CP_var <- cp_variables
  .GlobalEnv$PDP_var <- pdp_variables
}

################################################################################

#explainer stuff
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
      model = model_fitted,
      data = train,
      y = custom_y_expl(model_fitted, train, target_variable),
      label = label)
  
  return(generated_explainer)
}



gen_explainer <- function(model_fitted, 
                          train, 
                          target_variable, 
                          label=NULL){
  generated_explainer <- explain(
    model = model_fitted,
    data = train,
    y = custom_y_expl(model_fitted, train, target_variable),
    label = label)
  
  return(generated_explainer)
}

################################################################################





