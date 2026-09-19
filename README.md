# refresh_r

Refresh on R usage in real data analysis projects.

This repo walks through the workflow you actually use on a real R data
project: import & clean, wrangle & explore, visualize, and model. Each
step is a standalone script in `R/`, run in order against the sample
dataset in `data/sales.csv`.

## Scripts

1. `R/01_import_and_clean.R` — read raw CSV, fix types with `readr`/`lubridate`,
   impute missing values, derive columns, write `data/sales_clean.csv`.
2. `R/02_eda_and_wrangling.R` — core `dplyr`/`tidyr` patterns: `group_by`/`summarise`,
   `pivot_wider`, window functions (`lag`, `slice_max`) for growth and top-N analysis.
3. `R/03_visualization.R` — `ggplot2` patterns: sorted bar chart, faceted time series,
   saved to `output/`.
4. `R/04_modeling.R` — a linear model with `lm()` and tidy output via `broom`.

## Requirements

```r
install.packages(c("readr", "dplyr", "tidyr", "lubridate", "ggplot2", "broom"))
```

## Running

From the repo root:

```r
source("R/01_import_and_clean.R")
source("R/02_eda_and_wrangling.R")
source("R/03_visualization.R")
source("R/04_modeling.R")
```
