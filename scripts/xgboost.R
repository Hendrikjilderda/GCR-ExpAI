
xgboost_model <- 
  boost_tree(
    mtry = tune(),
    trees = 500,
    min_n = tune(),
  ) %>%
  set_engine("xgboost") %>%
  set_mode('classification')


xg_workflow <-
  workflow() %>%
  add_recipe(GCR_recipe) %>%
  add_model(xgboost_model)


ctrl <- control_resamples(save_pred = TRUE)
folds <- vfold_cv(GCR_train, v = 5)
grid <-  expand.grid(mtry = 5:16 , min_n = 1:8)



doParallel::registerDoParallel()

tuned_xg <- 
  xg_workflow %>%
  tune_grid(resamples = folds, grid = grid)
  
  
tuned_xg %>% collect_metrics()


xgboost_best_params <- tuned_xg %>%
  tune::select_best("accuracy")


xgboost_model_final <- xgboost_model %>% 
  finalize_model(xgboost_best_params)

# mtry 6 , min n 4