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
grid <- expand.grid(mtry = 1:9 , min_n = 1:7)    # 3 7 beste accuracy

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
               names_to = "parameter") %>%
  
  ggplot(aes(value, mean, color = parameter)) +
  geom_point(show.legend = FALSE) +
  facet_wrap(~parameter, scales = "free_x") +
  labs(x = NULL, y = "Accuracy")

best_params <- tuned_rf %>%
  tune::select_best(metric = "accuracy")

final_rf <- finalize_model(
  rf_model, best_params
)

final_rf

final_rf %>%
  set_engine('randomForest') %>%
  fit(Risk ~ ., data = GCR_juice  ) %>%
  vip::vip(geom= 'point')

final_wf <- workflow() %>%
  add_recipe(GCR_recipe) %>%
  add_model(final_rf)

final_res <- final_wf %>%
  last_fit(GCR_split)

final_res %>%
  collect_metrics()
