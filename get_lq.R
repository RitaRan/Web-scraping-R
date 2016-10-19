library(xml2)
library(rvest)

#Set site to be the la Quinta website Colin made for us
site = "http://www2.stat.duke.edu/~cr173/lq_test/www.lq.com/en/findandbook/"

#Concatenate the hotel list website to the La Quinta website
url = paste0(site,"hotel-listings.html")

#Read the data from website
page = read_html(url)  

#Get a list of all hotel html information 
hotel_pages = page %>% #Set hotel_pages to be all the data read in from the website
  html_nodes("#hotelListing .col-sm-12 a")%>% #Selected the nodes containing the hotel listing info
  html_attr("href") %>% #Selected the html attributes from the nodes
  na.omit() 

#Created a folder to save the hotel html data
dir.create("data/lq",recursive = TRUE,showWarnings = FALSE)

#loop for specific hotel page in the list
for(hotel_page in hotel_pages) 
{
  hotel_url = paste0(site, hotel_page)  ##Gain the hotel url of each hotel
  ##download hotel files and save in "data/lq" file

  download.file(url = hotel_url, 
                destfile = file.path("data/lq", hotel_page),
                quiet = TRUE) 
}

