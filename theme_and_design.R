install.packages("easypackages", repos = "http://cran.us.r-project.org")
library(easypackages)
packages("anytime","tidyverse","rmarkdown","readr", "haven", "dplyr", "stringr", "ggplot2", "xts", "igraph")

# load data
btc_price = read_csv("./data/BCHAIN-MKPRU.csv")
btc_price <- mutate(btc_price, Date = as.POSIXct(Date))

# set theme
theme_jiye <- theme(panel.grid.major.y =element_line( size=.1, color="#999999"),
                    panel.grid.major.x = element_blank(),
                    panel.background = element_blank(),
                    plot.title = element_text(size=18,
                                              family = "Helvetica",
                                              colour = "#3a3a3a",
                                              face = "bold"),
                    plot.subtitle = element_text(size=12,
                                                 family = "mono",
                                                 colour = "#666666"),
                    axis.title.y = element_text(colour="#325a8c"),
                    axis.text.y = element_text(colour="#325a8c"),
                    axis.text.x = element_blank(),
                    axis.ticks.y = element_blank(),
                    axis.ticks.x = element_blank(),
                    legend.position = "none",
                    plot.caption = element_text(size=11,
                                                family = "mono",
                                                colour = "#666666",
                                                hjust = 0),
                    plot.margin = unit(c(2,2,2,2), "cm"))

# graph 1 - line
line <- ggplot(data=btc_price) +
  geom_line(size=.25,
            aes(Date, Value),
            color="#325a8c") +
  geom_vline(xintercept = as.POSIXct("2017-03-25"),
             colour="#ff7575",
             size=.75,
             alpha=.75) +
  geom_smooth(aes(Date, Value),
              span=2,
              linetype="longdash",
              color="#4c88d3",
              alpha=.5) +
  scale_x_datetime(name = "",
                   date_breaks = "3 month") +
  scale_y_continuous(name ="Bitcoin Hourly Exchange Rate in USD",
                     breaks = (seq(0,6000,1000))) +
  ggtitle("Bitcoin Price",
          subtitle = "experienced the greatest surge in history this year") +
  labs(caption = "Source: Blockchain.com") +
  annotate(geom="text",
           x=as.POSIXct("2017-05-30"),
           y=675,
           label="2017-03-25 Surge starts",
           colour="#ff7575",
           fontface="bold",
           alpha=.85) +
  theme_jiye

line
