# Tidy report texts

library(tidyverse)
library(tidytext)
library(httr)
library(XML)
library(stringr)
library(lubridate)
library(rvest)

# Processing the raw sites creates url artifacts, remove
erowid <- mutate(
    erowid,
    text = str_replace_all(text,
                           pattern = "&#xD;<br/><br/>",
                           replacement = "\n"),
    text = str_replace_all(text,
                            pattern = "&#xD;<br/>",
                            replacement = "\n"),
    text = str_replace_all(text,
                            pattern = "<br/>",
                            replacement = "\n")
)

# Deal with "[Erowid Note:]" at beginning of erowid
erowid$erowid_warning <- FALSE
pat <- "(.*<span class=\"erowid-warning\">)(.*)(</span>.*)"
erowid$erowid_warning <- grepl(
    pattern = pat,
    x = erowid$text)

# Footdata fields [age, year, gender, views]
erowid <- mutate(
    erowid,
    year = as.integer(str_replace_all(year, ".*: ", "")),
    year = ifelse(between(year, 1960, 2016), year, NA),
    gender = str_replace_all(gender, ".*: ", ""),
    gender = str_sub(ifelse(gender == "Not Specified", NA, gender), 1, 1),
    age = str_replace_all(age, ".*: ", ""),
    age = as.integer(ifelse(age == "Not Given", NA, age)),
    age = ifelse(between(age, 10, 100), age, NA),
    views = as.integer(gsub(",", "", str_replace_all(views, ".*: ", ""))))
str(erowid, max.level = 1)
table(erowid$year)
table(erowid$gender)
table(erowid$age)

# Bodyweight is a string in lb or kg, convert to kg
erowid <- mutate(
    erowid,
    bwnum = as.numeric(str_match(erowid$bodyweight, "[0-9]+")),
    scale = str_trim(str_match(erowid$bodyweight, "[^0-9]+")[,1]))
erowid$kg <- ifelse(erowid$scale == "lb",
                            round(erowid$bwnum / 2.2046),
                            erowid$bwnum)

# Remove unnecessary columns
erowid <- select(
    erowid,
    id, title, author, gender, age, kg,
    year, published, rating, views,
    substance, text, erowid_warning, dosechart)

# Rating "New" is unnecessary
erowid$rating <- ifelse(erowid$rating == "New", NA, erowid$rating)

# Save clean data for package
devtools::use_data(erowid, overwrite = T, compress = "bzip2")
