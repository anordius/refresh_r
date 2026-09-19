# 04_modeling.R
# A simple, real-project-style regression: does discount level
# predict units sold, controlling for category and region?

library(dplyr)
library(readr)
library(broom)

sales <- read_csv("data/sales_clean.csv", show_col_types = FALSE)

model <- lm(units ~ discount + category + region, data = sales)

summary(model)

tidy_results <- tidy(model, conf.int = TRUE)
fit_stats <- glance(model)

print(tidy_results)
print(fit_stats)
