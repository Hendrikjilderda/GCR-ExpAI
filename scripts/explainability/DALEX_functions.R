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

calc_SHAP <- function(case, explainer) {
  case_shap <- DALEX::predict_parts(
    explainer = explainer,
    new_observation = case,
    type = "shap"
  )
  return(case_shap)
}


#deze functie callen voor volledig proces
SHAP <- function(case, explainer) {
  #calculate shap values
  SHAP_val <- calc_SHAP(case, explainer)
  
  #plot shap values, show_boxplots = FALSE ook mogelijk
  plot(SHAP_val) +
    ggtitle("Shapley Additive Explainations", "")
}



#########################

# Ceteris-Paribus Profiles 
#(https://ema.drwhy.ai/ceterisParibus.html) 

calc_CP <- function(case, explainer) {
  case_CP <- DALEX::predict_profile(explainer = explainer,
                                    new_observation = case)
}

CP <- function(case, variables, explainer) {
  #calculate Ceteris- paribus plots
  CP_val <- calc_CP(case, explainer)
  
  #plot Ceteris paribus profile
  plot(CP_val, variables = variables) +
    ggtitle("Ceteris-paribus profile", "") + ylim(0, 0.8)
}


################################################################################

#dataset level explanations

# Variable Importance Measures 
# (https://ema.drwhy.ai/featureImportance.html)

calc_VIP <- function(explainer){
  return_VIP <- DALEX::model_parts(
    explainer = explainer,
    loss_function = loss_root_mean_square
  )
  return(return_VIP)
}

VIP <- function(explainer) {
  .GlobalEnv$VIP_Val <- calc_VIP(explainer)
  
  plot(VIP_Val) +
    ggtitle("Variable Importance Measures", "")
}

########################

# Partial Dependence Profiles 
# (https://ema.drwhy.ai/partialDependenceProfiles.html)

calc_PDP <- function(variables, explainer) {
  PDP_val <- DALEX::model_profile(explainer = explainer,
                                  variables = variable)
  
  return(PDP_val)
}

PDP <- function(variable, explainer) {
  return_PDP <- calc_PDP(variable, explainer)
  
  plot(pdp_rf) +  ggtitle(sprintf("Partial-dependence profile for %s", variable)) 
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








