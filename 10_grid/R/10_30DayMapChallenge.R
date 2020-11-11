## --------------------------------------------------------------------------------------##
##
## Script name: 10_30DayMapChallenge.R
##
## Purpose of the script: grid
##
## Author: Chinmay Deval; 
##
## Created On: 2020-11-09
##
## Copyright (c) Chinmay Deval, 2020
## Email: chinmay.deval91@gmail.com
##
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
library(tidyverse)

evap <- brick("./10_grid/data/Evap_m_day-1_FLUXNET_MTE_igb_2001_2007.nc")
shp <- sf::st_read("./10_grid/data/IGBMTNG.shp")
fun <- function() {
  plot(shp, add=T)
}

# animate(evap, addfun=fun, n = 1, stop= 0.5, col = hcl.colors(8, "Geyser"),
# )

animation::saveGIF(animate(evap, addfun=fun, n = 1, stop= 0.5, col = hcl.colors(8, "Geyser"),
),movie.name = "D:/GitHub/MyContributions_to_30DayMapChallenge/10_grid/R/10_30DayMapChallenge.gif",
convert = "convert", ani.width = 800,
ani.height = 500)
