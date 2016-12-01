# Read locally saved reports (from scrape_to_local.R)

# Processes raw reports and dosecharts from sitelist.rda to a data frame
# Joins with info from erowid_index.rda
# Creates a final erowid_reports data_frame

library(tidyverse)
library(tidytext)
library(httr)
library(XML)
library(stringr)
library(lubridate)
library(rvest)
library(pbapply)

# Functions to process local list of erowid report sites ------------------

# Use these to replace missing info tables
foot_missing <- list(data.frame(X1 = rep(NA, 5),
                                X2 = rep(NA, 5)))
dose_missing <- list(data.frame(X1 = NA,
                                X2 = NA,
                                X3 = NA,
                                X4 = NA,
                                X5 = NA))

process_sites <- function(site){
    out <- tryCatch(
        {
            doc <- read_html(site, encoding=guess_encoding(site)$encoding[1])
            bodyweight <- doc %>% html_node(".bodyweight-amount") %>% html_text()
            # Text body is not in unique tag but surrounded by html comments
            textbody_raw <- doc %>% html_node(".report-text-surround")
            raw_text <- xmlParse(textbody_raw) %>%
                toString.XMLNode() %>%
                gsub(".*<!-- Start Body -->|<!-- End Body -->.*", "", .)
            # Get footer table
            footdata <- doc %>%
                html_nodes(".footdata") %>%
                html_table(fill=T)
            footdata <- ifelse(length(footdata)==0,
                               foot_missing, footdata)  # If missing
            # Get dosechart table as a list-column (mixed rows & cols)
            dosechart <- doc %>%
                html_nodes(".dosechart") %>%
                html_table()
            dosechart <- ifelse(length(dosechart)==0,
                                dose_missing, dosechart)  # If missing
            # Create a report data frame
            report_df <- tibble(
                footdata = footdata,
                dosechart = dosechart,
                bodyweight,
                text = raw_text)
            return(report_df)
        },
        error=function(cond) {
            report_df <- tibble(
                footdata = foot_missing,
                dosechart = dose_missing,
                bodyweight = NA,
                text = NA)
            return(report_df)
        }
    )
    return(out)
}

# Process list of documents to data frame
load("sitelist.rda")
reports_list <- vector("list", length(sitelist))
reports_list <- pblapply(sitelist, process_sites, cl = 8)
types <- lapply(reports_list, class)
unique(types)
reports <- bind_rows(reports_list)

# Deal with list columns --------------------------------------------------

# Parse footdata to columns
reports <- reports %>%
    rowwise() %>%
    mutate(year = footdata[1,1],
           gender = footdata[2,1],
           age = footdata[3,1],
           views = footdata[4, 2],
           id = footdata[1,2])

# Join with erowid index
load("erowid_index.rda")
erowid_index$published <- as_date(mdy(erowid_index$published))
reports$id <- str_replace_all(reports$id, ".*: ", "")
reports$id <- as.integer(reports$id)
erowid <- left_join(erowid_index, reports)
