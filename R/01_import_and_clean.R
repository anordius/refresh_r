# 01_import_and_clean.R
# Read raw sales data, fix types, handle missing values, derive columns.

library(readr)
library(dplyr)
library(lubridate)

sales_raw <- read_csv("data/sales.csv", show_col_types = FALSE)

sales <- sales_raw %>%
  mutate(
    order_date = ymd(order_date),
    units = if_else(is.na(units), median(units, na.rm = TRUE), units),
    gross_amount = units * unit_price,
    net_amount = gross_amount * (1 - discount),
    month = floor_date(order_date, "month")
  )

# Quick sanity checks before moving on to analysis.
stopifnot(!anyNA(sales$units), !anyNA(sales$net_amount))

write_csv(sales, "data/sales_clean.csv")
