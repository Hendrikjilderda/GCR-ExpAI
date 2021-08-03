

GCR_cv_folds <- 
  recipes::bake(
    GCR_prep, 
    new_data = training(GCR_split)
  ) %>%  
  rsample::vfold_cv(v = 5)


xgboost_model <- 
  parsnip::boost_tree(
    mode = "regression",
    trees = 1000,
    min_n = tune(),
    tree_depth = tune(),
    learn_rate = tune(),
    loss_reduction = tune()
  ) %>%
  set_engine("xgboost", objective = "reg:squarederror")



xgboost_params <- 
  dials::parameters(
    min_n(),
    tree_depth(),
    learn_rate(),
    loss_reduction()
  )


xgboost_grid <- 
  dials::grid_max_entropy(
    xgboost_params, 
    size = 60
  )


xgboost_wf <- 
  workflows::workflow() %>%
  add_model(xgboost_model) %>%
  add_formula(Risk ~ .)




doParallel::registerDoParallel()

tuned_xg <- tune::tune_grid(
  object = xgboost_wf,
  resamples = GCR_cv_folds,
  grid = xgboost_grid,
  metrics = yardstick::metric_set(rmse, rsq, mae),
  control = tune::control_grid(verbose = TRUE)
)
  
  
tuned_xg %>%
  tune::show_best(metric = "rmse") %>%
  knitr::kable()


xgboost_best_params <- xgboost_tuned %>%
  tune::select_best("rmse")
knitr::kable(xgboost_best_params)


xgboost_model_final <- xgboost_model %>% 
  finalize_model(xgboost_best_params)