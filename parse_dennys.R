library(methods)
library(rvest)
library(stringr)
library(tibble)
library(dplyr)

files = dir("data/dennys", "xml", full.names = TRUE)

info = function(file){
  page = read_html(file)
  data_frame(
    add1 = page %>% html_nodes("address1") %>% html_text(),
    city = page %>% html_nodes("city") %>% html_text(),
    state = page %>% html_nodes("state") %>% html_text(),
    zip = page %>% html_nodes("postalcode") %>% html_text(),
    country = page %>% html_nodes("country") %>% html_text(),
    phone = page %>% html_nodes("phone") %>% html_text(),
    long = page %>% html_nodes("longitude") %>% html_text() %>% as.numeric(),
    lat = page %>% html_nodes("latitude") %>% html_text() %>% as.numeric()
  )
}

dennys = list(info(files[1]), info(files[2]))
dennys = bind_rows(dennys)
dennys = dennys %>%
  unique() %>%
  filter(country == "US")

dir.create("data/",showWarnings = FALSE)
save(dennys,file="data/dennys.Rdata")
