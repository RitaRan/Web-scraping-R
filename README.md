[![wercker status](https://app.wercker.com/status/ca405b9736f6923d04f8b98972ddb4cc/s/master "wercker status")](https://app.wercker.com/project/byKey/ca405b9736f6923d04f8b98972ddb4cc)
# Web Scraping in R

The task is to test if it is true that La Quinta and Denny's are always near each other.

# 5 parts for this task

La Quinta:
- get_lq.R: web scrape all the hotel html information in us
- parse_lq.R: create a data table to store the hotel information(including longitude and latitude) through each hotel html

Denny's:
- get_dennys.R: web scrape all the denny's html information in us
- parse_dennys.R: create a data table to store denny's information(including longitude and latitude) through each denny's html

Analysis:
- hw4.Rmd: calculate the distances and dispaly the results in a map 

