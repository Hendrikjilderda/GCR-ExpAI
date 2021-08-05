GCR <- read.csv('./data/german_credit_data.csv',
                header = TRUE)

set.seed(123)

GCR <- GCR %>% select(-X, -Age)

GCR_split <- initial_split(GCR, strata = Risk)
GCR_train <- training(GCR_split)
GCR_test <- testing(GCR_split)
