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
nodes <- mutate(nodes, country_code = countrycode(country_code,
                                             origin="iso2c",
                                             destination = "country.name.en"))
countrynodes <- as.data.frame(table(nodes$country_code))
colnames(countrynodes) <- c("country_code", "node_count")

# coerce data type
countrynodes <- mutate(countrynodes, country_code = as.character(country_code))
countrynodes <- mutate(countrynodes, node_count = as.integer(node_count))
countries = readOGR(dsn = "data/ne_110m_admin_0_countries/", layer = "ne_110m_admin_0_countries")

countries.points <- tidy(countries, region = "NAME_SORT")

# And join in the original variables from the shapefile
countries.df <- left_join(countries.points, countries@data, by = c("id" = "NAME_SORT"))

# join node and sovereignty
joined <- left_join(countries.df, countrynodes, by = c("id" = "country_code"))

ggplot(data = joined, aes(x = long, y = lat, group = group, fill = node_count)) +
  geom_polygon(color = "white") +
  coord_map("mercator")