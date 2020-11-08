## --------------------------------------------------------------------------------------##
##
## Script name: 07_30DatMapChallenge.R
##
## Purpose of the script: Green
##
## Author: Chinmay Deval
##
## Created On: 2020-11-07
##
## Copyright (c) Chinmay Deval, 2020
## Email: chinmay.deval91@gmail.com
##
## --------------------------------------------------------------------------------------##
##  Notes:
##   
##
## --------------------------------------------------------------------------------------##

## --------------------------clear environment and console-------------------------------##
rm(list = ls())
cat("\014")

## ----------------------------------Load packages---------------------------------------##
library(raster)
library(rgdal)
library(animation)

setwd("./07_green/data/rasters/")

##### read all rasters in a dir and stack them
img <- list.files(pattern="*.tif$")
stack <- stack(img)

##### Split raster name to get the date info
split <- sapply(img, function(x) strsplit(x, "_")[[1]], USE.NAMES=FALSE)
date <- split[1,]

setwd("D:/GitHub/MyContributions_to_30DayMapChallenge/")

shp1<- readOGR("./07_green/data/mika_shapefiles/1_wsheds30mwgs84_UTM11N.shp")
shp2<- readOGR("./07_green/data/mika_shapefiles/2_wsheds30mwgs84_UTM11N.shp")
shp3<- readOGR("./07_green/data/mika_shapefiles/3_wsheds30mwgs84_UTM11N.shp")
shp4<- readOGR("./07_green/data/mika_shapefiles/4_wsheds30mwgs84_UTM11N.shp")
shp5<- readOGR("./07_green/data/mika_shapefiles/5_wsheds30mwgs84_UTM11N.shp")
shp6<- readOGR("./07_green/data/mika_shapefiles/6_wsheds30mwgs84_UTM11N.shp")
shp7<- readOGR("./07_green/data/mika_shapefiles/7_wsheds30mwgs84_UTM11N.shp")

## --------------------------------------------------------------------------------------##
#Set delay between frames when replaying
ani.options(interval=1.0)

#colors
colfunc <- colorRampPalette(c("brown", "yellow","green", "darkgreen"))
colfunc(10)

fun <- function() {
  plot(shp1, add=T)
  plot(shp2, add=T)
  plot(shp3, add=T)
  plot(shp4, add=T)
  plot(shp5, add=T)
  plot(shp6, add=T)
  plot(shp7, add=T)
}

## --------------------------------------------------------------------------------------##

saveGIF(animate(stack,
                addfun=fun,
                zlim=c(0.1, 0.9),
                main = date,
                pause=0.5, n=3, col = colfunc(15)),
        movie.name = "D:/GitHub/MyContributions_to_30DayMapChallenge/07_green/R/07_30DatMapChallenge.gif",
        clean = TRUE)

saveVideo(animate(stack,
                  addfun=fun,
                  zlim=c(0.1, 0.9),
                  main = date,
                  n=3, col = colfunc(15)),
          video.name =  "D:/GitHub/MyContributions_to_30DayMapChallenge/07_green/R/07_30DatMapChallenge.mp4",
          other.opts = "-pix_fmt yuv420p -b:v 500K",
          ani.width = 300, ani.height = 300)
