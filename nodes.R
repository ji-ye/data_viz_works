install.packages("easypackages")
library(easypackages)
packages("anytime","tidyverse","rmarkdown","readr", "haven", "dplyr", "stringr", "ggplot2", "xts", "igraph")

nodes = read_csv("./data/20171021_nodes.csv")
nodes <- mutate(nodes, country = countrycode(country_code,
                                             origin="iso2c",
                                             destination = "country.name.en"))
country_list <- table(nodes$country)
country_list <- as.data.frame(country_list)
colnames(country_list) = c('country', 'node')

hist <- ggplot(data=country_list, aes(reorder(factor(country), node), node)) +
  geom_col(width=0.9, position=position_dodge(width=5), fill = "#999999") +
  geom_text(aes(label=node),
            color="#666666",
            position=position_dodge(width=0.9),
            vjust=0.35,
            hjust=-.25) +
  ggtitle("Bitcoin Nodes Distribution by Countries",
          subtitle = "Reachable nodes as of Oct 21, 2017") +
  ylab("") +
  xlab("") +
  labs(caption = "Data source: BitNodes.21.co") +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(size=18,
                                  family = "Helvetica",
                                  colour = "#3a3a3a",
                                  face = "bold"),
        plot.subtitle = element_text(size=12, family = "mono", colour = "#666666"),
        axis.text.y = element_text(color="#325a8c"),
        axis.title.y = element_text(color="#325a8c"),
        axis.ticks.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        legend.position = "none",
        plot.caption = element_text(size=11, family = "mono", colour = "#666666"),
        plot.margin = unit(c(2,2,2,2), "cm")) +
  scale_x_discrete(expand=c(0,0)) +
  coord_flip()

hist