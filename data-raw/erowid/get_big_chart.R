# Add substance classes to erowid data [needs work]

library(tidyverse)
library(rvest)
library(tmasc)
url <- "https://erowid.org/general/big_chart.shtml"
indexdoc <- read_html(url)
chart_list <- indexdoc %>%
    html_nodes(".big-chart-surround") %>%
    html_table()
d <- tibble()
for (i in 1:6){
    class <- chart_list[1:6][[i]][1,1]
    subs <- chart_list[1:6][[i]][-1,1]
    out <- data_frame(substance = subs, class = class)
    d <- bind_rows(d, out)
}
