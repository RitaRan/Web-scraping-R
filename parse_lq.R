library(xml2)
library(rvest)
library(stringr)
library(tibble)
library(dplyr)

files = dir("data/lq", "html", full.names = TRUE)

#Generated an empty list called res to save the result
res = list()

#Loop over each hotel in the directory containing all hotel url's
for(i in seq_along(files)){ 
  
  page = read_html(files[i]) #Read in the html link for each LQ hotel
  
  hotel_info = page %>% 
    html_nodes(".hotelDetailsBasicInfoTitle p") %>% #Selected the nodes to gain a vector containing the basic hotel information
    html_text() %>% #gained the text information
    str_split("\n") %>% #split the string, to gain each object seperately
    .[[1]] %>%        #gained the first object
    str_trim() %>%  #deleted the empty object
    .[.!=""]     #deleted the empty space
  
  #Gained the hotel names 
  loc_name = page %>% 
    html_nodes("h1") %>%
    html_text()
  
  #Gained the location from the url of hotel map picutre
  long_lat = page %>% 
    html_nodes(".minimap") %>%
    html_attr("src") %>%
    #Selected the longitude and latitude of the hotel
    str_match("\\|(-*[0-9]{1,3}\\.[0-9]*),(-*[0-9]{1,3}\\.[0-9]*)&") 
  
  #Gained the floor information of the hotel
  floor = page %>%
    html_nodes(".hotelFeatureList li:nth-child(1)") %>%
    html_text() %>%
    str_trim() %>%
    str_replace("Floors: ","") %>%
    as.integer()
  
  #Gained the room number information
  n_rooms = page %>%  
    html_nodes(".hotelFeatureList li:nth-child(2)") %>%
    html_text() %>%
    str_trim() %>%
    str_replace("Rooms: ","") %>% #Keep the number
    as.integer() #Set room number as integer
  
  #Gained the amenities for each hotel
  amenities = page %>% 
    html_nodes(".section:nth-child(1) .pptab_contentL li") %>%
    html_text() %>%
    str_trim()
    
  #Gained the state information of the hotel
  state = str_match(hotel_info[2],"\\, (.*?) ")[2]   
  #Hard code a vector including all state names
  States = c("AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS",
             "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY",
             "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV",
             "WI", "WY", "GU", "PR", "VI")
  #Condition on the hotels located in the US, save the hotel data in to res list
  if(state %in% States){
    res[[i]] = data_frame(
      loc_name = loc_name,
      address = paste(hotel_info[1], hotel_info[2], collapse = "\n"),
      phone = hotel_info[3] %>% str_replace("Phone: ",""),
      fax = hotel_info[4] %>% str_replace("Fax: ",""),
      lat = long_lat[1,2] %>% as.numeric(),
      long = long_lat[1,3] %>% as.numeric(),
      n_rooms = n_rooms,
      int_avail = str_detect(amenities,"Internet") %>% sum(.)>0,
      swim_pool_avail = str_detect(amenities,"Swimming Pool") %>% sum(.)>0
    )
  }
}

#Created a data frame including the US LQ hotels
hotels = bind_rows(res)
#Save the hotel data into data folder
dir.create("data/",showWarnings = FALSE)
save(hotels, file="data/lq.Rdata")
  
