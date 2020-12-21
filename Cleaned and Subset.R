library(RSQLite)
library(dbplyr)
library(dplyr)
library(purrr)
library(ggplot2)
library(xts)
library(ggfortify)
library(ggthemes)
library(maps)
library(mapdata)
library(leaflet)
library(mapproj)
library(data.table)

# create db connection
conn <- dbConnect(SQLite(), 'FPA_FOD_20170508.sqlite')

# pull the fires table into RAM
fires <- tbl(conn, "Fires") %>% collect()

# check size
print(object.size(fires), units = 'Gb')

# disconnect from db
dbDisconnect(conn)

glimpse(fires)

#bar chart
fires %>% 
  group_by(FIRE_YEAR) %>%
  summarize(n_fires = n()) %>%
  ggplot(aes(x = FIRE_YEAR, y = n_fires/1000)) + 
  geom_bar(stat = 'identity', fill = 'orange') +
  geom_smooth(method = 'lm', se = FALSE, linetype = 'dashed', size = 0.4, color = 'red') + 
  labs(x = '', y = 'Number of wildfires (thousands)', title = 'US Wildfires by Year')

#fires by size
size_classes <- c('A' = '0-0.25', 'B' = '0.26-9.9', 'C' = '10.0-99.9', 'D' = '100-299', 'E' = '300-999',
                  'F' = '1000-4999', 'G' = '5000+')

fires %>% 
  group_by(FIRE_SIZE_CLASS) %>%
  summarize(n = n()) %>%
  mutate(FIRE_SIZE_CLASS = size_classes[FIRE_SIZE_CLASS]) %>%
  ggplot(aes(x = FIRE_SIZE_CLASS, y= n)) +
  geom_bar(stat = 'identity', fill = 'Orange') +
  labs(x = 'Fire size (acres)', y = 'Number of fires', title = 'Number of Wildfires by Size Class')

#fires by causes
fires %>%
  group_by(STAT_CAUSE_DESCR) %>%
  summarize(n_fires = n()/1000) %>%
  ggplot(aes(x = reorder(STAT_CAUSE_DESCR, n_fires), y = n_fires)) +
  geom_bar(stat = 'identity', fill = 'orange') + 
  coord_flip() + 
  labs(x = '', y = 'Number of fires (thousands)', title = 'US Wildfires by Cause 1992 to 2015')

# Add codes for DC and Puerto Rico to the default state lists
state.abb <- append(state.abb, c("DC", "PR"))
state.name <- append(state.name, c("District of Columbia", "Puerto Rico"))

# Map the state abbreviations to state names so we can join with the map data
fires$region <- map_chr(fires$STATE, function(x) { tolower(state.name[grep(x, state.abb)]) })

# Get the us state map data
state_map <- map_data('state')

fires %>% 
  select(region) %>%
  group_by(region) %>%
  summarize(n = n()) %>%
  right_join(state_map, by = 'region') %>%
  ggplot(aes(x = long, y = lat, group = group, fill = n)) + 
  geom_polygon() + 
  geom_path(color = 'white') + 
  scale_fill_continuous(low = "orange", 
                        high = "darkred",
                        name = 'Number of fires') + 
  theme_map() + 
  coord_map('albers', lat0=30, lat1=40) + 
  ggtitle("US Wildfires, 1992-2015") + 
  theme(plot.title = element_text(hjust = 0.5))

#NWCG_REPORTING_AGENCY
#NWCG_REPORTING_UNIT_NAME
#FIRE_NAME
#FIRE_YEAR
#DISCOVERY_DATE
#DISCOVERY_DOY
#STAT_CAUSE_CODE
#STAT_CAUSE_DESCR
#CONT_DATE
#CONT_DOY                         
#FIRE_SIZE
#FIRE_SIZE_CLASS
#OWNER_DESCR
#STATE
#COUNTY 

myvars <- c("NWCG_REPORTING_AGENCY", "NWCG_REPORTING_UNIT_NAME", "FIRE_NAME", "FIRE_YEAR", "DISCOVERY_DATE", "DISCOVERY_DOY",
            "STAT_CAUSE_CODE", "STAT_CAUSE_DESCR", "CONT_DATE", "CONT_DOY", "FIRE_SIZE", "FIRE_SIZE_CLASS", "OWNER_DESCR",
            "STATE", "COUNTY")
subsetFire <- fires[myvars]

cleanedFire <- na.omit(subsetFire)
#over 1.4Million OBS removed


fireCA <- cleanedFire[cleanedFire$STATE=='CA',]
fireIL <- cleanedFire[cleanedFire$STATE=='IL',]
fireAZ <- cleanedFire[cleanedFire$STATE=='AZ',]
fireNY <- cleanedFire[cleanedFire$STATE=='NY',]



