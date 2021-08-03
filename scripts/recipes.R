GCR_recipe <- recipe(Risk ~ ., data = GCR_train) %>%
  step_impute_knn(Saving.accounts,  Checking.account, neighbors = 5) %>%
    
  step_rm(X) %>%
  step_other(Purpose, threshold = 0.10) %>% # is dit wel nodig? van 8 naar 4


# step_mutate(
#   Credit.amount = ifelse(Credit.amount > 4000, 'high',
#                          ifelse(Credit.amount > 2000, 'medium', 'low')),
# 
#   Duration = ifelse(Duration > 25, 'long',
#                     ifelse(Duration > 15, 'medium','short'))
# ) %>%
  
  step_string2factor(all_nominal()) %>%

  step_dummy(all_nominal(), -Risk) 

  # step_normalize(Age) %>%
  

#nieuwe variabele maken met credit per maand?


GCR_prep <- prep(GCR_recipe)

GCR_juice <-juice(GCR_prep)
