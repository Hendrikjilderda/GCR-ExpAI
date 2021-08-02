GCR_recipe <- recipe(Risk ~ ., data = GCR_train) %>%
  step_rm(X) %>%
  step_other(Purpose, threshold = 0.15) %>% # is dit wel nodig? van 8 naar 4


step_mutate(
  Credit.amount = ifelse(Credit.amount > 3000, 'high', 'low'),

  Duration = ifelse(Duration > 20, 'long', 'short')
) %>%

  step_normalize(Age) %>%
  
  step_string2factor(all_nominal())
  
#nieuwe variabele maken met credit per maand?



GCR_prep <- prep(GCR_recipe)

GCR_juice <-juice(GCR_prep)
