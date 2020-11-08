## --------------------------------------------------------------------------------------##
##
## Script name: 06_30DatMapChallenge.R
##
## Purpose of the script: Red
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
#load packages
library(tidyverse)
library(osmdata)
library(sf)
library(cowplot)
library(basemapR)


#building the query
utreach_q <- getbb("Utrecht") %>%
  opq() %>%
  add_osm_feature("building")

str(utreach_q) #query structure

Utrecht <- osmdata_sf(utreach_q)
Utrecht

utrecht_centers <- st_centroid(Utrecht$osm_points)

pune_centers <- st_centroid(Pune$osm_points)

# create bbox from our nc layer and expand it to include more area above/below
bbox_pune <- expand_bbox(st_bbox(pune_centers), X = 0, Y = 150000)
bbox_utrecht <- expand_bbox(st_bbox(utrecht_centers), X = 0, Y = 150000)


#building the query
Pune_q <- getbb("Pune") %>%
  opq() %>%
  add_osm_feature("building")

str(Pune_q) #query structure

Pune <- osmdata_sf(Pune_q)
Pune



#final map
Utrecht_plt<- ggplot(Utrecht$osm_points )+
  geom_sf(colour = "#9c0808",
          # fill = "#08306b",
          alpha = .5,
          size = 0.1,
          shape = 21)+
  theme_void()


#final map
Pune_plt<-ggplot(Pune$osm_points )+
  geom_sf(colour = "#9c0808",
          # fill = "#08306b",
          alpha = .2,
          size = 0.1,
          shape = 21)+
  theme_void()

a<- Utrecht$osm_points[sample(nrow(Utrecht$osm_points), 300), ]



ggplot(a)+
  base_map(bbox_utrecht, increase_zoom = 2, basemap = 'google-road') +
  geom_sf(colour = "#9c0808",
          # fill = "#08306b",
          alpha = .5,
          size = 0.1,
          shape = 21) +
  coord_sf(datum = NA,
           xlim = c(73.69389, 74.01505),
           ylim = c(17.01469, 20.03122 )) +
  theme_minimal() +
  labs(caption = 'map data \uA9 2020 Google')

+
  theme_void()
