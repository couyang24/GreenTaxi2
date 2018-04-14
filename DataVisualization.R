# Visualization
greentaxi <- makeIcon(
  iconUrl = "https://i.imgur.com/2ZpKexL.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94
)



data %>%
  filter(Pickup_latitude > 40.5,Pickup_longitude > -74.3,Pickup_latitude < 41,Pickup_longitude < -73.8) %>% 
  tail(50) %>% 
  leaflet() %>% 
  
  # addProviderTiles(providers$Stamen.Toner) %>%
  
  addProviderTiles(providers$CartoDB.Positron) %>%
  
  # addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  
  # addProviderTiles(providers$MtbMap) %>%
  
  # addProviderTiles(providers$Stamen.TonerLines,
  #                  options = providerTileOptions(opacity = 0.35)) %>%
  # addProviderTiles(providers$Stamen.TonerLabels) %>%
  
  addCircleMarkers(~Pickup_longitude, ~Pickup_latitude, radius = 1,
                   color = "firebrick", fillOpacity = 0.001)%>%
  addMarkers(~Pickup_longitude, ~Pickup_latitude, icon = greentaxi)
