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

# function for updating explainer.
# possible to update data, label or both.

update__tm_explainer <- function(explainer, 
                                 new_dataset = NULL, 
                                 new_target_var = NULL, 
                                 new_label = NULL ){
  
  if(!is.null(new_dataset) && is.null(new_label)){
    if(is.null(new_target_var)){
      warning('target variable not needed but recommended\n')
    }
    
    new_explainer <- update_data(explainer, 
                                 new_dataset, 
                                 new_target_var, 
                                 verbose = TRUE)
    return(new_explainer)
    
  }
  else if(is.null(new_dataset) && !is.null(new_label)){
    new_explainer <- update_label(explainer, 
                                  new_label, 
                                  verbose = TRUE)
    return(new_explainer)
  }
  else{
    new_data_explainer <- update_data(explainer, 
                                      new_dataset, 
                                      new_target_var, 
                                      verbose = TRUE)
    new_explainer <-update_label(explainer, 
                                 new_label, 
                                 verbose = TRUE)
    return(new_explainer)
  }
}

################################################################################

#variable importance measures
#https://ema.drwhy.ai/featureImportance.html#featureImportanceR

#aanpassingen:
# zorgen dat explainer van te voren al vast staat. evt maken in functie te veel troep?

#to do:
# plotten werkt nog niet wanneer in functie gedaan wordt?
single_custom_model_parts <- function(explainer = NULL, 
                                      
                                      workflow = NULL, 
                                      test_dataset = NULL, 
                                      target_Var = NULL, 
                                      
                                      lossfunction = NULL, 
                                      B = 10) {
  
  if(is.null(explainer)){
    
    if(is.null(workflow) || is.null(dataset) || is.null(target_var)){
      stop("explainer not given nor able to create one.")
    }
    
    else{
      explainer <-- tm_explainer(workflow, 
                                 dataset, 
                                 target_Var)
    }
  }
  
  explainer_rf <- explainer1
  b <- 10
  set.seed(NULL)
  if(is.null(lossfunction)){
    res_model_parts <- model_parts(explainer = explainer_rf)
    
  }
  else{
    res_model_parts <-model_parts(explainer = explainer, 
                                  loss_function = lossfunction,
                                  B = B)
  }
  
  head(res_model_parts, 10)
  plot(res_model_parts) +
    ggtitle(sprintf("Mean variable importance over %s permutations", B))
  
  
  return(res_model_parts)
}

################################################################################

#to do:
#werkt nu alleen als er 3 explainers zijn. nog fixen met 2.

#niet zeker of B al werkt.

multi_custom_model_parts <- function(explainer1 = NULL, 
                                     explainer2 = NULL, 
                                     explainer3 = NULL, 
                                     lossfunction = NULL,
                                     B = 10){
  if(!is.null(explainer1) && !is.null(explainer2)){
    if(is.null(lossfunction)){
      res_model_parts1 <- model_parts(explainer = explainer1)
      
      res_model_parts2 <- model_parts(explainer = explainer2)
    }
    
    else{
      res_model_parts1 <- model_parts(explainer = explainer1, 
                                      loss_function = lossfunction,
                                      B = B)
      
      res_model_parts2 <- model_parts(explainer = explainer2, 
                                      loss_function = lossfunction,
                                      B = B)
    }
    double <- c(res_model_parts1, res_model_parts2)
    return(double)
    
  }
  
  else if(!is.null(explainer1) && !is.null(explainer3)){
    if(is.null(lossfunction)){
      res_model_parts1 <- model_parts(explainer = explainer1)
      
      res_model_parts3 <- model_parts(explainer = explainer3)
    }
    
    else{
      res_model_parts1 <- model_parts(explainer = explainer1, 
                                      loss_function = lossfunction,
                                      B = B)
      
      res_model_parts3 <- model_parts(explainer = explainer3, 
                                      loss_function = lossfunction,
                                      B = B)
    }
    double <- c(res_model_parts1, res_model_parts3)
    return(double)
    
  }
  
  else if (!is.null(explainer2) && !is.null(explainer3)){
    if(is.null(lossfunction)){
      res_model_parts2 <- model_parts(explainer = explainer2)
      
      res_model_parts3 <- model_parts(explainer = explainer3)
    }
    
    else{
      res_model_parts2 <- model_parts(explainer = explainer2, 
                                      loss_function = lossfunction,
                                      B = B)
      
      res_model_parts3 <- model_parts(explainer = explainer3, 
                                      loss_function = lossfunction,
                                      B = B)
    }
    double <- c(res_model_parts2, res_model_parts3)
    return(double)
  }
  
  else{
    if(is.null(lossfunction)){
      res_model_parts1 <- model_parts(explainer = explainer1)
      
      res_model_parts2 <- model_parts(explainer = explainer2)
      
      
      res_model_parts3 <- model_parts(explainer = explainer3)
    }
    else{
      res_model_parts1 <- model_parts(explainer = explainer1, 
                                      loss_function = lossfunction,
                                      B = B)
      
      res_model_parts2 <- model_parts(explainer = explainer2, 
                                      loss_function = lossfunction,
                                      B = B)
      
      res_model_parts3 <- model_parts(explainer = explainer3, 
                                      loss_function = lossfunction,
                                      B = B)
    }
    
    #plot(res_model_parts1, res_model_parts2, res_model_parts3) +
    #ggtitle(sprintf("Mean variable importance over %s permutations", B), "") 
    
    
    
    triple <- c(res_model_parts1, res_model_parts2, res_model_parts3)
    return(triple)
  }
}

################################################################################


#Partial-dependence Profiles/Plots
# https://ema.drwhy.ai/partialDependenceProfiles.html#PDPIntro

# aanpassingen:
# /

# to do:
# probleem met variabelen die double en geen ints zijn

compare_pdp <- function(explainer1 = NULL, 
                        explainer2 = NULL, 
                        wanted_variable = NULL){
  
  if(is.null(explainer1) || is.null(explainer2)){
    stop("only one or no explainers given.")
  }
  pdp1 <- model_profile(explainer = explainer1, 
                        variable = wanted_variable) 
  pdp2 <- model_profile(explainer = explainer2, 
                        variable = wanted_variable)
  
  plot(pdp1, pdp2) +
    ggtitle(sprintf("Partial-dependence profiles for %s for two models", 
                    wanted_variable)) 
  
  double = c(pdp1, pdp2)
  return(double)
}

