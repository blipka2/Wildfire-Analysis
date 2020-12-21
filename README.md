# Wildfires in the United States from 1992-2015

## Group Members
Polina Bondarenko, Ben Lipka, Jason Han, Milan Rajababoo

## Motivation

In the past year, the United States has seen a series of extensive flooding, thunderstorms, and wildfires, especially on the West Coast. By the month of October, over [8.2 million acres](https://en.wikipedia.org/wiki/2020_Western_United_States_wildfire_season) of land burned, mostly across the states of California, Oregon, and Washington. Due this substantial media coverage of the recent wildfires in the United States and other [large-scale shifts in climate patterns](https://www.worldwildlife.org/stories/2020-a-critical-year-for-our-future-and-for-the-climate) in 2020, we wanted to explore recent trends regarding wildfires in the United States. This project focuses on exploring the data, visualizing the impact of wildfires in a user-friendly way, and building a decision tree to predict the cause of a wildfire.
                                                                                                         
## Data
                                                                                                         
This [dataset](https://doi.org/10.2737/RDS-2013-0009.4) contains spatial and temporal information about wildfires which have occurred in the United States between 1992 and 2015. Collection of the data was funded by the US Department of Agriculture and includes wildfire data compiled from US federal, state, and local reporting systems. The wildfires dataset is a SQLite database which contains a table named "Fires". This table has 1.88 million total observations taken over the 24 year time period, with the following columns:

- NWCGREPORTINGAGENCY: Active National Wildlife Coordinating Group (NWCG) Unit Identifier for the agency preparing the fire report (BIA = Bureau of Indian Affairs, BLM = Bureau of Land Management, BOR = Bureau of Reclamation, DOD = Department of Defense, DOE = Department of Energy, FS = Forest Service, FWS = Fish and Wildlife Service, IA = Interagency Organization, NPS = National Park Service, ST/C&L = State, County, or Local Organization, and TRIBE = Tribal Organization).
- NWCGREPORTINGUNIT_NAME: Active NWCG Unit Name for the unit preparing the fire report.
- FIRE_NAME: Name of the incident, from the fire report (primary) or ICS-209 report (secondary).
- FIRE_YEAR: Calendar year in which the fire was discovered or confirmed to exist.
- DISCOVERY_DATE: Date on which the fire was discovered or confirmed to exist.
- DISCOVERY_DOY: Day of year on which the fire was discovered or confirmed to exist.
- STATCAUSECODE: Code for the (statistical) cause of the fire.
- STATCAUSEDESCR: Description of the (statistical) cause of the fire.
- CONT_DATE: Date on which the fire was declared contained or otherwise controlled (mm/dd/yyyy where mm=month, dd=day, and yyyy=year).
- CONT_DOY: Day of year on which the fire was declared contained or otherwise controlled.
- FIRE_SIZE: Estimate of acres within the final perimeter of the fire.
- FIRESIZECLASS: Code for fire size based on the number of acres within the final fire perimeter expenditures (A=greater than 0 but less than or equal to 0.25 acres, B=0.26-9.9 acres, C=10.0-99.9 acres, D=100-299 acres, E=300 to 999 acres, F=1000 to 4999 acres, and G=5000+ acres).
- LATITUDE: Latitude (NAD83) for point location of the fire (decimal degrees).
- LONGITUDE: Longitude (NAD83) for point location of the fire (decimal degrees).
- OWNER_DESCR: Name of primary owner or entity responsible for managing the land at the point of origin of the fire at the time of the incident.
- STATE: Two-letter alphabetic code for the state in which the fire burned (or originated), based on the nominal designation in the fire report.
- COUNTY: County, or equivalent, in which the fire burned (or originated), based on nominal designation in the fire report.
- FIPS_CODE: Three-digit code from the Federal Information Process Standards (FIPS) publication 6-4 for representation of counties and equivalent entities.
- FIPS_NAME: County name from the FIPS publication 6-4 for representation of counties and equivalent entities.

## Key Libraries

- Data Preparation and Analysis: RSQLite, dbplyr, dplyr, purrr, xts, stats, data.table, dygraphs
- Data Visualization: usmap, ggplot2, ggfortify, ggthemes, maps, mapdata, leaflet, mapproj, plotly, highcharter
- Shiny App: shiny, shinythemes 
- Modeling: rpart, caret, randomForest

## Shiny App
                                                                                                         
Our project focuses on representing the wildfire dataset using an interactive Shiny app. One feature of the Shiny app allows the user to visualize the data on a map of the United States by selecting one of the following variables: total number of wildfires, average wildfire time duration, and average wildfire size. Additionally, the Shiny app shows the trend of the number of wildfires in each state over time in a barplot, alomng with a table of summary statistics. Lastly, the Shiny app shows predictors for the cause of a wildfire in the form of an interactive pie chart and includes a tab dedicated to predicting the cause of a wildfire using a decision tree model. 

## Lightning Talk Video Presentation

https://uofi.box.com/s/a92o0kp8r6qhr9dusynazv4c0lu0zfxg
