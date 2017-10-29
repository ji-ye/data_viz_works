library("easypackages")
packages("anytime",
         "tidyverse",
         "rmarkdown",
         "readr",
         "haven",
         "dplyr",
         "stringr",
         "ggplot2",
         "xts",
         "igraph",
         "countrycode",
         "extrafont",
         "waffle",
         #"maps",
         "gpclib",
         "rgeos",
         "rgdal",
         "maptools",
         "ggplot2",
         "sp",
         "ggmap",
         "broom")

theme_clean_map <- function(base_size = 12) {
  require(grid)
  theme_grey(base_size) %+replace%
    theme(
      axis.title      =   element_blank(),
      axis.text       =   element_blank(),
      axis.ticks       =   element_blank(),
      panel.background    =   element_blank(),
      panel.grid      =   element_blank(),
      panel.spacing    =   unit(0,"lines"),
      plot.margin     =   unit(c(0,0,0,0),"lines"),
      complete = TRUE
    )
}

# Bitcoin nodes data
nodes = read_csv("./data/20171021_nodes.csv")
nodes <- mutate(nodes, country = countrycode(country_code,
                                             origin="iso2c",
                                             destination = "iso3c"))
countrynodes <- as.data.frame(table(nodes$country))
colnames(countrynodes) <- c("country_iso3", "node_count")

# coerce data type
countrynodes <- mutate(countrynodes, country_iso3 = as.character(country_iso3))
countrynodes <- mutate(countrynodes, node_count = as.integer(node_count))
sovereignty = readOGR(dsn = "data/ne_110m_admin_0_sovereignty/", layer = "ne_110m_admin_0_sovereignty")

sovereignty.points <- tidy(sovereignty, region = "ADM0_A3_IS")

# And join in the original variables from the shapefile
sovereignty.df <- left_join(sovereignty.points, sovereignty@data, by = c("id" = "ADM0_A3_IS"))

# join node and sovereignty
joined <- left_join(sovereignty.df, countrynodes, by = c("ADM0_A3_US" = "country_iso3"))

ggplot(data = joined, aes(x = long, y = lat, group = group, fill = node_count)) +
  geom_polygon(color = "white") +
  coord_map("mercator")