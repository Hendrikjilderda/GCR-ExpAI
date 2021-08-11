if(!exists('fairness_model_fitted') || !exists('fairness_train') || !exists('fairness_target_variable')){
  stop('[debug]not able to make explainer because of missing variables')
  
} else {
  .GlobalEnv$fairness_explainer <- gen_tidy_explainer(DALEX_model_fitted, fairness_train, fairness_target_variable, fairness_label)
  
  try({
    fairness <- fairness_checker(fairness_explainer)
    print(fairness)
    plot(fairness)
  })
}