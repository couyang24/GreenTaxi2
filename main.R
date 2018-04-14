# Setup packages and load data
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, DT, lubridate, leaflet, leaflet.extras, maps, data.table, ggthemes)
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

# Dive into a few accounts

# vendorID only takes two value 1 and 2. Based on the Data Dictionary, 1 stands for Creative Mobile Technologies and 
# 2 stands for VeriFone Inc. Observations of vendor 2 is 3 times more than vendor 1. Presumably vendor 2 is the larger company.

data$VendorID %>% table() 

data$Store_and_fwd_flag %>% table() 

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
  scale_x_log10() +
  scale_y_sqrt()


data$Store_and_fwd_flag %>% table()

data %>% group_by(pickup_hour) %>% summarise(avg_trip_distance=mean(Trip_distance)) %>% 
  ggplot(aes(pickup_hour, avg_trip_distance)) + geom_col() +
  geom_label(aes(label=round(avg_trip_distance,1)), size=3.5, alpha=.7) +
  # coord_flip() +
  scale_x_continuous(breaks=seq(1,24,1)) +
  theme_economist() +
  theme(legend.position = 'none') +
  labs(title='Gale Interview Challenge',subtitle='by Owen Ouyang',caption="source: Green Taxi Data",
       y="Average Trip Distance", x="Time of Day (Pickup)")

data %>% filter(pickup_weekend=='Weekend') %>% group_by(pickup_hour) %>% summarise(avg_trip_distance=mean(Trip_distance)) %>% 
  ggplot(aes(pickup_hour, avg_trip_distance)) + geom_col() +
  geom_label(aes(label=round(avg_trip_distance,1)), size=3.5, alpha=.7) +
  # coord_flip() +
  scale_x_continuous(breaks=seq(1,24,1)) +
  theme_economist() +
  theme(legend.position = 'none') +
  labs(title='Gale Interview Challenge',subtitle='by Owen Ouyang',caption="source: Green Taxi Data",
       y="Average Trip Distance", x="Time of Day (Pickup)")

data %>% filter(pickup_weekend=='Weekday') %>% group_by(pickup_hour) %>% summarise(avg_trip_distance=mean(Trip_distance)) %>% 
  ggplot(aes(pickup_hour, avg_trip_distance)) + geom_col() +
  geom_label(aes(label=round(avg_trip_distance,1)), size=3.5, alpha=.7) +
  # coord_flip() +
  scale_x_continuous(breaks=seq(1,24,1)) +
  theme_economist() +
  theme(legend.position = 'none') +
  labs(title='Gale Interview Challenge',subtitle='by Owen Ouyang',caption="source: Green Taxi Data",
       y="Average Trip Distance", x="Time of Day (Pickup)")

round_num <- 3

Weekend_Top5 <- data %>% filter(pickup_weekend=='Weekend') %>% 
  group_by(lng=round(Pickup_longitude,round_num),lat=round(Pickup_latitude,round_num)) %>% 
  count() %>% arrange(desc(n)) %>% head(5)

Weekday_Top5 <- data %>% filter(pickup_weekend=='Weekday') %>% 
  group_by(lng=round(Pickup_longitude,round_num),lat=round(Pickup_latitude,round_num)) %>% 
  count() %>% arrange(desc(n)) %>% head(5)







data$Ehail_fee <- NULL

