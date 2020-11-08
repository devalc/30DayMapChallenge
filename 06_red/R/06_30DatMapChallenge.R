## --------------------------------------------------------------------------------------##
##
## Script name: 06_30DatMapChallenge.R
##
## Purpose of the script: Red
##
## Author: Chinmay Deval
##
## Created On: 2020-11-06
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
#load packages
library(osmplotr)

## --------------------------------------------------------------------------------------##
#Pune
pune_bbox<- get_bbox(c(73.69389, 18.36388, 74.01505, 18.68203)) 
pune_H <- extract_osm_objects (key = 'highway', bbox = pune_bbox)
pune_HP <- extract_osm_objects (key = 'highway', value = 'primary', bbox = pune_bbox)

#Utrecht
utrecht_bbox<- get_bbox(c(5.003902, 52.025269,  5.196554, 52.136901 ))
utrecht_H <- extract_osm_objects (key = 'highway', bbox = utrecht_bbox)
utrecht_HP <- extract_osm_objects (key = 'highway', value = 'primary', bbox = utrecht_bbox)

## --------------------------------------------------------------------------------------##
#Pune map
map <- osm_basemap (bbox = pune_bbox, bg = 'gray20')
map <- add_osm_objects (map, pune_H, col = '#800000',
                        size = 0.1)
map <- add_osm_objects (map, pune_HP, col = '#ff4d4d', size =0.2)
print_osm_map (map, filename = "./06_red/R/RoadNetworkPune.png", device = "png",
               width = 10, units = "cm")
# print_osm_map (map)

## --------------------------------------------------------------------------------------##
#Utrecht map
mapU <- osm_basemap (bbox = utrecht_bbox, bg = 'gray20')
mapU <- add_osm_objects (mapU, utrecht_H, col = '#800000',
                        size = 0.1)
mapU <- add_osm_objects (mapU, utrecht_HP, col = '#ff4d4d', size =0.2)

print_osm_map (mapU, filename = "./06_red/R/RoadNetworkUtrecht.png", device = "png",
               width = 10, units = "cm")
# print_osm_map (mapU)


