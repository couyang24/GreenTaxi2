# Visualization
greentaxi <- makeIcon(
  iconUrl = "https://i.imgur.com/6rw618Q.png",
  iconWidth = 38, iconHeight = 35,
  iconAnchorX = 19, iconAnchorY = 39
)


set.seed(0)
data %>% sample_n(size=10000) %>% 
  # filter(Pickup_latitude > 40.5,Pickup_longitude > -74.3,Pickup_latitude < 41,Pickup_longitude < -73.8) %>%
  leaflet() %>% 
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addCircleMarkers(~Pickup_longitude, ~Pickup_latitude, radius = 1,
                   color = "firebrick", fillOpacity = 0.001)


Weekday_Top5
Weekend_Top5

Weekday_Top5[1,] %>%
  leaflet() %>% 
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addCircleMarkers(~lng, ~lat, radius = 1,
                   color = "firebrick", fillOpacity = 0.001)%>%
  addMarkers(~lng, ~lat, icon = greentaxi)

Weekend_Top5 %>%
  leaflet() %>% 
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addCircleMarkers(~lng, ~lat, radius = 1,
                   color = "firebrick", fillOpacity = 0.001)%>%
  addMarkers(~lng, ~lat, icon = greentaxi)
