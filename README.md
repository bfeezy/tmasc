
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
devtools::install_github("mvuorre/tmasc")
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

References
==========

Scraping these data from the web was made possible by

-   Duncan Temple Lang and the CRAN Team (2016). XML: Tools for Parsing and Generating XML Within R and S-Plus. R package version 3.98-1.5. <https://CRAN.R-project.org/package=XML>

-   Garrett Grolemund, Hadley Wickham (2011). Dates and Times Made Easy with lubridate. Journal of Statistical Software, 40(3), 1-25. URL <http://www.jstatsoft.org/v40/i03/>.

-   Peter Solymos and Zygmunt Zawadzki (2016). pbapply: Adding Progress Bar to '\*apply' Functions. R package version 1.3-1. <https://CRAN.R-project.org/package=pbapply>

-   Hadley Wickham (2016). rvest: Easily Harvest (Scrape) Web Pages. R package version 0.3.2. <https://CRAN.R-project.org/package=rvest>

-   Hadley Wickham (2016). stringr: Simple, Consistent Wrappers for Common String Operations. R package version 1.1.0. <https://CRAN.R-project.org/package=stringr>

-   Hadley Wickham (2016). tidyverse: Easily Install and Load 'Tidyverse' Packages. R package version 1.0.0. <https://CRAN.R-project.org/package=tidyverse>

-   Hadley Wickham (2016). httr: Tools for Working with URLs and HTTP. R package version 1.2.1. <https://CRAN.R-project.org/package=httr>

-   Hadley Wickham (NA). pkgdown: Make Static HTML Documentation for a Package. R package version 0.1.0.9000. <https://github.com/hadley/pkgdown>

-   Hadley Wickham and Winston Chang (NA). devtools: Tools to Make Developing R Packages Easier. R package version 1.12.0.9000. <https://github.com/hadley/devtools>

If you use these data sets, please provide a link to this website, and cite tmasc:

``` r
citation("tmasc")
#> 
#> To cite package 'tmasc' in publications use:
#> 
#>   Matti Vuorre (2016). tmasc: Text Mining Altered States of
#>   Consciousness. R package version 0.2.5.
#>   https://github.com/mvuorre/tmasc
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {tmasc: Text Mining Altered States of Consciousness},
#>     author = {Matti Vuorre},
#>     year = {2016},
#>     note = {R package version 0.2.5},
#>     url = {https://github.com/mvuorre/tmasc},
#>   }
```

Additionally, please acknowledge any other software you use. Thanks, and have a good day.
