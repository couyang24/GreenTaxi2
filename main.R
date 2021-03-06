# Setup packages and load data
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, DT, lubridate, leaflet, leaflet.extras, maps, data.table, ggthemes, rebus, clue)
# data <- read.csv("green_tripdata_2016-02.csv", stringsAsFactors = F)
# write_csv(data,"green_tripdata_2016-02v2.csv")
data <- fread("green_tripdata_2016-02v2.csv", stringsAsFactors = F, data.table = FALSE, na.strings=c("NA","NaN","?", ""))

# initial view
data %>% head()
data %>% str() # 1510722 obs. of  21 variables
data %>% summary() # Ehail_fee has only NA

dim(data)

data %>% head(20) %>% datatable()

colSums(is.na(data))

# Correcting & Completing
# Since the trip payment is not in the scole of this analysis, I took out these variables for shorter runing time.
data[,which(str_detect(names(data),"amount|fee|Extra|fee|Pay|tax|ID|charge"))] <- NULL

# Looking at the summary result, most value in pickup_longitude is around -73.95 (Presumbly where New York is) but the
# variable also have 0 and -115.28. Then, I put the pickup location on the map below, we see the locations in Guinea Basin
# and Las Vegas. The Guinea Basin location is due to having 0 longtitude and latitude. The Las Vegas locations seem interesting
# for which, might worth some time to dig into but it is beyond the scope of this analysis.

set.seed(0)
data %>% sample_n(size=10000) %>% 
  leaflet() %>% 
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addCircleMarkers(~Pickup_longitude, ~Pickup_latitude, radius = 1,
                   color = "firebrick", fillOpacity = 0.001)


# Therefore, I limited the boundary to New York and got rid out these locations. Then, I got the map below. It is very interesting
# to see that all the pick up location are outside of the core area of new york city. By doing a little research, I found out that
# the green taxi are only allowed to pick up passengers (street hails or calls) in outer boroughs (excluding John F. Kennedy
# International Airport and LaGuardia Airport unless arranged in advance) and in Manhattan above East 96th and West 110th Streets.
# That explains the pattern we see here.

data <- data %>% filter(Pickup_longitude > -75, Pickup_longitude < -73, Pickup_latitude > 40.4, Pickup_latitude <41,
                        Dropoff_longitude!=0,Dropoff_latitude!=0)


set.seed(0)
data %>% sample_n(size=10000) %>% 
  leaflet() %>% 
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addCircleMarkers(~Pickup_longitude, ~Pickup_latitude, radius = 1,
                   color = "firebrick", fillOpacity = 0.001)






data %>% sample_n(size=10000) %>% 
  leaflet() %>% 
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addCircleMarkers(~Pickup_longitude, ~Pickup_latitude, radius = 1,
                   color = "firebrick", fillOpacity = 0.001,
                   clusterOptions = markerClusterOptions())






# Dive into a few accounts

# vendorID only takes two value 1 and 2. Based on the Data Dictionary, 1 stands for Creative Mobile Technologies and 
# 2 stands for VeriFone Inc. Observations of vendor 2 is 3 times more than vendor 1. Presumably vendor 2 is the larger company.

data$VendorID %>% table() 

data$RateCodeID %>% table() 

# 

data <- data %>% mutate(lpep_pickup_datetime = ymd_hms(lpep_pickup_datetime),
                pickup_hour=hour(lpep_pickup_datetime)+1,
                pickup_weekday=as.factor(weekdays(lpep_pickup_datetime)),
                pickup_weekend=if_else(pickup_weekday=='Saturday'|pickup_weekday=='Sunday','Weekend','Weekday'),
                Lpep_dropoff_datetime = ymd_hms( Lpep_dropoff_datetime),
                dropoff_hour=hour(lpep_pickup_datetime)+1,
                dropoff_weekday=as.factor(weekdays(lpep_pickup_datetime)))



data %>%
  ggplot(aes(Trip_distance)) +
  geom_histogram(fill = "firebrick", bins = 150) +
  theme_economist() +
  labs(title='Green Taxi Case Study',subtitle='Initial Historgram of Distance',caption="source: NYC Green Taxi Data",
       x="Travel Distance")



data %>%
  ggplot(aes(Trip_distance)) +
  geom_histogram(fill = "firebrick", bins = 150) +
  scale_x_log10() +
  theme_economist() +
  labs(title='Green Taxi Case Study',subtitle='Processed Historgram of Distance',caption="source: NYC Green Taxi Data",
       x="Travel Distance")



