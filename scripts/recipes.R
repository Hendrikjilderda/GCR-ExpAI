lvl <- c("no-job", 'low-pay', 'med-pay', 'high-pay')

GCR_recipe <- recipe(Risk ~ ., data = GCR_train) %>%

  step_mutate(Amount.month = Credit.amount / Duration) %>%
  step_string2factor(all_nominal(), -all_outcomes()) %>%
  # step_num2factor(Job, transform = function(x) x + 1, levels = lvl) %>%
  step_impute_knn(Saving.accounts,  Checking.account) %>%
  step_other(Purpose, threshold = 0.10, other = 'other_value') #%>% # is dit wel nodig? van 8 naar 4

# step_dummy(all_nominal(), -Risk) #dummy zorgt voor problemen in explainer!


  

#nieuwe variabele maken met credit per maand?


GCR_prep <- prep(GCR_recipe)

GCR_juice <-juice(GCR_prep)
