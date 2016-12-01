# Scrape to local files

# Every report listed on the index page
# https://www.erowid.org/experiences/exp.cgi?ShowViews=0&Cellar=0&Start=0&Max=100
# Is scraped in RAW format to an R list

library(tidyverse)
library(tidytext)
library(httr)
library(XML)
library(stringr)
library(lubridate)
library(rvest)
library(pbapply)

# Functions ---------------------------------------------------------------

read_urls <- function(url){
    # cat(paste(id, " "))  # Display progress
    out <- tryCatch(
        {   # Read URL and return raw content
            doc <- content(GET(url), "raw")
            # fn <- paste0("erowid-raw/",
            #              str_split(url, "ID=", simplify=T)[,2], ".rda")
            # save(doc, file = fn, compress = T)
            return(doc)
        },  # In case of error
        error = function(cond){
            message(cond)
            err <- paste("error:", url)
            return(err)
        },  # Warning
        warning = function(cond){
            message(cond)
            warn <- paste("warning:", url)
            return(warn)
        }
    )
    return(out)
}

# Load main erowid index --------------------------------------------------

# Check number of reports from Erowid
# https://www.erowid.org/experiences/exp.cgi?S1=0&S2=-1&C1=-1&Str=
# 2016-11 24788
N <- 24788
indexurl <- paste0("https://www.erowid.org/experiences/exp.cgi?ShowViews=0&Cellar=0&Start=0&Max=", N)

indexdoc <- read_html(indexurl)
erowid_index <- indexdoc %>%
    html_node(".exp-list-table") %>%
    html_table(header=NA) %>% .[-1, -1]
ratings <- indexdoc %>%
    html_node(".exp-list-table") %>%
    html_nodes("td") %>%
    html_node("img") %>%
    html_attr("alt")
erowid_index$rating <- ratings[seq(1, length(ratings), by = 5)]
links <- indexdoc %>%
    html_nodes(".exp-list-table") %>%
    html_nodes("a") %>%
    html_attr("href")
erowid_index$url <- paste0("https://www.erowid.org/experiences/", links)
names(erowid_index) <- c("title", "author", "substance", "published", "rating", "url")
erowid_index$id <- str_split(erowid_index$url, "ID=", simplify=T)[,2]
erowid_index$id <- as.integer(erowid_index$id)
erowid_index <- arrange(erowid_index, id) %>%
    as_tibble()
save(erowid_index, file = "erowid_index.rda", compress = T)

# Scrape to list ----------------------------------------------------------

urls <- erowid_index$url
sitelist <- vector("list", N)
sitelist <- pbapply::pblapply(urls, read_urls)
save(sitelist, file = "sitelist.rda", compress = "gzip")

