svm_model <- svm_poly(
  mtry = tune()
  trees = 500,
  min_n = tune()
) %>%
  set_engine("kernlab") %>%
  set_mode("classification")


svm_workflow <-
  workflow() %>%
  add_recipe(GCR_recipe) %>%
  add_model(svm_model)

folds <- vfold_cv(GCR_train, v = 5)
grid <-  expand.grid(mtry = 5:16 , min_n = 1:8)

doParallel::registerDoParallel()

tuned_svm <-
  svm_workflow %>%
  tune_grid(resamples = folds, grid = grid)

tuned_svm %>% collect_metrics()

svm_best_params <- 
  tuned_svm %>%
  tune::select_best('accuracy')

svm_model_final <- 
  svm_model %>%
  finalize_model(svm_best_params)
  


