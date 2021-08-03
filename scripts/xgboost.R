

GCR_cv_folds <- 
  recipes::bake(
    GCR_prep, 
    new_data = training(GCR_split)
  ) %>%  
  rsample::vfold_cv(v = 5)


xgboost_model <- 
  boost_tree(
    mtry = tune(),
    trees = 1000,
    min_n = tune(),
  ) %>%
  set_engine("xgboost") %>%
  set_mode('classification')


xg_workflow <-
  workflow() %>%
  add_recipe(GCR_recipe) %>%
  add_model(xgboost_model)


ctrl <- control_resamples(save_pred = TRUE)
folds <- vfold_cv(GCR_train, v = 2, repeats = 3)
grid <-  expand.grid(mtry = 1:11, min_n = 1:11)



doParallel::registerDoParallel()

tuned_xg <- 
  xg_workflow %>%
  tune_grid(resamples = folds, grid = grid)
  
  
tuned_xg %>% collect_metrics()


xgboost_best_params <- tuned_xg %>%
  tune::select_best("accuracy")


xgboost_model_final <- xgboost_model %>% 
  finalize_model(xgboost_best_params)