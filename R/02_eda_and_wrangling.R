# 02_eda_and_wrangling.R
# Common tidyverse patterns for exploring a real dataset:
# group_by/summarise, pivoting, joins, and window functions.

library(dplyr)
library(tidyr)
library(readr)

sales <- read_csv("data/sales_clean.csv", show_col_types = FALSE)

# Revenue by region and category.
region_category_summary <- sales %>%
  group_by(region, category) %>%
  summarise(
    orders = n(),
    revenue = sum(net_amount),
    avg_order_value = mean(net_amount),
    .groups = "drop"
  ) %>%
  arrange(desc(revenue))

# Wide table: revenue per region, one column per category.
revenue_wide <- region_category_summary %>%
  select(region, category, revenue) %>%
  pivot_wider(names_from = category, values_from = revenue, values_fill = 0)

# Top customer per region using window functions instead of a join loop.
top_customer_by_region <- sales %>%
  group_by(region, customer) %>%
  summarise(customer_revenue = sum(net_amount), .groups = "drop") %>%
  group_by(region) %>%
  slice_max(customer_revenue, n = 1) %>%
  ungroup()

# Month-over-month growth per region.
monthly_growth <- sales %>%
  group_by(region, month) %>%
  summarise(revenue = sum(net_amount), .groups = "drop") %>%
  arrange(region, month) %>%
  group_by(region) %>%
  mutate(pct_change = (revenue - lag(revenue)) / lag(revenue)) %>%
  ungroup()

print(region_category_summary)
print(top_customer_by_region)
print(monthly_growth)
