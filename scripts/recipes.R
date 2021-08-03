GCR_recipe <- recipe(Risk ~ ., data = GCR_train) %>%
    
  step_rm(X) %>%
  step_rm(Age) %>%


step_mutate(
  Amount.month = Credit.amount / Duration,

  
  # 
  # werkt het beste zonder splitsing in kleinere variabelen +/- 2%
  #
  # Credit.amount = ifelse(Credit.amount > 4000, 'high',
  #                        ifelse(Credit.amount > 2000, 'medium', 'low')),
  # 
  # Duration = ifelse(Duration > 25, 'long',
  #                   ifelse(Duration > 15, 'medium','short')),
  # 
  # Amount.month = ifelse(Amount.month > 170, 'high', 'low')

) %>%
  
  step_string2factor(all_nominal()) %>%
  
  step_impute_knn(Saving.accounts,  Checking.account) %>%
  
  
  # step_normalize(Age) %>%
  step_other(Purpose, threshold = 0.10, other = 'other_value') %>% # is dit wel nodig? van 8 naar 4

  step_dummy(all_nominal(), -Risk) 


  

#nieuwe variabele maken met credit per maand?


GCR_prep <- prep(GCR_recipe)

GCR_juice <-juice(GCR_prep)
