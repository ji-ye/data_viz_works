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

# aggregate trading volume data into month
packages("xts")
ts <- xts(coinbase_lim$volume_usd, as.Date(coinbase_lim$Date, "%Y-%m-%d"))
ts_d = apply.daily(ts, FUN=sum)
ts_m = apply.daily(ts_d, FUN=sum)
df_m <- data.frame(date=index(ts_m), coredata(ts_m))

# Charts - Bitcoin exchange price & volume
# note: color #85bb65" is known as dollar bill.
p <- ggplot(data=coinbase_lim) + 
  geom_line(size=.25,aes(Time, price), color="#325a8c") +
  geom_point(data=df_m, aes(as.POSIXct(date), size=100, col1/5000, alpha=.9), color="#85bb65") + 
  geom_vline(xintercept = as.POSIXct("2017-03-25"), colour="#ff7575", size=.75, alpha=.75) +
  geom_smooth(aes(Time, price), span=2, linetype="longdash", color="#4c88d3", alpha=.5) +
  scale_x_datetime(name = "", date_breaks = "3 month") +
  scale_y_continuous(name ="Bitcoin Hourly Exchange Rate in USD",
                     breaks = c(0, 500, 1000, 1500, 2000, 2500, 3000),
                     sec.axis = sec_axis(~.*5, name = "Monthly Trading Volume in USD (thousands)")) +
  ggtitle("Bitcoin Price & Volume", subtitle = "both experienced the greatest surge in history this year") +
  annotate(geom="text",x=as.POSIXct("2017-05-30"),
           y=675,label="2017-03-25 Surge starts",colour="#ff7575", fontface="bold", alpha=.85) +
  annotate(geom="text",x=as.POSIXct("2015-2-08"),
           y= 3100,label="Data Source: Coinbase API", size=3.5, family = "mono", colour = "#666666") +
  theme(panel.grid.major.y = element_line( size=.1, color="#666666"),
        panel.grid.major.x = element_line(),
        panel.background = element_blank(),
        plot.title = element_text(size=18, family = "Helvetica", colour = "#3a3a3a", face = "bold"),
        plot.subtitle = element_text(size=12, family = "mono", colour = "#666666"),
        axis.title.y.right = element_text(color="#85bb65"),
        axis.text.y.right = element_text(color="#85bb65"),
        axis.text.y = element_text(color="#325a8c"),
        axis.title.y = element_text(color="#325a8c"),
        axis.ticks.y = element_line( size=.25, color="#666666"),
        axis.text.x = element_text(color="#7f7f7f"),
        legend.position = "none",
        plot.margin = unit(c(1,1,1,1), "cm"))
