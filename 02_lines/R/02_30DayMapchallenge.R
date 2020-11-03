## --------------------------------------------------------------------------------------##
##
## Script name: 
##
## Purpose of the script:
##
## Author: Chinmay Deval
##
## Created On: 2020-11-02
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
library(tmap)
library(rosm)
library(tidyverse)

## --------------------------------------------------------------------------------------##

gloric <- read_sf("./02_lines/data/GloRiC_v10_shapefile/GloRiC_v10_shapefile/GloRiC_v10.shp")

pune <- read_sf("./02_lines/data/vectors/wshed.shp")

clipped <- st_intersection(gloric, pune)
clipped$Reach_type <- as.factor(clipped$Reach_type)
clipped$Class_phys <- as.factor(clipped$Class_phys)
clipped$Class_hydr <- as.factor(clipped$Class_hydr)

clipped <- clipped %>% 
  mutate(Physio_climatic_class = dplyr::case_when(Class_phys == 322 ~ "High Temperature, Medium CMI, High Elevation",
                                                  Class_phys == 332 ~ "High Temperature, High CMI, High Elevation",
                                                  Class_phys == 411 ~ "Very high Temperature, Low CMI, Low Elevation",
                                                  Class_phys == 412 ~ "Very high Temperature, Low CMI, High Elevation",
                                                  Class_phys == 421 ~ "Very high Temperature, Medium CMI, Low Elevation",
                                                  Class_phys == 422 ~ "Very high Temperature, Medium CMI, High Elevation",
                                                  Class_phys == 431 ~ "Very high Temperature, High CMI, Low Elevation",
                                                  Class_phys == 432 ~ "Very high Temperature, High CMI, High Elevation",
                                                  ))

clipped <- clipped %>% 
  mutate(Hydrologic_class = dplyr::case_when(Class_hydr == 13 ~ "Low variability, Medium discharge",
                                             Class_hydr == 23 ~ "Medium variability, Medium discharge",
                                             Class_hydr == 12 ~ "Low variability, Low discharge",
                                             Class_hydr == 33 ~ "High variability, Medium discharge"))

plt<- tm_shape(pune) +
  tm_polygons(alpha = 0.1) +
  tm_shape(clipped) +
  tm_lines(col= "Hydrologic_class", scale=1, 
           legend.lwd.show = FALSE, 
           palette = get_brewer_pal("-Dark2", n = 4)) +
  tm_style("cobalt", title = " ") +
  tm_credits("(c) Dallaire et al. (2018)\nData available at: https://www.hydrosheds.org/page/gloric\nMap prepared by: Chinmay Deval",
             position=c("LEFT", "BOTTOM"),size = 0.3)+
  tm_layout( bg.color = "#000813",
             legend.title.color = "#ffffff",
             legend.stack = "horizontal",
             legend.text.color = "#ffffff",
             legend.just = "bottom",
             inner.margins = c(0, .02, .02, .02),
             legend.bg.color = "#000000",
             legend.bg.alpha = 0,
             legend.position =  c("RIGHT", "TOP"),
             legend.text.size = 0.5,
             legend.title.size = 0.8) 

tmap::tmap_save(plt, "./02_lines/R/02_30DayMapChallenge.png",
                width=1920, height=1080, asp=0)