data %>% group_by(pickup_hour) %>% summarise(avg_trip_distance=median(Trip_distance)) %>% 
  ggplot(aes(pickup_hour, avg_trip_distance)) + geom_col() +
  geom_label(aes(label=round(avg_trip_distance,1)), size=3.5, alpha=.7) +
  # coord_flip() +
  scale_x_continuous(breaks=seq(1,24,1)) +
  theme_economist() +
  theme(legend.position = 'none') +
  labs(title='Green Taxi Case Study',subtitle='by Owen Ouyang',caption="source: Green Taxi Data",
       y="Average Trip Distance", x="Time of Day (Pickup)")


data %>% filter(pickup_weekend=='Weekend') %>% group_by(pickup_hour) %>% summarise(avg_trip_distance=median(Trip_distance)) %>% 
  ggplot(aes(pickup_hour, avg_trip_distance)) + geom_col() +
  geom_label(aes(label=round(avg_trip_distance,1)), size=3.5, alpha=.7) +
  # coord_flip() +
  scale_x_continuous(breaks=seq(1,24,1)) +
  theme_economist() +
  theme(legend.position = 'none') +
  labs(title='Green Taxi Case Study',subtitle='by Owen Ouyang',caption="source: Green Taxi Data",
       y="Average Trip Distance", x="Time of Day (Pickup)")

data %>% filter(pickup_weekend=='Weekday') %>% group_by(pickup_hour) %>% summarise(avg_trip_distance=median(Trip_distance)) %>% 
  ggplot(aes(pickup_hour, avg_trip_distance)) + geom_col() +
  geom_label(aes(label=round(avg_trip_distance,1)), size=3.5, alpha=.7) +
  # coord_flip() +
  scale_x_continuous(breaks=seq(1,24,1)) +
  theme_economist() +
  theme(legend.position = 'none') +
  labs(title='Green Taxi Case Study',subtitle='by Owen Ouyang',caption="source: Green Taxi Data",
       y="Average Trip Distance", x="Time of Day (Pickup)")


data %>%
  group_by(pickup_hour, pickup_weekend) %>%
  summarise(avg_trip_distance=median(Trip_distance)) %>%
  ggplot(aes(pickup_hour, avg_trip_distance, color = pickup_weekend)) +
  geom_smooth(method = "loess", span = 1/2, se=F) +
  geom_point(size = 4) +
  labs(x = "Time of Day (Pickup)", y = "Average Trip Distance") +
  scale_x_continuous(breaks=seq(1,24,1)) +
  theme_economist() +
  scale_color_discrete("Weekday vs. Weekend")


data$Trip_type %>% table()

data_coord <- data %>% filter(Trip_type==1) %>% select(Pickup_longitude, Pickup_latitude)

data_coord %>% summary()

set.seed(0)
data_kmeans <- data_coord %>% kmeans(50,nstart=20)

save(data_kmeans, file = "data_kmeans.rda")

load("data_kmeans.rda")

data1 <- data %>% filter(Trip_type==1)
data1$cluster <- data_kmeans$cluster

data1 %>% select(Pickup_longitude,Pickup_latitude) %>% summary()

pal <- colorNumeric(
  palette = "Blues",
  domain = data$cluster)


set.seed(0)
data1 %>% sample_n(size=10000) %>% 
  leaflet() %>% 
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addCircleMarkers(~Pickup_longitude, ~Pickup_latitude, radius = 1,
                   color = ~pal(cluster), fillOpacity = 0.001)


greentaxi2 <- makeIcon(
  iconUrl = "https://i.imgur.com/6rw618Q.png",
  iconWidth = 18, iconHeight = 15,
  iconAnchorX = 9, iconAnchorY = 19
)


data_kmeans$centers %>% as_data_frame() %>%
  leaflet() %>% 
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addCircleMarkers(~Pickup_longitude, ~Pickup_latitude, radius = 1,
                   color = "firebrick", fillOpacity = 0.001)%>%
  addMarkers(~Pickup_longitude, ~Pickup_latitude, icon = greentaxi2)


x <- data_frame(Pickup_longitude= -73.90395, Pickup_latitude= 40.86587)

data_kmeans$centers


(cluster_num <- cl_predict(data_kmeans,x))

result <- data1 %>% filter(cluster==cluster_num)

result %>% str()


round_num <- 3
top20 <- result %>% group_by(lng=round(Pickup_longitude,round_num),lat=round(Pickup_latitude,round_num)) %>% 
  count() %>% arrange(desc(n)) %>% head(20) 
top20 %>% 
  leaflet() %>% 
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addCircleMarkers(~lng, ~lat, radius = 1,
                   color = "firebrick", fillOpacity = 0.001)%>%
  addMarkers(~lng, ~lat, icon = greentaxi2, label = ~as.character(paste("Number of Pick ups:",result$n)))

x
dist <- list()
for (i in 1:20) {
  dist[i] <- abs(top20[i,1]-x[1])+abs(top20[i,2]-x[2])
}

dist %>% which.min()

write_csv(data,"processed_data.csv")
