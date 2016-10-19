##generated a function to gain the url for dennys in different locations
get_url = function(limit, zip_code, radius) ##the parameters are limit, zipcode, and radius
{
  paste0(
    "https://hosted.where2getit.com/dennys/responsive/ajax?&xml_request=%3Crequest%3E%3Cappkey%3E6B962D40-03BA-11E5-BC31-9A51842CA48B%3C%2Fappkey%3E%3Cformdata+id%3D%22locatorsearch%22%3E%3Cdataview%3Estore_default%3C%2Fdataview%3E%3Climit%3E",
    limit,"%3C%2Flimit%3E%3Corder%3Erank%2C_distance%3C%2Forder%3E%3Cgeolocs%3E%3Cgeoloc%3E%3Caddressline%3E",
    zip_code,
    "%3C%2Faddressline%3E%3Clongitude%3E%3C%2Flongitude%3E%3Clatitude%3E%3C%2Flatitude%3E%3Ccountry%3EUS%3C%2Fcountry%3E%3C%2Fgeoloc%3E%3C%2Fgeolocs%3E%3Cstateonly%3E1%3C%2Fstateonly%3E%3Csearchradius%3E",
    radius,
    "%3C%2Fsearchradius%3E%3C%2Fformdata%3E%3C%2Frequest%3E"
  )
}

## gain the url link of different locations 
dist1 = get_url(limit=1000, zip_code=84116, radius=5000)
dist2 = get_url(limit=1000, zip_code=20011, radius=5000)
## created fold to save denny's url
dir.create("data/dennys",recursive = TRUE, showWarnings = FALSE)
##downland the data into data/dennys fold
download.file(dist1, dest="data/dennys/dist1.xml")
download.file(dist2, dest="data/dennys/dist2.xml")

