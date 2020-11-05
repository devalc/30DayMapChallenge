## --------------------------------------------------------------------------------------##
##
## Script name: 03_30DatMapChallenge.R
##
## Purpose of the script: Polygons
##
## Author: Chinmay Deval
##
## Created On: 2020-11-03
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
library(sf)
library(raster)
library(tidyverse)
library(tmap)
library(cartography)

wat_areas <- sf::st_read("./03_polygons/data/Ind_wat_areas_clipped.shp")

plt<-tm_shape(wat_areas) +
  tm_polygons(scale=1, col = "#3be3ff",
              border.col = "#3be3ff",
              legend.lwd.show = FALSE,
              alpha =0.3,
              border.alpha = 0.5
              )+
  tm_style("beaver")+
  tm_layout(title = "Inland waters (perennial & intermittent) as well as land subject to \ninundation in parts of Ganges Basin.",
            title.position =  c("LEFT", "BOTTOM"), 
            title.color = "#FFFFFF",
            legend.position = c("RIGHT", "top"),
            legend.bg.color = "#F5F5F2",
            legend.title.color = "#FFFFFF",
            legend.stack = "horizontal",
            legend.text.color = "black",
            legend.just = "bottom",
            title.size = 0.5,
            inner.margins = c(0, .02, .02, .02),
            bg.color = "#040404")+
  tm_credits("Data Source:\nDIVA-GIS\nMap prepared by:\nChinmay Deval",
                                                           position=c("RIGHT", "TOP"),
                                                           size =0.3,
             col = "#ffffff")


tmap::tmap_save(plt, "./03_polygons/R/03_30DayMapChallenge.png",
                width=1920, height=1080, asp=0)
# 
