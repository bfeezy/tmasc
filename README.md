
<!-- README.md is generated from README.Rmd. Please edit that file -->
tmasc
=====

Tidy data sets of reports of altered states of consciousness, suitable for text mining analyses.

tmasc currently contains two data sets, `erowid` and `dreamjournal`. These data sets are fairly large (about 50mb each), which leads to a long install time. Installing the package may take up to a few minutes. (You might also experience a few seconds delay when first calling the data sets in your R session.)

Installing
==========

The package is not available on CRAN, but can be easily installed from GitHub, using the devtools package.

``` r
# install.packages(devtools)  # Install if required
devtools::install_github("mvuorre/erowid")
```

Usage
=====

The package can then be loaded, and the contained data sets processed with familiar functions from the tidyverse packages.

``` r
library(tmasc)
library(tidyverse)
library(stringr)
```

Please see the [package's website](https://mvuorre.github.io/tmasc) for more information.
