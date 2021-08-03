# function for making tidymodel explainer. 
# In the return statement you can change parameters if needed.

tm_explainer <- function(fitted_model, 
                         dataset = NULL, 
                         target_var = NULL, 
                         label = NULL) {
  
  if(is.null(dataset)){
    warning('dataset not needed but recommended\n')
  }
  
  if(is.null(target_var)){
    warning('target variable not needed but recommended\n')
  }
  
  if(is.null(label)){
    warning('label not needed but highly recommended for plots')
  }
  
  return(
    explain_tidymodels(
      model = fitted_model,
      data = dataset,
      y = as.numeric(target_var),
      label = label,
      
      #defaults 
      weights = NULL,
      predict_function = NULL,
      residual_function = NULL,
      
      
      verbose = TRUE,
      precalculate = TRUE,
      colorize = TRUE,
      model_info = NULL,
      type = NULL
    )
  )
}

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