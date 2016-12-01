
library(tidyverse)
library(stringr)
library(lubridate)

load("dreamjournal.rda")
load("djournal_index.rda")
dreamjournal <- left_join(djournal_index, dreamjournal)

# Clean numeric variables -------------------------------------------------

dreamjournal <- mutate(
    dreamjournal,
    rating = str_split(rating, ":", simplify = T)[,2],
    rating = as.integer(str_replace_all(rating, "%", "")),
    cohesion = str_split(cohesion, ":", simplify = T)[,2],
    cohesion = as.integer(str_replace_all(cohesion, "%", "")),
    # Error if all lucidities are NA
    lucidity = str_split(lucidity, ":", simplify = T)[,2],
    lucidity = as.integer(str_replace_all(lucidity, "%", "")),
    views = as.integer(str_split(views, ":", simplify = T)[,2])
)

# Tags --------------------------------------------------------------------

# Create list columns for all tags
dreamjournal <- mutate(
    dreamjournal,
    themes = str_replace_all(themes, "Add'l", ""),
    themes = str_extract_all(tolower(themes), boundary("word")),
    settings = str_replace_all(settings, "Add'l", ""),
    settings = str_extract_all(tolower(settings), boundary("word")),
    characters = str_replace_all(characters, "Add'l", ""),
    characters = str_extract_all(tolower(characters), boundary("word")),
    emotions = str_replace_all(emotions, "Add'l", ""),
    emotions = str_extract_all(tolower(emotions), boundary("word")),
    activities = str_replace_all(activities, "Add'l", ""),
    activities = str_extract_all(tolower(activities), boundary("word")),
    keywords = str_replace_all(keywords, "Add'l", ""),
    keywords = str_extract_all(tolower(keywords), boundary("word"))
)

# Dates
dreamjournal$Date <- as_date(mdy(dreamjournal$Date))
names(dreamjournal) <- tolower(names(dreamjournal))

# URL
dreamjournal$id <- gsub(".*http://www.dreamjournal.net/journal/dream/dream_id/|/username.*", "", dreamjournal$url)

# Organize
dreamjournal <- select(
    dreamjournal,
    id, dream, user,
    date, rating, cohesion,
    lucidity, views, themes,
    settings, characters, emotions,
    activities, keywords, text

)
dreamjournal <- arrange(dreamjournal, id)

devtools::use_data(dreamjournal, overwrite = T, compress = "bzip2")
