################################################################################
##                                                                            ##
##  Script voor explainability functions. De volgende variabelen moeten       ##
##  declared zijn:                                                            ##
##                                                                            ##
##  * model_fitted                                                            ##
##  * dataset                                                                 ##
##  * target_variable                                                         ##
##  * case (benodigd voor instance level explainations)                       ##
##  * variables (benodigd voor Ceteris-Paribus profiles)                      ##
##                                                                            ##
##  * var (benodigd voor Partial Dependence Profile)                          ##
##  * label (optioneel)                                                       ##
##                                                                            ##
##  Verder informatie staat in de readme                                      ##
##                                                                            ##
################################################################################


if(!exists('model_fitted') || !exists('train') || !exists('target_variable')){
  stop('not able to make explainer because of missing variables')
  
} else {
  
  if(!exists('tm_explainer') || !exists('SHAP') || 
     !exists('CP') ||  !exists('VIP') || 
     !exists('PDP')) {
    
    source("./DALEX_functions.R")
  }
  #amount of functions
  function_amount <- 4

  .GlobalEnv$explainer <- gen_explainer(model_fitted, train, target_variable, label = NULL)
  
  list <- vector(mode = "list", length = function_amount)
  plot_list <- vector(mode = "list", length = 0)
  
  plot_counter <- 0 
  
  print('expl created')######
  
  if(exists('case')){
    .GlobalEnv$plot_SHAP <- SHAP(case, explainer)
    list <- c(list, 1)
    
  } else {
    warning('case not specified')
  }
  
  
  print('SHAP made')######
  
  if (exists('variables') && exists('case')){
    plot_CP <- CP(case, variables, explainer)
    
    print('here')
    list <- c(list, 2)
  } else{
    warning('variables or/and case not specified')
  
  }
  
  
  print('CP made')######
  
  .GlobalEnv$plot_VIP <- VIP(explainer)
  list <- c(list, 3)
  
  print('VIP made')######
  
  .GlobalEnv$plot_PDP <- PDP(var, explainer)
  list <- c(list, 4)

  print('PDP made')
#combining plots into one plot
################################################################################
  for(plot in list){
    switch (plot,
      {
        if(!exists('plot_list')) {
          plot_list <- vector(mode = "list", length = 1)
          plot_list[1] <- plot_SHAP
        } else{
          plot_list <- c(plot_list, plot_SHAP)
        }
      },
      
      {
        if(!exists('plot_list')) {
          plot_list <- vector(mode = "list", length = 1)
          plot_list[1] <- plot_CP
        } else{
          plot_list <- c(plot_list, plot_CP)
        }
      },
      
      {
        if(!exists('plot_list')) {
          plot_list <- vector(mode = "list", length = 1)
          plot_list[1] <- plot_VIP
        } else{
          plot_list <- c(plot_list, plot_VIP)
        }
      },
      
      {
        plot_list <- c(plot_list, plot_PDP)
      }
    )
  }
  
  #zou in theorie moeten werken?!
  gridExtra::grid.arrange(plot_list)

}
