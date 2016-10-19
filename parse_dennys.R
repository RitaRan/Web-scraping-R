library(xml2)
library(methods)
library(rvest)
library(stringr)
library(tibble)
library(dplyr)

## gained the full address of two dennys
files = dir("data/dennys", "xml", full.names = TRUE)

##created a function which could gained the denny's information
info = function(file){
  page = read_html(file)
  data_frame(
    add1 = page %>% html_nodes("address1") %>% html_text(), ## select "address1" nodes from the xml document usign CSS selectors.
    city = page %>% html_nodes("city") %>% html_text(),
    state = page %>% html_nodes("state") %>% html_text(),
    zip = page %>% html_nodes("postalcode") %>% html_text(),
    country = page %>% html_nodes("country") %>% html_text(),
    phone = page %>% html_nodes("phone") %>% html_text(),
    long = page %>% html_nodes("longitude") %>% html_text() %>% as.numeric(),
    lat = page %>% html_nodes("latitude") %>% html_text() %>% as.numeric()
  )
}

## save the dennys loaction information into list called "dennys"
dennys = list(info(files[1]), info(files[2]))
dennys = bind_rows(dennys) ## bind list "dennys" to a data frame
##selected the dennys in the US
dennys = dennys %>%
  unique() %>%
  filter(country == "US") 

dir.create("data/",showWarnings = FALSE)
save(dennys,file="data/dennys.Rdata")
