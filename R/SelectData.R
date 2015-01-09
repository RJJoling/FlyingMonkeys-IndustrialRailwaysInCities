# Team Name:               Team Members:               Date:
# Flying Monkeys           Robbert-Jan Joling          09-01-2015
#                          Damiano Luzzi

library(downloader)

SelectData <- function(dir, keyword){

  download("http://www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip", "data/places.zip" , quiet = T, mode = "wb")
  unzip("data/places.zip", exdir = "data/places")


  data <- list.files(dir, pattern = glob2rx(paste('*', keyword, '*.shp', sep = "")), full.names = TRUE)
}