# 03_visualization.R
# ggplot2 patterns you reach for constantly in real projects:
# bar charts with reordering, faceting, and a time series line.

library(dplyr)
library(readr)
library(ggplot2)

sales <- read_csv("data/sales_clean.csv", show_col_types = FALSE)

dir.create("output", showWarnings = FALSE)

# Revenue by region, bars sorted by value.
region_revenue <- sales %>%
  group_by(region) %>%
  summarise(revenue = sum(net_amount), .groups = "drop")

p1 <- ggplot(region_revenue, aes(x = reorder(region, revenue), y = revenue)) +
  geom_col(fill = "#3b6ea5") +
  coord_flip() +
  labs(title = "Revenue by Region", x = NULL, y = "Revenue ($)") +
  theme_minimal()

ggsave("output/revenue_by_region.png", p1, width = 6, height = 4)

# Revenue over time, faceted by category.
monthly_category <- sales %>%
  group_by(month, category) %>%
  summarise(revenue = sum(net_amount), .groups = "drop")

p2 <- ggplot(monthly_category, aes(x = month, y = revenue)) +
  geom_line(color = "#3b6ea5") +
  geom_point() +
  facet_wrap(~category, scales = "free_y") +
  labs(title = "Monthly Revenue by Category", x = NULL, y = "Revenue ($)") +
  theme_minimal()

ggsave("output/monthly_revenue_by_category.png", p2, width = 8, height = 4)
