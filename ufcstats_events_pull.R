library(rvest)
library(dplyr)
library(data.table)
library(stringr)
library(tidyr)

url <- "http://ufcstats.com/statistics/events/completed?page=all"

page <- read_html(url)

link_data <- page %>%
  html_nodes(".b-link.b-link_style_black") %>%
  html_text() %>%
  tibble(event_name = .) %>% 
  mutate(
    event_url = page %>% 
      html_nodes(".b-link.b-link_style_black") %>%
      html_attr("href"),
    event_date = page %>%
      html_nodes(".b-statistics__date") %>%
      html_text() %>% .[-1]
    )

link_data <- link_data %>% 
  mutate(event_name = gsub('[[:space:]]{2,}|\\n+', '', event_name), 
         event_date = gsub('[[:space:]]{2,}|\\n+', '', event_date)
         )


url_list <- split(link_data$event_url, link_data$event_name)
date_list <- split(link_data$event_date, link_data$event_name)


separator <- "[[:space:]]{2,}|\\n+"
dat <- list()
for (i in names(url_list)){
  
  page <- read_html(url_list[[i]]) %>%
    html_nodes("table") %>%
    .[1] %>%
    html_table()
  
  tbl <- page[[1]] %>% data.frame() %>% 
    separate(col = Fighter,into = c('a_fighter', 'b_fighter'), sep = separator, extra = "drop") %>% 
    separate(col = Kd,into = c('a_kd', 'b_kd'), sep = separator, extra = "drop") %>% 
    separate(col = Str,into = c('a_str', 'b_str'), sep = separator, extra = "drop") %>% 
    separate(col = Td,into = c('a_td', 'b_td'), sep = separator, extra = "drop") %>% 
    separate(col = Sub,into = c('a_sub', 'b_sub'), sep = separator, extra = "drop") %>% 
    separate(col = Method,into = c('win_method', 'win_desc'), sep = separator, extra = "drop") %>% 
    mutate(event = i,
           date = date_list[[i]])
  
  dat <- rbindlist(list(dat, tbl)) 
  
  Sys.sleep(.75)
}

dat %>% 
  write.csv(file.path('C:/Users/ben/Desktop', 'ufcstats_event.csv'))
