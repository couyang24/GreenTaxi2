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



data %>% group_by(pickup_hour) %>% summarise(avg_trip_distance=median(Trip_distance)) %>% 
  ggplot(aes(pickup_hour, avg_trip_distance)) + geom_col() +
  geom_label(aes(label=round(avg_trip_distance,1)), size=3.5, alpha=.7) +
  # coord_flip() +
  scale_x_continuous(breaks=seq(1,24,1)) +
  theme_economist() +
  theme(legend.position = 'none') +
  labs(title='Green Taxi Case Study',subtitle='by Owen Ouyang',caption="source: Green Taxi Data",
       y="Average Trip Distance", x="Time of Day (Pickup)")