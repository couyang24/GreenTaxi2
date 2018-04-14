# Setup packages and load data
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, DT, lubridate, leaflet, leaflet.extras, maps, data.table)
# data <- read.csv("green_tripdata_2016-02v2.csv", stringsAsFactors = F)
# write_csv(data,"green_tripdata_2016-02v2.csv")
data <- fread("green_tripdata_2016-02v2.csv", stringsAsFactors = F, data.table = FALSE, na.strings=c("NA","NaN","?", ""))

# initial view
data %>% head()
data %>% str() # 1510722 obs. of  21 variables
data %>% summary() # Ehail_fee has only NA



data %>% head(20) %>% datatable()

colSums(is.na(data))

# Dive into a few accounts

# vendorID only takes two value 1 and 2. 
# Presumably 
data$VendorID %>% table() 

data %>% mutate(lpep_pickup_datetime = ymd_hms(lpep_pickup_datetime),
                pickup_hour=hour(lpep_pickup_datetime),
                pickup_weekday=weekdays(lpep_pickup_datetime),
                Lpep_dropoff_datetime = ymd_hms( Lpep_dropoff_datetime)) %>% 
  head()




data$Store_and_fwd_flag %>% table()









data$Ehail_fee <- NULL

