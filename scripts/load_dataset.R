CGR <- read.csv('./data/german_credit_data.csv',
                header = TRUE,
                stringsAsFactors = TRUE
                ) %>%
        na.omit(CGR)
