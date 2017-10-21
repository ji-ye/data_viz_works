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
rectangle <- data.frame(xmin = as.POSIXct(c("2017-03-25")),
                        xmax = as.POSIXct(c("2017-10-21")),
                        ymin = -Inf, ymax = Inf)

line <- ggplot(data=btc_price) +
  geom_line(size=.25,
            aes(Date, Value),
            color="#325a8c") +
  geom_vline(xintercept = as.POSIXct("2017-03-25"),
             colour="#ff7575",
             size=.5,
             alpha=.75) +
  geom_smooth(aes(Date, Value),
              size=0.5,
              alpha=0.1,
              span=0.5,
              color="#325a8c",
              linetype="twodash"
              ) +
  scale_x_datetime(name = "",
                   date_breaks = "3 month",
                   expand = c(0,0)) +
  scale_y_continuous(name ="Bitcoin Market Price in USD",
                     breaks = (seq(0,6000,1000)),
                     expand = c(0,0)) +
  ggtitle("Bitcoin Price",
          subtitle = "experienced the greatest surge in history this year") +
  labs(caption = "Source: Blockchain.com") +
  annotate(geom="text",
           x=as.POSIXct("2015-09-11"),
           y=2200,
           label="2017-03-25 Surge starts",
           colour="#ff7575",
           fontface="bold",
           alpha=.85) +
  theme_jiye

line + geom_rect(data = rectangle, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
                 fill = "#ff7575", alpha = 0.1)
