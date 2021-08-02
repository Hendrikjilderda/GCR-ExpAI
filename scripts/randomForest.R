rf_model <-
  rand_forest(mtry = tune(), trees = 250, min_n = tune()) %>%
  set_engine("randomForest") %>%
  set_mode("classification")

rf_workflow <-
  workflow() %>%
  add_recipe(CGR_recipe) %>%
  add_model(rf_model)

set.seed(234)
folds <- vfold_cv(CGR, v = 3, repeats = 1)