## --------------------------------------------------------------------------------------##
##
## Script name: 05_30DatMapChallenge.R
##
## Purpose of the script: Blue
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

# remotes::install_github("r-spatial/rgee")
library(rgee)


## ----------------------------------Init ee----------------------------------------------------##
# ee_install()
ee_Initialize()
# ee_user_info()

## -----------------------------------Example1---------------------------------------------------##
gsw = ee$Image('JRC/GSW1_1/GlobalSurfaceWater')
occurrence = gsw$select('occurrence')
change = gsw$select("change_abs")
roi = ee$Geometry$Polygon(
  list(
    c(-74.17213, -8.65569),
    c(-74.17419, -8.39222),
    c(-74.38362, -8.36980),
    c(-74.43031, -8.61293)
  )
)

geometry <- ee$Geometry$Rectangle(
  coords = c(87.5,20.4,91.15,25.1),
  proj = "EPSG:4326",
  geodesic = FALSE
)
###############################
# Constants
###############################

VIS_OCCURRENCE = list(
  min = 0,
  max = 100,
  palette = c('white', 'blue')
)

VIS_CHANGE = list(
  min = -50,
  max = 50,
  palette = c('red', 'black', 'limegreen')
)

VIS_WATER_MASK = list(
  palette = c('white', 'blue')
)


## --------------------------------------------------------------------------------------##
# Create a water mask layer, and set the image mask so that non-water areas are transparent.
water_mask = occurrence$gt(90)$mask(1)


# Initialize Map Location
Map$setCenter(89.15, 22.52, 7.2) # Ganges delta


# add Layers


Map$addLayer(occurrence$updateMask(occurrence$divide(200)),
               VIS_OCCURRENCE, "Water Occurrence (1984-2015)") 



