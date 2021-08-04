#fitting workflows

  final_rf_wf %>%
  fit(GCR_test)

fitted_xg <-
  final_xg_wf %>%
  fit(GCR_test)
  
fitted_svm <-
  final_svm_wf %>%
  fit(GCR_test)


test <- GCR_test %>% -GCR_test$Risk


explain_test <- tm_explainer(final_rf_wf, GCR_train, 'Risk')






#rf explainer
rf_explainer <- tm_explainer(fitted_rf, 
                             dataset = GCR_test[-11], 
                             target_var = as.factor(GCR_test$Risk),
                             label = 'Random Forest')


explain_tidymodels(model = fitted_rf,
                   data = GCR_test[-11],
                   y = as.numeric(as.factor(GCR_test$Risk)),
                   label = 'Random Forest')


#xg explainer
xg_explainer <- tm_explainer(fitted_xg,
                             dataset = GCR_test,
                             target_var = as.factor(GCR_test$Risk),
                             label = 'XG boost')

#svm explainer
svm_explainer <- tm_explainer(fitted_svm,
                              dataset = GCR_test,
                              target_var = GCR_test$Risk,
                              label = 'Support Vector Machine')

