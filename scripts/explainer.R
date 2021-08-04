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
tm_explainer(final_rf, 
             dataset = GCR_test, 
             target_var = GCR_test$Risk,
             label = 'Random Forest')

#xg explainer
tm_explainer(final_xg,
             dataset = GCR_test,
             target_var = GCR_test$Risk,
             label = 'XG boost')

#svm explainer
tm_explainer(final_svm,
             dataset = GCR_test,
             target_var = GCR_test$Risk,
             label = 'Support Vector Machine')

