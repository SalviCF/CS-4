## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)

## ----echo=TRUE,eval=TRUE,highlight=TRUE----------------------------------
# devtools::install_github("dkahle/ggmap")
# devtools::install_github("hrbrmstr/ggalt")

# load packages
library(ggplot2)
library(ggmap)
library(ggalt)

### CUIDADO - NO FUNCIONA AHORA
## Google ha cambiado desde finales de 2018 las condiciones
# DEbes dar una clave proporcionada en 
# Google cloud Plattform y te exije TARJETA DE CRÉDITO


# Map Plots Created With R And Ggmap
# Ver tutorial completo en: 
#https://www.littlemissdata.com/blog/maps

malaga <-  geocode("city Málaga Spain")  
# get longitude and latitude  
malaga
# Get the Map ----------------------------------------------

# Google Satellite Map
malaga.map <- qmap("city Málaga Spain", zoom=12, source = "google", maptype="satellite")  

malaga.map

# Google Road Map
malaga.map.road <- qmap("city Málaga Spain", zoom=12, source = "google", maptype="roadmap")  
malaga.map.road


# Get Coordinates   ---------------------
malaga_places <- c("Calle La Unión",
                   "Paseo de los Tilos")

places_loc <- geocode(malaga_places)  # get longitudes and latitudes


malaga.map + geom_point(aes(x=lon, y=lat),
                        data = places_loc, 
                        alpha = 0.7, 
                        size = 7, 
                        color = "tomato") + 
  geom_encircle(aes(x=lon, y=lat),
                data = places_loc, size = 1, color = "blue")

# Plot Google Road Map -------------------------------------
malaga.map.road + geom_point(aes(x=lon, y=lat),
                             data = places_loc, 
                             alpha = 0.7, 
                             size = 7, 
                             color = "tomato") + 
  geom_encircle(aes(x=lon, y=lat),
                data = places_loc, size = 2, color = "blue")



## ----echo=TRUE,eval=TRUE,highlight=TRUE----------------------------------
library(ggplot2)
data("midwest", package = "ggplot2")

gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state, size=popdensity)) + 
  geom_smooth(method="loess", se=F) + 
  xlim(c(0, 0.1)) + 
  ylim(c(0, 500000)) + 
  labs(subtitle="Area Vs Population", 
       y="Population", 
       x="Area", 
       title="Scatterplot", 
       caption = "Source: midwest")

plot(gg)

## ----echo=TRUE,eval=TRUE,highlight=TRUE----------------------------------
# devtools::install_github("hrbrmstr/ggalt")
library(ggplot2)
library(ggalt)
midwest_select <- midwest[midwest$poptotal > 350000 & midwest$poptotal <= 500000 & midwest$area > 0.01 &  midwest$area < 0.1, ]

# Plot
ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state, size=popdensity)) +   # draw points
  geom_smooth( ) + 
  xlim(c(0, 0.1)) + 
  ylim(c(0, 500000)) +   # draw smoothing line
  geom_encircle(aes(x=area, y=poptotal), 
                data=midwest_select, 
                color="red", 
                size=2, 
                expand=0.08) +   # encircle
  labs(subtitle="Area Vs Population", 
       y="Population", 
       x="Area", 
       title="Scatterplot + Encircle", 
       caption="Source: midwest")

