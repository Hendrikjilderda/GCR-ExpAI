GCR_recipe <- recipe(Risk ~ ., data = GCR_train) %>%
  step_rm(X) %>%
  # update_role(X, new_role = "ID") %>%
  step_other(Purpose, threshold = 0.05) # is dit wel nodig? van 8 naar 5 
  
# step functions toevoegen?


GCR_prep <- prep(GCR_recipe)

GCR_juice <-juice(GCR_prep)
