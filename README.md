<div align="center">

# 🎯 missOutlier

### **Outlier Detection Using the MISS Method**

*A weighted composite of MAD, IQR, and SD for robust univariate outlier detection*

[![R](https://img.shields.io/badge/R-%3E%3D%203.5-blue?logo=r&logoColor=white)](https://www.r-project.org/)
[![PsyArXiv](https://img.shields.io/badge/PsyArXiv-10.31234%2Fosf.io%2F2r9yw__v2-red)](https://osf.io/preprints/psyarxiv/2r9yw_v2)

---

</div>

## Overview

**missOutlier** implements the **MISS** (MAD–IQR–SD Simultaneous) method, a new approach for univariate outlier detection that combines three classical techniques into a single robust threshold:

| Method | Bounds | Weight |
|--------|--------|--------|
| **MAD** (Median Absolute Deviation) | `median ± 1.5 × MAD` | 87.8% |
| **IQR** (Interquartile Range) | `Q25/Q75 ± 1 × IQR` | 1.2% |
| **SD** (Standard Deviation) | `mean ± 5 × SD` | 11.0% |

The composite threshold is computed as:

$$\text{MISS} = 0.878 \times \text{MAD} + 0.012 \times \text{IQR} + 0.11 \times \text{SD}$$

By heavily weighting the robust MAD while retaining sensitivity from IQR and SD, MISS offers a balanced approach that handles skewed and heavy-tailed distributions better than any single method alone.

---

## Installation

```r
# Install from GitHub
devtools::install_github("GuillaumePech/missOutlierR")

# Load the package
library(missOutlier)
```

---

## Quick Start

```r
library(missOutlier)

# Generate data with outliers
x <- c(rnorm(100), 50, -40)

# Default: replace outliers with NA
x_clean <- detect_outlier_miss(x)
#> Detected 2 outliers (1.96% of data) using MISS method.

# Drop outliers entirely
x_dropped <- detect_outlier_miss(x, drop = TRUE)
#> Detected 2 outliers (1.96% of data) using MISS method.

# Handle existing NAs
x_na <- c(rnorm(100), NA, 50)
x_clean <- detect_outlier_miss(x_na, na.rm = TRUE)

# Silent mode (no messages)
x_clean <- detect_outlier_miss(x, silent = TRUE)
```

---

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | numeric vector | — | Input data (must be one-dimensional) |
| `drop` | logical | `FALSE` | If `TRUE`, removes outliers. If `FALSE`, replaces them with `NA` |
| `na.rm` | logical | `FALSE` | If `TRUE`, ignores `NA` values when computing thresholds |
| `silent` | logical | `FALSE` | If `TRUE`, suppresses the detection message |

---

## How It Works

```
                ┌──────────────┐
                │  Input Data  │
                └──────┬───────┘
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
     ┌─────────┐ ┌─────────┐ ┌─────────┐
     │ 1.5 MAD │ │  1 IQR  │ │  5 SD   │
     │  ×0.878 │ │  ×0.012 │ │  ×0.11  │
     └────┬────┘ └────┬────┘ └────┬────┘
          │            │            │
          └────────────┼────────────┘
                       ▼
              ┌────────────────┐
              │ MISS Threshold │
              └────────┬───────┘
                       ▼
              ┌────────────────┐
              │ Flag Outliers  │
              └────────────────┘
```

---

## Citation

If you use this method or package in your research, please cite:

```bibtex

 Pech, G., Vaccaro, N., Caspar, E. A., Amerio, P., Cleeremans, A., Leys, C., & Ley, C. (2026). How not to MISS an outlier: comparing three classic univariate methods and introducing a new one, the MAD–IQR–SD Simultaneous (MISS). *PsyArXiv*. https://doi.org/10.31234/osf.io/2r9yw_v2

```

