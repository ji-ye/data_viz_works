# DV-Assignment2
# Ji, Ye

setwd("./GitHub/data_viz_works/DV-assignment2/")

# Install dependencies
install.packages("easypackages")
library(easypackages)
packages("anytime","tidyverse","rmarkdown","readr", "haven", "dplyr", "stringr", "ggplot2")

# Import data
coinbase = read_csv("coinbaseUSD.csv")
colnames(coinbase) = c("unix_timestamp", "price", "volume_btc")
btcn = read_csv("btcnCNY_1-min_data_2012-01-01_to_2017-05-31.csv")

# Convert unix timestamp to human-readable date & time
coinbase <- mutate(coinbase, Timestamp = anytime(Timestamp))
coinbase <- mutate(coinbase, volume_usd = volume_btc * price)

# sample down to 1 percent
coinbase_lim <- sample_frac(coinbase, size = 0.01)

# Chart one - line chart
ggplot(data=coinbase_lim) + 
  geom_line(size=.25,aes(Time, price), color="#4b4b4b") +
  geom_vline(xintercept = as.POSIXct("2017-03-25"), colour="#ff7575", size=.75) +
  geom_smooth(aes(Time, price), span=20, linetype="dashed", color="#9eb8d8") +
  scale_x_datetime(name = "", date_breaks = "3 month") +
  scale_y_continuous(name ="Bitcoin to USD Exchange Rate", breaks = c(0, 500, 1000, 1500, 2000, 2500, 3000)) +
  ggtitle("Bitcoin Price Trend", subtitle = "Bitcoin price experienced the largest surge in history this year") +
  theme(panel.grid.major.y = element_line( size=.1, color="#666666"),
        panel.grid.major.x = element_line(),
        panel.background = element_blank(),
        plot.title = element_text(size=18, family = "Helvetica", colour = "#3a3a3a", face = "bold"),
        plot.subtitle = element_text(size=12, family = "mono", colour = "#666666")) +
  annotate(geom="text",x=as.POSIXct("2017-05-03"),
           y=800,label="Surge starts",colour="#ff7575", fontface="bold") +
  annotate(geom="text",x=as.POSIXct("2015-2-12"),
           y= 3100,label="Data Source: Coinbase API", size=3.5, family = "mono", colour = "#666666")
