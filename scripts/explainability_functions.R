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

