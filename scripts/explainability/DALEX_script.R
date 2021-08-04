################################################################################
##                                                                            ##
##  Script voor explainability functions. De volgende variabelen moeten       ##
##  declared zijn:                                                            ##
##                                                                            ##
##  * workflow                                                                ##
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

#amount of functions
function_amount <- 4


explainer <- tm_explainer(workflow, dataset, target_variable, label)

list <- vector(mode = "list", length = function_amount)
plot_list <- vector(mode = "list", length = 0)

plot_counter <- 0 

######

if(!is.null(case)){
  plot_SHAP <- SHAP(case, explainer)
  list <- c(list, 1)
  
} else {
  warning('case not specified')
}


######

if (!is.null(variables) && !is.null(case)){
  plot_CP <- CP(case, variables, explainer)
  
  
  list <- c(list, 2)
} else{
  warning('variables or/and case not specified')

}


######
plot_VIP <- VIP(explainer)
list <- c(list, 3)

######
plot_PDP <- PDP(var, explainer)
list <- c(list, 4)





#combining plots into one plot
################################################################################
for(plot in list){
  switch (plot,
    1 = {
      if(!exists('plot_list')) {
        plot_list <- vector(mode = "list", length = 1)
        plot_list[1] <- plot_SHAP
      } else{
        plot_list <- c(plot_list, plot_SHAP)
      }
    },
    
    2 = {
      if(!exists('plot_list')) {
        plot_list <- vector(mode = "list", length = 1)
        plot_list[1] <- plot_CP
      } else{
        plot_list <- c(plot_list, plot_CP)
      }
    },
    
    3 = {
      if(!exists('plot_list')) {
        plot_list <- vector(mode = "list", length = 1)
        plot_list[1] <- plot_VIP
      } else{
        plot_list <- c(plot_list, plot_VIP)
      }
    },
    
    4 = {
      plot_list <- c(plot_list, plot_PDP)
    }
  )
}

#zou in theorie moeten werken?!
gridExtra::grid.arrange(plot_list)


