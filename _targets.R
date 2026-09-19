# _targets.R
# Pipeline definition. Run with targets::tar_make(); inspect with
# targets::tar_visnetwork(). Only stale targets re-run.

library(targets)

tar_option_set(
  packages = c("readr", "dplyr", "tidyr", "lubridate", "ggplot2", "broom")
)

source("R/functions.R")

list(
  tar_target(sales_file, "data/sales.csv", format = "file"),
  tar_target(sales, import_clean_sales(sales_file)),

  tar_target(region_category_summary, summarise_region_category(sales)),
  tar_target(revenue_wide, pivot_revenue_wide(region_category_summary)),
  tar_target(top_customers, top_customer_by_region(sales)),
  tar_target(growth, monthly_growth(sales)),

  tar_target(
    revenue_by_region_plot,
    plot_revenue_by_region(sales, "output/revenue_by_region.png"),
    format = "file"
  ),
  tar_target(
    monthly_category_plot,
    plot_monthly_category(sales, "output/monthly_revenue_by_category.png"),
    format = "file"
  ),

  tar_target(sales_model, fit_sales_model(sales)),
  tar_target(sales_model_tidy, broom::tidy(sales_model, conf.int = TRUE)),
  tar_target(sales_model_fit, broom::glance(sales_model))
)
