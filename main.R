# Team Name:               Team Members:               Date:
# Flying Monkeys           Robbert-Jan Joling          09-01-2015
#                          Damiano Luzzi

# load packages
library(sp)
library(rgdal)
library(rgeos)
library(raster)

railways <- list.files("data/netherlands-railways-shape/", pattern = glob2rx('*.shp'), full.names = TRUE)
places <- list.files("data/netherlands-places-shape/", pattern = glob2rx('*.shp'), full.names = TRUE)


myroute <- readOGR(railways, layer = ogrListLayers(railways))
industrial <- myroute[myroute$type == "industrial",]
myplaces <- readOGR(places, layer = ogrListLayers(places))

prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")
industrialRD <- spTransform(industrial, prj_string_RD)
placesRD <- spTransform(myplaces, prj_string_RD)
industrialbuffer <- gBuffer(industrialRD, byid = TRUE, width = 1000.0)

test <- gIntersection(industrialbuffer, placesRD)
i <- gIntersects(industrialbuffer, placesRD, byid = TRUE)
plaats <- placesRD@data[i]
plaats[2]

place.label <- placesRD@data[i]
plot(test)
invisible(text(getSpPPolygonsLabptSlots(test), labels = place.label[2], cex = 1.2, col = "white", font = 9))

