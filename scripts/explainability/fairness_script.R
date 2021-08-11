if(!exists('fairness_model_fitted') || !exists('fairness_train') || !exists('fairness_target_variable')){
  stop('[debug]not able to make explainer because of missing variables')
  
} else {
  .GlobalEnv$fairness_explainer <- gen_tidy_explainer(DALEX_model_fitted, DALEX_train, DALEX_target_variable, label)
  
  try({
    fairness <- fairness_check(fairness_explainer)
    print(fairness)
    plot(fairness)
  })
}