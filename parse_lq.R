library(rvest)
library(stringr)
library(tibble)
library(dplyr)

files = dir("data/lq", "html", full.names = TRUE)

res = list()

for(i in seq_along(files)){
  
  page = read_html(files[i])
  
  hotel_info = page %>% 
    html_nodes(".hotelDetailsBasicInfoTitle p") %>%
    html_text() %>%
    str_split("\n") %>%
    .[[1]] %>%
    str_trim() %>%
    .[.!=""]
  
  loc_name = page %>%
    html_nodes("h1") %>%
    html_text()
  
  long_lat = page %>%
    html_nodes(".minimap") %>%
    html_attr("src") %>%
    str_match("\\|(-*[0-9]{1,3}\\.[0-9]*),(-*[0-9]{1,3}\\.[0-9]*)&")
  
  floor = page %>%
    html_nodes(".hotelFeatureList li:nth-child(1)") %>%
    html_text() %>%
    str_trim() %>%
    str_replace("Floors: ","") %>%
    as.integer()
  
  n_rooms = page %>%
    html_nodes(".hotelFeatureList li:nth-child(2)") %>%
    html_text() %>%
    str_trim() %>%
    str_replace("Rooms: ","") %>%
    as.integer()
  
  amenities = page %>%
    html_nodes(".section:nth-child(1) .pptab_contentL li") %>%
    html_text() %>%
    str_trim()
    
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

hotels = bind_rows(res)

dir.create("data/",showWarnings = FALSE)
save(hotels, file="data/lq.Rdata")
  
