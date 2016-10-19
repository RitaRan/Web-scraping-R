library(xml2)
library(rvest)

##Gain the mian websie url and saved as site
site = "http://www2.stat.duke.edu/~cr173/lq_test/www.lq.com/en/findandbook/"
url = paste0(site,"hotel-listings.html")  ## paste the hotel list website to the url

page = read_html(url) ## read the data from website  

## gained a list includes all hotel html information
hotel_pages = page %>% 
  html_nodes("#hotelListing .col-sm-12 a")%>%
  html_attr("href") %>%
  na.omit() 

## created a file to save the hotel html data
dir.create("data/lq",recursive = TRUE,showWarnings = FALSE)

for(hotel_page in hotel_pages) ## loop for specefic hotel page in the list
{
  hotel_url = paste0(site, hotel_page)  ## gain the hotel url of each hotel
  ##download hotel files and saved in to data/lq fold
  download.file(url = hotel_url, 
                destfile = file.path("data/lq", hotel_page),
                quiet = TRUE) 
}

