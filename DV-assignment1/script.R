# Install required packages
install.packages("easypackages")
library(easypackages)
packages("readr", "haven", "dplyr", "tidyr", "stringr", "ggplot2")

# Load data
getwd()
setwd("./Github/data_viz_works/")

acc2015 <- read_csv(dir()[[1]])
acc2014 <- read_sas(dir()[[2]])

class(acc2014)
class(acc2015)

# Combine two datasets


# Merging on another data source


# Data exploration


# ggplot2