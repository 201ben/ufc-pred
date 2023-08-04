library(rvest)
library(dplyr)
library(data.table)

event_link_list <- c()

for (i in 1:7){
  
  html <- read_html(paste0('https://www.sherdog.com/organizations/Ultimate-Fighting-Championship-UFC-2/recent-events/', i)) %>%
    html_nodes("a") %>% 
    html_attr("href")
  
  ufc_event_links <- html[grepl("/events/UFC", html)] %>% unique()
  event_link_list <- c(event_link_list, paste0('https://www.sherdog.com', ufc_event_links))
  
  Sys.sleep(1)
}

event_link_list <- event_link_list %>% unique

event_link_list <- event_link_list[!grepl('Road-to-UFC', event_link_list)]

fighter_links_list <- c()

for (i in event_link_list){
  
  html <- read_html(i) %>%
    html_nodes("a") %>% 
    html_attr("href")
  
  ufc_fighter_links <- html[grepl("/fighter/", html)] %>% unique
  fighter_links_list <- c(fighter_links_list, ufc_fighter_links) %>% unique
  
  Sys.sleep(.75)
}

fighter_links_list <- fighter_links_list %>% unique

uniq_links <- gsub('https://www.sherdog.com/', '', fighter_links_list) %>% unique

uniq_links <- gsub("^fighter", "/fighter", uniq_links) %>% unique

uniq_links <- paste0('https://www.sherdog.com', uniq_links)

uniq_links[!grepl('gallery', uniq_links)] %>% 
  write.csv(file.path('C:/Users/ben/Desktop', 'links.csv'))