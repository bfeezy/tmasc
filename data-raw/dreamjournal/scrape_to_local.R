# Scrape from dreamjournal to local files

# Every report listed on the index pages
# http://www.dreamjournal.net/main/results?page=1
# max page is 1053
# Is scraped in RAW format to an R list
# Saves index page as djournal_index.rda (an R tibble [data_frame])
# Saves RAW reports as sitelist.rda (an R list)

library(tidyverse)
library(magrittr)
library(tidytext)
library(httr)
library(XML)
library(stringr)
library(lubridate)
library(rvest)
library(pbapply)

# Load main index ---------------------------------------------------------

# Check number of reports from Dreamjournal
# http://www.dreamjournal.net/main/results?page=1
# 2016-11 131542 reports on 1053 index pages
# Read each individual index page's table as data frame
# Combine all data frames for master index with 131k links
N <- 1053
indexurls <- paste0("http://www.dreamjournal.net/main/results?page=", 1:N)
index_list <- vector("list", N)
for (i in 1:N) {
    cat(paste(i, ""))
    indexurl <- indexurls[i]
    indexdoc <- read_html(indexurl)
    djournal_index <- indexdoc %>%
        html_node(".table") %>%
        html_table()
    links <- indexdoc %>%
        html_nodes(".table") %>%
        html_nodes("a") %>%
        html_attr("href")
    links_url <- links[seq(1, length(links), by = 2)]
    djournal_index$url <- paste0("http://www.dreamjournal.net", links_url)
    djournal_index <- as_tibble(djournal_index)
    fn <- paste0("tmp/", i, ".rda")
    save(djournal_index, file = fn, compress=T)
    index_list[[i]] <- djournal_index
}

llist <- vector("list", length(flist))
for (i in 1:length(flist)) {
    load(flist[i])
    llist[[i]] <- djournal_index
}
djournal_index <- bind_rows(llist)
save(djournal_index, file = "djournal_index.rda", compress = T)

# Scrape sites to list ----------------------------------------------------

load("djournal_index.rda")
dreamjournal <- data_frame(
    url = NA_character_,
    rating = NA_character_,
    cohesion = NA_character_,
    lucidity = NA_character_,
    views = NA_character_,
    themes = NA,
    settings = NA,
    characters = NA,
    emotions = NA,
    activities = NA,
    keywords = NA,
    text = NA_character_)
N <- nrow(djournal_index)
load("dreamjournal.rda")
for (i in (nrow(dreamjournal)-1):N) {
    url <- djournal_index$url[i]
    doc <- read_html(url)
    # Select only main page
    doc <- doc %>% html_node(".article-content")
    views <- doc %>%
        html_node(".views") %>%
        html_text()
    text <- doc %>%
        html_node(".post-desc") %>%
        html_text()
    themes <- tryCatch(
        {doc %>%
        html_nodes(".col-md-2") %>%
        extract2(1) %>%
        html_text() %>%
        str_replace_all("Themes", "") %>%
        str_replace_all("\t", "") %>%
        str_replace_all("\n", ", ") %>%
        str_replace_all(", , ", ", ")},
        error = function(cond) {return(NA)}
    )
    settings <- tryCatch(
        {doc %>%
        html_nodes(".col-md-2") %>%
        extract2(2) %>%
        html_text() %>%
        str_replace_all("Settings", "") %>%
        str_replace_all("\t", "") %>%
        str_replace_all("\n", ", ") %>%
        str_replace_all(", , ", ", ")},
        error = function(cond) {return(NA)}
    )
    characters <- tryCatch(
        {doc %>%
        html_nodes(".col-md-2") %>%
        extract2(3) %>%
        html_text() %>%
        str_replace_all("Characters", "") %>%
        str_replace_all("\t", "") %>%
        str_replace_all("\n", ", ") %>%
        str_replace_all(", , ", ", ")},
        error = function(cond) {return(NA)}
    )
    emotions <- tryCatch(
        {doc %>%
        html_nodes(".col-md-2") %>%
        extract2(4) %>%
        html_text() %>%
        str_replace_all("Emotions", "") %>%
        str_replace_all("\t", "") %>%
        str_replace_all("\n", ", ") %>%
        str_replace_all(", , ", ", ")},
        error = function(cond) {return(NA)}
    )
    activities <- tryCatch(
        {doc %>%
        html_nodes(".col-md-2") %>%
        extract2(5) %>%
        html_text() %>%
        str_replace_all("Activities", "") %>%
        str_replace_all("\t", "") %>%
        str_replace_all("\n", ", ") %>%
        str_replace_all(", , ", ", ")},
        error = function(cond) {return(NA)}
    )
    keywords <- tryCatch(
        {doc %>%
        html_nodes(".col-md-12") %>%
        html_nodes(".clearfix") %>%
        extract2(2) %>%
        html_text() %>%
        str_replace_all("\t", "") %>%
        str_replace_all("\n\n", ", ") %>%
        str_split(", ") %>%
        .[[1]] %>%
        str_trim() %>%
                str_c(collapse = ", ")},
        error = function(cond) {return(NA)}
    )
    # Deal with three possible ratings
    ratings <- tryCatch(
        {doc %>%
        html_nodes(".rating") %>%
        html_nodes(".fill") %>%
        html_attr("style")},
        error = function(cond) {return(NA)}
    )
    cur <- tibble(
        url = url,
        rating = ratings[1],
        cohesion = ratings[2],
        lucidity = ratings[3],
        views = views,
        themes = themes,
        settings = settings,
        characters = characters,
        emotions = emotions,
        activities = activities,
        keywords = keywords,
        text = text)
    dreamjournal <- bind_rows(dreamjournal, cur)
    if (i %% 100 == 0) {
        cat(paste0(i, " "))
        save(dreamjournal, file = "dreamjournal.rda", compress = T)
    }
}
View(dreamjournal)
save(dreamjournal, file = "dreamjournal.rda", compress = "bzip2")
