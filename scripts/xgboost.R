
xg_mod <-  
  boost_tree(mtry = tune(), 
             tree_depth = 500, 
             min_n = tune()) %>%
  set_engine("xgboost") %>%
  set_mode("classification")

xg_workflow <-
  workflow() %>%
  add_recipe(GCR_recipe) %>%
  add_model(xg_mod)

ctrl <- control_resamples(Save_pred = TRUE)
folds <- vfold_cv(GCR_train, v = 5, repeats = 5)
grid <- expand.grid(mtry = 2:9, min_n = 2:9)

