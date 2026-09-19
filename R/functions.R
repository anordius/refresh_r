# R/functions.R
# Pipeline steps as plain functions, called as targets from _targets.R.

import_clean_sales <- function(file) {
  raw <- readr::read_csv(file, show_col_types = FALSE)

  raw %>%
    dplyr::mutate(
      order_date = lubridate::ymd(order_date),
      units = dplyr::if_else(is.na(units), median(units, na.rm = TRUE), units),
      gross_amount = units * unit_price,
      net_amount = gross_amount * (1 - discount),
      month = lubridate::floor_date(order_date, "month")
    )
}

summarise_region_category <- function(sales) {
  sales %>%
    dplyr::group_by(region, category) %>%
    dplyr::summarise(
      orders = dplyr::n(),
      revenue = sum(net_amount),
      avg_order_value = mean(net_amount),
      .groups = "drop"
    ) %>%
    dplyr::arrange(dplyr::desc(revenue))
}

pivot_revenue_wide <- function(region_category_summary) {
  region_category_summary %>%
    dplyr::select(region, category, revenue) %>%
    tidyr::pivot_wider(names_from = category, values_from = revenue, values_fill = 0)
}

top_customer_by_region <- function(sales) {
  sales %>%
    dplyr::group_by(region, customer) %>%
    dplyr::summarise(customer_revenue = sum(net_amount), .groups = "drop") %>%
    dplyr::group_by(region) %>%
    dplyr::slice_max(customer_revenue, n = 1) %>%
    dplyr::ungroup()
}

monthly_growth <- function(sales) {
  sales %>%
    dplyr::group_by(region, month) %>%
    dplyr::summarise(revenue = sum(net_amount), .groups = "drop") %>%
    dplyr::arrange(region, month) %>%
    dplyr::group_by(region) %>%
    dplyr::mutate(pct_change = (revenue - dplyr::lag(revenue)) / dplyr::lag(revenue)) %>%
    dplyr::ungroup()
}

plot_revenue_by_region <- function(sales, out_file) {
  region_revenue <- sales %>%
    dplyr::group_by(region) %>%
    dplyr::summarise(revenue = sum(net_amount), .groups = "drop")

  p <- ggplot2::ggplot(region_revenue, ggplot2::aes(x = reorder(region, revenue), y = revenue)) +
    ggplot2::geom_col(fill = "#3b6ea5") +
    ggplot2::coord_flip() +
    ggplot2::labs(title = "Revenue by Region", x = NULL, y = "Revenue ($)") +
    ggplot2::theme_minimal()

  ggplot2::ggsave(out_file, p, width = 6, height = 4)
  out_file
}

plot_monthly_category <- function(sales, out_file) {
  monthly_category <- sales %>%
    dplyr::group_by(month, category) %>%
    dplyr::summarise(revenue = sum(net_amount), .groups = "drop")

  p <- ggplot2::ggplot(monthly_category, ggplot2::aes(x = month, y = revenue)) +
    ggplot2::geom_line(color = "#3b6ea5") +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~category, scales = "free_y") +
    ggplot2::labs(title = "Monthly Revenue by Category", x = NULL, y = "Revenue ($)") +
    ggplot2::theme_minimal()

  ggplot2::ggsave(out_file, p, width = 8, height = 4)
  out_file
}

fit_sales_model <- function(sales) {
  lm(units ~ discount + category + region, data = sales)
}
