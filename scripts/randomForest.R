rf_model <-
  rand_forest(mtry = tune(), trees = 500, min_n = tune()) %>%
  set_engine("randomForest") %>%
  set_mode("classification")

rf_workflow <-
  workflow() %>%
  add_recipe(GCR_recipe) %>%
  add_model(rf_model)

set.seed(234)
folds <- vfold_cv(GCR_train, v = 5, repeats = 5)
grid <- expand.grid(mtry = 8 , min_n = 5 )    # 8 5 beste accuracy

doParallel::registerDoParallel()
tuned_rf <- tune_grid(rf_workflow, 
                      resamples = folds, 
                      grid = grid)

tuned_rf %>% 
  collect_metrics() %>%
  filter(.metric == "accuracy") %>%
  select(mean, min_n, mtry) %>%
  pivot_longer(min_n:mtry,
               values_to = "value",
               names_to = "parameter")

best_params <- tuned_rf %>%
  tune::select_best(metric = "accuracy")

final_rf <- finalize_model(
  rf_model, best_params
)

final_rf

final_rf_wf <- workflow() %>%
  add_recipe(GCR_recipe) %>%
  add_model(final_rf)

final_rf_fitted <- final_rf_wf %>% 
  fit(data = GCR_train)

final_rf_fitted %>%
  predict(new_data = GCR_test)

