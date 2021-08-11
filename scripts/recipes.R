lvl <- c("no-job", 'low-pay', 'med-pay', 'high-pay')

GCR$Job <- as.factor(GCR$Job)
# GCR$Age <- as.integer(GCR$Age)

GCR_recipe <- recipe(Risk ~ ., data = GCR_train) %>%

  step_mutate(Amount.month = Credit.amount / Duration) %>%
  step_string2factor(Sex,Housing, Saving.accounts, Checking.account,
                     Purpose, -all_outcomes()) %>%
  
  step_num2factor(Job, transform = function(x) x + 1, levels = lvl) %>%
  
  step_impute_knn(Saving.accounts,  Checking.account)


GCR_prep <- prep(GCR_recipe)

GCR_juice <-juice(GCR_prep)

