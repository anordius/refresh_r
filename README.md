# refresh_r

Refresh on R usage in real data analysis projects.

This repo walks through the workflow you actually use on a real R data
project: import & clean, wrangle & explore, visualize, and model — wired
together as a [`targets`](https://books.ropensci.org/targets/) pipeline
so each step only reruns when its inputs change.

## Structure

- `data/sales.csv` — raw sample sales data (with some missing values, like
  real data).
- `R/functions.R` — every pipeline step as a plain function: cleaning,
  summarising, pivoting, plotting, modeling.
- `_targets.R` — the pipeline definition: declares each target and how it
  depends on the others.
- `output/` — generated plots (git-ignored contents aside from `.gitkeep`).

## Requirements

```r
install.packages(c(
  "targets", "readr", "dplyr", "tidyr",
  "lubridate", "ggplot2", "broom"
))
```

## Running

From the repo root:

```r
targets::tar_make()
```

`targets` figures out the dependency graph from `_targets.R`, runs only
what's stale, and caches results in `_targets/` (not checked into git).

Inspect the pipeline graph before running:

```r
targets::tar_visnetwork()
```

Load any target's result into your session after a run:

```r
targets::tar_load(region_category_summary)
targets::tar_read(sales_model_tidy)
```

## Pipeline targets

1. `sales_file` / `sales` — read `data/sales.csv`, fix types, impute
   missing `units`, derive `net_amount` and `month`.
2. `region_category_summary`, `revenue_wide`, `top_customers`, `growth` —
   core `dplyr`/`tidyr` patterns: `group_by`/`summarise`, `pivot_wider`,
   window functions (`lag`, `slice_max`) for growth and top-N analysis.
3. `revenue_by_region_plot`, `monthly_category_plot` — `ggplot2` charts
   saved to `output/`.
4. `sales_model`, `sales_model_tidy`, `sales_model_fit` — an `lm()` model
   with tidy output via `broom`.
