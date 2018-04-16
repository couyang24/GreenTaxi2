# Visualization

round_num <- 3

Weekend_Top5 <- data %>% filter(pickup_weekend=='Weekend') %>% 
  group_by(lng=round(Pickup_longitude,round_num),lat=round(Pickup_latitude,round_num)) %>% 
  count() %>% arrange(desc(n)) %>% head(5)

Weekday_Top5 <- data %>% filter(pickup_weekend=='Weekday') %>% 
  group_by(lng=round(Pickup_longitude,round_num),lat=round(Pickup_latitude,round_num)) %>% 
  count() %>% arrange(desc(n)) %>% head(5)

rm(round_num)



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

Weekday_Top5 %>%
  leaflet() %>% 
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addCircleMarkers(~lng, ~lat, radius = 1,
                   color = "firebrick", fillOpacity = 0.001)%>%
  addMarkers(~lng, ~lat, icon = greentaxi, label = ~as.character(paste("Number of Pick ups:",Weekday_Top5$n)))

Weekend_Top5 %>%
  leaflet() %>% 
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addCircleMarkers(~lng, ~lat, radius = 1,
                   color = "firebrick", fillOpacity = 0.001)%>%
  addMarkers(~lng, ~lat, icon = greentaxi)
