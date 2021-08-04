# in custom predict geprutst met welke object er gebruikt moet worden.
# origineel:

# custom_predict <- function(object, newdata, positive_value) { 
# pred <- predict(object, newdata, type = 'prob')
# response <- as.vector(pred$.pred_pos)
# return(response)}


custom_predict <- function(object, newdata) { 
  print('here')
  object %>% fit(data = newdata, formula = NULL)
  pred <- predict(object, newdata, type = 'prob') #problem
  print('here')
  response <- as.vector(pred$.pred_pos)
  return(response)
}


tm_explainer <- function(workflow, dataset, target_variable, label = NULL){
  .GlobalEnv$data <-
    as.data.frame(
      prep(workflow$pre$actions$recipe$recipe, dataset) %>%
        bake(dataset) %>%
        select(-target_variable)
      )
  
  head(data)
  
  #model uit de workflow gehaald
  .GlobalEnv$model <- workflow$fit$actions$model$spec
  
  
  fitted_wf <-
    workflow %>%
    fit(dataset)
  
  return_explainer <- explain_tidymodels(
    model = fitted_wf,
    data = data,
    y = as.numeric(as.factor(dataset[, target_variable])) , #problem
    label = label,
    
    #defaults kan worden aangepast
    weights = NULL,
    
    #hier custom predict neergezet. default = NULL -> geeft error
    predict_function = custom_predict(model, dataset), 
    residual_function = NULL,
    
    verbose = TRUE,
    precalculate = TRUE,
    colorize = TRUE,
    model_info = NULL,
    type = NULL
  )

  return(return_explainer)
}


#ideetjes:
# * 


################################################################################

#instance level explanations

  #Shapley Additive Explanations (https://ema.drwhy.ai/shapley.html)

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
  
  return(SHAP_val)
}



#########################

  # Ceteris-Paribus Profiles (https://ema.drwhy.ai/ceterisParibus.html) 

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
  
  return(CP_val)
}


################################################################################
#dataset instance level explanations

  # Variable Importance Measures (https://ema.drwhy.ai/featureImportance.html)

calc_VIP <- function(explainer){
  return_VIP <- DALEX::model_parts(
    explainer = explainer,
    loss_function = loss_root_mean_square
  )
  return(return_VIM)
}

VIP <- function(explainer) {
  VIP_Val <- calc_VIP(explainer)
  
  plot(SHAP_val) +
    ggtitle("Variable Importance Measures", "")
  
  return(VIP_Val)
}

########################

  # Partial Dependence Profiles (https://ema.drwhy.ai/partialDependenceProfiles.html)

calc_PDP <- function(variables, explainer) {
  PDP_val <- DALEX::model_profile(explainer = explainer,
                           variables = variable)
  
  return(PDP_val)
}

PDP <- function(variable, explainer) {
  return_PDP <- calc_PDP(variable, explainer)
  
  plot(pdp_rf) +  ggtitle(sprintf("Partial-dependence profile for %s", variable))
  
  return(PDP_val)
}







