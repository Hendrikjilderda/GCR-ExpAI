################################################################################
##                                                                            ##
## Bestand met functies gemaakt voor de explainability van het                ##
## top service project.                                                       ##
##                                                                            ##
## Uitleg over functies staat in de readme.                                   ##
##                                                                            ##
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
}


################################################################################

#dataset level explanations

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
}
