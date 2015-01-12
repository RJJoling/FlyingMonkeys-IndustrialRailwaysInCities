# Team Name:               Team Members:               Date:
# Flying Monkeys           Robbert-Jan Joling          09-01-2015
#                          Damiano Luzzi

# load packages
library(sp)
library(rgdal)
library(rgeos)
library(raster)
library(downloader)
library(plotGoogleMaps)

# Download and unzip data
download("http://www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip",
         "data/places.zip" , quiet = T, mode = "wb")
unzip("data/places.zip", exdir = "data/places")
download("http://www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip",
         "data/railways.zip" , quiet = T, mode = "wb")
unzip("data/railways.zip", exdir = "data/railways")

# Select shapefiles from folder
railways <- list.files("data/railways/", pattern = glob2rx('*.shp'), full.names = TRUE)
places <- list.files("data/places/", pattern = glob2rx('*.shp'), full.names = TRUE)

# Read data, convert to spatial data frame and select industrial railways
railwaysDF <- readOGR(railways, layer = ogrListLayers(railways))
industrial <- railwaysDF[railwaysDF$type == "industrial",]
placesDF <- readOGR(places, layer = ogrListLayers(places))

# Project data to RD system
prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889
                     +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel
                     +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,
                     -1.8703473836068,4.0812 +units=m +no_defs")
industrialRD <- spTransform(industrial, prj_string_RD)
placesRD <- spTransform(placesDF, prj_string_RD)

# Create buffer around industrial railway
industrialbuffer <- gBuffer(industrialRD, byid = TRUE, width = 1000.0)

# Find city intersecting the buffer
cities.within <- gIntersection(industrialbuffer, placesRD)
i <- gIntersects(industrialbuffer, placesRD, byid = TRUE)
city <- placesRD@data[i]

# Find city name and statistics
cityname <- city[2]
population <- city[4]

# Visualize buffer, railway and city
plot(industrialbuffer, axes = TRUE)
plot(industrialRD, add = TRUE)
plot(cities.within, add = TRUE)

mtext(side = 1, "Longitude", line = 2.5, cex=1.1)
mtext(side = 2, "Latitude", line = 2.5, cex=1.1)
mtext(side = 3, line = 1, cityname, , cex = 2)

box()
grid()

# Visualize data in Google Maps
map1 <- plotGoogleMaps(industrialbuffer, col = 'grey', add = TRUE,
                       layerName = 'Buffer around industrial railway', legend = FALSE)
map2 <- plotGoogleMaps(industrialRD, col = 'golden rod', strokeWeight = 3,
                       previousMap = map1, add = TRUE, layerName = 'Industrial railway',
                       legend = FALSE)
map3 <- plotGoogleMaps(cities.within, col = 'blue', previousMap = map2,
                       filename = 'output/GoogleMapsPlot.html', layerName = 'City within buffer')


# Cityname = Utrecht, population = "100,000"

