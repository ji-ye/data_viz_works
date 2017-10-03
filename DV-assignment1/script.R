# 1. Install required packages
install.packages("easypackages")
library(easypackages)
packages("readr", "haven", "dplyr", "tidyr", "stringr", "ggplot2")


# 2. Load data
getwd()
setwd("./DV-assignment1")
dir()

acc2015 <- read_csv(dir()[[1]])
acc2014 <- read_sas(dir()[[2]])

class(acc2014)
class(acc2015)


# 3. Combine two datasets
acc2014 <- mutate(acc2014, TWAY_ID2 = na_if(TWAY_ID2, ""))
table(is.na(acc2014$TWAY_ID2))

dim(acc2014)
dim(acc2015)

colnames(acc2014) %in% colnames(acc2015)
colnames(acc2015) %in% colnames(acc2014)

# 3.1 id the unmatched columns
setdiff(colnames(acc2014), colnames(acc2015))
# note: "ROAD_FNC" not in acc2015

setdiff(colnames(acc2015), colnames(acc2014))
# note: "RUR_URB"  "FUNC_SYS" "RD_OWNER" not in acc2014

acc = bind_rows(acc2014, acc2015)
count(acc, RUR_URB) # or, table(acc$RUR_URB, exclude=NULL)
# note: There are 30056 NA because "The output of bind_rows will contains a
# column if that column appears in any of the inputs". RUR_URB was not in acc2014,
# so all 30056 observations of acc2014 have NA for it.


# 4. Merge on another data source
fips = read_csv("fips.csv")
glimpse(fips)

acc$STATE <- as.character(acc$STATE)
acc$COUNTY <- as.character(acc$COUNTY)

acc$STATE <- str_pad(acc$STATE, 2, "left", "0")
acc$COUNTY <- str_pad(acc$COUNTY, 3, "left", "0")

acc <- plyr::rename(acc, c(STATE = "StateFIPSCode"))
acc <- plyr::rename(acc, c(COUNTY = "CountyFIPSCode"))

acc <- left_join(acc, fips)


# 5. Exploratory data analysis
agg <- summarize(group_by(acc, StateName, YEAR), TOTAL = sum(FATALS))
agg_wide <- agg %>% spread(YEAR, TOTAL)

colnames(agg_wide) <- c("StateName", 'Y2014', 'Y2015')

agg_wide <- mutate(agg_wide, Diff_perc = (Y2015 - Y2014) / Y2014)

agg_wide <- arrange(agg_wide, desc(Diff_perc))

agg <- filter(agg_wide, Diff_perc > .15 & !is.na(StateName))

# doing the above with "%>%" and only one "<-"
agg <- acc %>% group_by(StateName, YEAR) %>% summarize(TOTAL = sum(FATALS)) %>% spread(YEAR, TOTAL) %>% `colnames<-`(c("StateName", "Y2014", "Y2015")) %>% mutate(Diff_perc = (Y2015 - Y2014) / Y2014) %>% arrange(desc(Diff_perc)) %>% filter(Diff_perc >.15 & !is.na(StateName))
# Please note that there is a second "<-" in the optional renaming task ("colnames<-"). 

glimpse(agg)
