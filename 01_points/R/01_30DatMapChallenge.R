## --------------------------------------------------------------------------------------##
##
## Script name: 01_30DatMapChallenge.R
##
## Purpose of the script: Points
##
## Author: Chinmay Deval
##
## Created On: 2020-11-01
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
library(tidyverse)

states <- sf::st_read("./01_points/data/vectors/India-States.shp")

subset <- readRDS("./01_points/data/cpcb_lakes_all_years_subset_variables.RDS")

subset1 <- sf::st_as_sf(subset)

subset2 <- subset1 %>% 
  dplyr::mutate(Total_Coliforms = case_when(total_coliform_max <= 50 ~ "<= 50 (MPN/100ml)",
                                            total_coliform_max <= 500 ~ "<= 500 (MPN/100ml)",
                                            total_coliform_max <= 5000 ~ "<= 5000 (MPN/100ml)",
                                            total_coliform_max > 5000 ~ ">5000 (MPN/100ml)"
  ))

subset3<-subset2[!is.na(subset2$Total_Coliforms), ]




a<-tm_shape(states) + tm_polygons()+
  tm_shape(subset3) + tm_bubbles(col = "Total_Coliforms",
                                 scale = 0.8,
                                 palette="-RdYlBu", contrast = 0.6)+
  tmap_style("col_blind") + 
  tm_facets(along = "year", free.coords = FALSE)+
  tm_credits("Data source:\nCentral Pollution Control \nBoard 
             \nAdministrative boundries:\n Github;\nHindustanTimesLabs",
             position=c("RIGHT", "BOTTOM"))+
  tm_layout(bg.color = "#F5F5F2",
            title = "Max. Total Coliforms \ndetected in lakes, ponds & tanks.",
            title.position =  c("LEFT", "BOTTOM"), 
            legend.position = c("RIGHT", "top"),
            legend.bg.color = "#F5F5F2",
            legend.title.color = "black",
            legend.stack = "horizontal",
            legend.text.color = "black",
            legend.just = "bottom",
            inner.margins = c(0, .02, .02, .02)) 

tmap_animation(a, filename = "./01_points/R/total_coliform_max1.gif", delay = 100)

