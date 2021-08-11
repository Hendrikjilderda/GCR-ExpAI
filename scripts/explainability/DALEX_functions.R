################################################################################
##                                                                            ##
## Bestand met functies gemaakt voor de explainability van het                ##
## top service project.                                                       ##
##                                                                            ##
## Uitleg over functies staat in de readme.                                   ##
##                                                                            ##
################################################################################

#instance level explanations

#Shapley Additive Explanations 
#(https://ema.drwhy.ai/shapley.html)


SHAP <- function(case, explainer) {
  #calculate shap values
  SHAP_val <- DALEX::predict_parts(
    explainer = explainer,
    new_observation = case,
    type = "shap"
  )
  return(SHAP_val)
}

#########################

# Ceteris-Paribus Profiles 
#(https://ema.drwhy.ai/ceterisParibus.html) 


CP <- function(case, variables, explainer) {
  #calculate Ceteris- paribus plots
  CP_val <- ingredients::ceteris_paribus(x = explainer,
                                         new_observation = case)
  return(CP_val)
}

########################

# breakdown plots for interactions

BD <- function(explainer, case){
  BD_val <- iBreakDown::local_attributions(explainer , case, keep_distributions = TRUE)
  
  return(BD_val)
}

################################################################################

#dataset level explanations

# Variable Importance Measures 
# (https://ema.drwhy.ai/featureImportance.html)

VIP <- function(explainer) {
  VIP_Val <- DALEX::model_parts(
    explainer = explainer,
    loss_function = DALEX::loss_root_mean_square
  )
  return(VIP_Val)
}

########################

# Partial Dependence Profiles 
# (https://ema.drwhy.ai/partialDependenceProfiles.html)

PDP <- function(variable, explainer) {
  PDP_val <- DALEX::model_profile(explainer = explainer,
                                     variables = variable)
  return(PDP_val)
}

################################################################################

#explainer dependency functions

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

#########################
# explainer

gen_explainer <- function(model_fitted, train, target_variable, label=NULL){
  generated_explainer <- 
    DALEXtra::explain_tidymodels(
    model = model_fitted,
    data = train,
    y = custom_y_expl(model_fitted, train, target_variable),
    label = label)
  
  return(generated_explainer)
}



gen_explainer2 <- function(model_fitted, train, target_variable, label=NULL){
  generated_explainer <- explain(
      model = model_fitted,
      data = train,
      y = custom_y_expl(model_fitted, train, target_variable),
      label = label)
  
  return(generated_explainer)
}


################################################################################
make_vars <- function(model_fitted, data, target_variable, label = NULL, cp_variables = NULL, pdp_variables = NULL){
  .GlobalEnv$DALEX_model_fitted <- model_fitted
  .GlobalEnv$DALEX_train <- data
  .GlobalEnv$DALEX_target_variable <- target_variable
  .GlobalEnv$label <- label
  .GlobalEnv$case <- data[sample(1:nrow(data),1),]
  .GlobalEnv$CP_var <- cp_variables
  .GlobalEnv$PDP_var <- pdp_variables
}
