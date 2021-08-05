svm_model <- 
  svm_poly() %>%
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

final_svm <- 
  svm_model %>%
  finalize_model(svm_best_params)
  
final_svm

final_svm_wf <-
  workflow() %>%
  add_recipe(GCR_recipe) %>%
  add_model(final_svm)

final_svm_fitted <- final_svm_wf %>% 
  fit(data = GCR_train)

final_svm_fitted %>%
  predict(new_data = GCR_test)
  

