## --------------------------------------------------------------------------------------##
##
## Script name: 09_30DayMapChallenge.R
##
## Purpose of the script: monochrome
##
## Author: Chinmay Deval; 
##
## Created On: 2020-11-09
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
library(raster)
library(rayshader)

data <- raster::raster("./11_3d/data/srtm_51_09.tif")
e<- extent(c(xmax = 73.4, xmin = 74, ymin = 18.3, ymax = 18.72))
data<-crop(data,e)


dmat = raster_to_matrix(data)


dmat %>%
  sphere_shade(texture = "imhof4",sunangle = 0.1) %>%
  add_water(detect_water(dmat), color = "imhof4") %>%
  add_shadow(ray_shade(dmat, zscale = 50), 1) %>%
  add_shadow(ambient_shade(dmat), 1) %>%
  plot_3d(dmat, zscale = 10, fov = 0, theta = 65,
          zoom = 0.75, phi = 45, windowsize = c(1000, 800))
 render_label(dmat, x = 450, y = 340, z = 18000, zscale = 50,
             text = "Khadakwasla", textsize = 2, linewidth = 5, freetype = FALSE,
             linecolor = "#df7c4d",
             textcolor = "#df7c4d",
             dashed = TRUE)
 render_label(dmat, x = 250, y = 390, z = 15000, zscale = 50,
              text = "Panshet", textsize = 2, linewidth = 5, freetype = FALSE,
              linecolor = "#df7c4d",
              textcolor = "#df7c4d",
              dashed = TRUE)
 render_label(dmat, x = 100, y = 220, z = 10000, zscale = 50,
              text = "Mulshi", textsize = 2, linewidth = 5, freetype = FALSE,
              linecolor = "#df7c4d",
              textcolor = "#df7c4d",
              dashed = TRUE)
 render_label(dmat, x = 100, y = 100, z = 9000, zscale = 50,
              text = "Pawna", textsize = 2, linewidth = 5, freetype = FALSE,
              linecolor = "#df7c4d",
              textcolor = "#df7c4d",
              dashed = TRUE)
render_snapshot()


angles= seq(0,360,length.out = 1441)[-1]
for(i in 1:1440) {
  render_camera(theta=-45+angles[i])
  render_snapshot(filename = sprintf("pune%i.png", i))
}
rgl::rgl.close()


system("ffmpeg -framerate 60 -s 1920x1080 -i pune%d.png -pix_fmt yuv420p pune.mp4")


