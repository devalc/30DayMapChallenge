## --------------------------------------------------------------------------------------##
##
## Script name: 08_30DatMapChallenge.R
##
## Purpose of the script: Yellow
##
## Author: Chinmay Deval; Adapted from Donyoe(Kaggle)
##
## Created On: 2020-11-08
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

## --------------------------------------------------------------------------------------##

library(tidyverse)
library(choroplethr)
library(choroplethrMaps)
library(animation)
library(data.table)
library(lubridate)
library(viridis)

## --------------------------------------------------------------------------------------##

data <-data.table::fread('./08_yellow/data/us-droughts.csv',
             select = c("releaseDate","NONE","FIPS"))

data <- data %>% dplyr::mutate(releaseDate = lubridate::ymd(releaseDate),
                               year= lubridate::year(releaseDate),
                               month = lubridate::month(releaseDate))

data <- data[,.("region"=FIPS,"value"=100-NONE,year,month)]

data <- data[,.("value"=mean(value,na.rm = T)),by=.(region,year, month)]

data$value <- cut(data$value, breaks=5, 
                  labels=c('0-20', '20-40', '40-60', '60-80', '80-100'))

years <- unique(data$year)
months <- sort(unique(data$month))


## --------------------------------------------------------------------------------------##

ani.options(interval = 1.2, nmax = 1644)

saveGIF(for(yr in years){
  for(mo in months){
    droughtplot <- data[c(year==yr&month==mo)]
    map <- CountyChoropleth$new(droughtplot)
    map$title = paste("US Drought Conditions by County, year:",yr,", month:",mo)
    map$ggplot_scale <- scale_fill_brewer(name = '% in drought', palette = 'YlOrBr', drop=FALSE)
    print(map$render())
  }}, movie.name = "D:/GitHub/MyContributions_to_30DayMapChallenge/08_yellow/R/drought_map.gif", convert = "convert", ani.width = 1000, 
  ani.height = 500)
