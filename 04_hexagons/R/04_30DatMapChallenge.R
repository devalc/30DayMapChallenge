## --------------------------------------------------------------------------------------##
##
## Script name: 04_30DatMapChallenge.R
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

library(RSQLite)
library(tidyverse)
library(geojsonio)
library(rgeos)
library(gridExtra)
library(grid)
library(broom)


## ----------------------------------------Hex Layer----------------------------------------------##
us_hex <- geojson_read("./04_hexagons/data/us_states_hexgrid.geojson",
                       what = "sp")

us_hex@data = us_hex@data %>%
  mutate(google_name = gsub(" \\(United States\\)", "", google_name))

us_hex_fortified <- tidy(us_hex, region = "google_name")

#Calculate the centroid of each hexagon to add the label:
centers <- cbind.data.frame(data.frame(gCentroid(us_hex,
                                                 byid=TRUE),
                                       id=us_hex@data$iso3166_2))

## -----------------------------------------Fires---------------------------------------------##
## connect to db
con <- dbConnect(SQLite(),
                 "./04_hexagons/data/us_wildfires_1992_2015_kaggle/FPA_FOD_20170508.sqlite")

## list all tables
tables <- dbListTables(con)

## exclude sqlite_sequence (contains table information)
tables <- tables[tables != "sqlite_sequence"]

## --------------------------------------------------------------------------------------##

# Get table
Fires <- dbReadTable(con, 'Fires')

# data is fetched so disconnect it.
dbDisconnect(con)

## subset 2014
fires2014 <- Fires %>% dplyr::filter(FIRE_YEAR =="2014") %>%
  dplyr::select(STATE, FIRE_SIZE) %>% 
  dplyr::mutate(FIRE_SIZE_km2 = FIRE_SIZE * 0.00404686) %>%
  dplyr::select(-FIRE_SIZE) %>% 
  dplyr::group_by(STATE) %>% 
  summarise(Total_Fire_Size_km2 = sum(FIRE_SIZE_km2, na.rm = TRUE))

# recode  
fires2014 <- fires2014 %>% dplyr::mutate(STATE=recode(STATE,
                                                    `AK`="Alaska",
                                                    `AL`="Alabama",
                                                    `AR`="Arkansas",
                                                    `AZ`="Arizona",
                                                    `CA`="California",
                                                    `CO`="Colorado",
                                                    `CT`="Connecticut",
                                                    `DC`="District of Columbia",
                                                    `DE`="Delaware",
                                                    `FL`="Florida",
                                                    `GA`="Georgia",
                                                    `HI`="Hawaii",
                                                    `IA`="Iowa",
                                                    `ID`="Idaho",
                                                    `IL`="Illinois",
                                                    `IN`="Indiana",
                                                    `KS`="Kansas",
                                                    `KY`="Kentucky",
                                                    `LA`="Louisiana",
                                                    `MA`="Massachusetts",
                                                    `MD`="Maryland",
                                                    `ME`="Maine",
                                                    `MI`="Michigan",
                                                    `MN`="Minnesota",
                                                    `MO`="Missouri",
                                                    `MS`="Mississippi",
                                                    `MT`="Montana",
                                                    `NC`="North Carolina",
                                                    `ND`="North Dakota",
                                                    `NE`="Nebraska",
                                                    `NH`="New Hampshire",
                                                    `NJ`="New Jersey",
                                                    `NM`="New Mexico",
                                                    `NV`="Nevada",
                                                    `NY`="New York",
                                                    `OH`="Ohio",
                                                    `OK`="Oklahoma",
                                                    `OR`="Oregon",
                                                    `PA`="Pennsylvania",
                                                    `RI`="Rhode Island",
                                                    `SC`="South Carolina",
                                                    `SD`="South Dakota",
                                                    `TN`="Tennessee",
                                                    `TX`="Texas",
                                                    `UT`="Utah",
                                                    `VA`="Virginia",
                                                    `VT`="Vermont",
                                                    `WA`="Washington",
                                                    `WI`="Wisconsin",
                                                    `WV`="West Virginia",
                                                    `WY`="Wyoming"
                                                    ))
# join hex with fires data
spdf_fortified <- us_hex_fortified %>%
  left_join(. , fires2014, by=c("id"="STATE")) 

## --------------------------------------------------------------------------------------##
# chloropleth map
# test hex
# ggplot() +
#   geom_polygon(data = us_hex_fortified, aes(x = long, y = lat, group = group),
#                fill="skyblue", color="white") +
#   geom_text(data=centers, aes(x=x, y=y, label=id)) +
#   theme_void() +
#   coord_map()




plt <- ggplot() +
  geom_polygon(data = spdf_fortified, aes(fill =  Total_Fire_Size_km2, x = long, y = lat, group = group)) +
  geom_text(data=centers, aes(x=x, y=y, label=id), color="black", size=3, alpha=0.6)+
  geom_text(data=centers, aes(x=x, y=y, label=id), color="black", size=3, alpha=0.6)+
  scale_fill_gradient(trans = "sqrt",na.value = "grey50",
                      low = "#FBEEE6", high =  "#900C3F",guide = "colourbar") +
  theme_void() +
  ggtitle( "Statewise estimate of total burnt area (sq.km) during the 2014 fire year." ) +
  theme(legend.title = element_blank(),
        legend.position = "bottom",
        legend.text = element_text(angle = -90, color = "#ffffff"),
        text = element_text(color = "#4e4d47", size = 8),
        plot.background = element_rect(fill = "#000000", color = NA), 
        panel.background = element_rect(fill = "#000000", color = NA), 
        legend.background = element_rect(fill = "#000000", color = NA),
        plot.title = element_text(size= 12, hjust=0.5, color = "#ffffff",
                                  margin = margin(b = 0.1, t = 0.4,
                                                  l = 2, unit = "cm")),
        plot.caption=element_text(hjust = 0.98,vjust = 5 )
)


g <- grid.arrange(plt + 
                    labs(caption="Data source: Kaggle\n(rtatman/188-million-us-wildfires)\n Hex file: https://carto.com/\nMap by: Chinmay Deval"))


ggsave("./04_hexagons/R/04_30DatMapChallenge.png",plot = g,
       height = 14,width = 18,units = "cm", dpi = 400)

