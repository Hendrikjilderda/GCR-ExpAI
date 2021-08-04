#fitting workflows
fitted_rf <-
  final_rf_wf %>%
  fit(GCR_test)

fitted_xg <-
  final_xg_wf %>%
  fit(GCR_test)
  
fitted_svm <-
  final_svm_wf %>%
  fit(GCR_test)


#rf explainer
tm_explainer(fitted_rf, 
             dataset = GCR_test, 
             target_var = GCR_test$Risk,
             label = 'Random Forest')


explain_tidymodels(model = fitted_rf,
                   data = GCR_test,
                   y = GCR_test$risk,
                   label = 'Random Forest')


#xg explainer
tm_explainer(fitted_xg,
             dataset = GCR_test,
             target_var = GCR_test$Risk,
             label = 'XG boost')

#svm explainer
tm_explainer(fitted_svm,
             dataset = GCR_test,
             target_var = GCR_test$Risk,
             label = 'Support Vector Machine')

