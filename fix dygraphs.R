#make sure working directory is correct
library(shiny)
library(usmap)
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
library(stats)
library(data.table)

library(hrbrthemes) #Comment out this + ggiraph
#this package might cause you problems. you might need to download something called XQuartz

library(dygraphs)
library(plotly)
library(highcharter)

library(ggiraph) #comment out this + hrbrthemes and it should work but not what we want
#this package might cause you problems. you might need to download something called XQuartz

library(shinythemes)


# create db connection
conn <- dbConnect(SQLite(), 'FPA_FOD_20170508.sqlite')

# pull the fires table into RAM
fires <- tbl(conn, "Fires") %>% collect()

# check size
print(object.size(fires), units = 'Gb')

# disconnect from db
# subset by selecting important columns, reformatting date columns, and adding fire duration (in days) column
subsetFire <- dbGetQuery(conn, 
                         "SELECT NWCG_REPORTING_AGENCY, NWCG_REPORTING_UNIT_NAME, FIRE_NAME, FIRE_YEAR, 
                       date(DISCOVERY_DATE) as DISCOVERY_DATE, DISCOVERY_DOY, STAT_CAUSE_CODE, STAT_CAUSE_DESCR, 
                       date(CONT_DATE) as CONT_DATE, CONT_DOY, FIRE_SIZE, FIRE_SIZE_CLASS, OWNER_DESCR, STATE, COUNTY,
                       FIPS_CODE,FIPS_NAME, (CONT_DOY-DISCOVERY_DOY+1) as DURATION_DAYS
                       FROM fires;")
# remove NA values: over 1.4 million observations removed

#Dataset we will use for the rest of the code
cleanedFire <- na.omit(subsetFire)
dbDisconnect(conn)

fires_state <- cleanedFire %>% 
  select(state=STATE, DURATION_DAYS, FIRE_SIZE) %>%
  group_by(state) %>%
  summarize(n = n(), DURATION_DAYS=mean(DURATION_DAYS), FIRE_SIZE=mean(FIRE_SIZE))

#### data related to bar graphs

fireAL <- cleanedFire[cleanedFire$STATE=='AL',]
fireAK <- cleanedFire[cleanedFire$STATE=='AK',]
fireAZ <- cleanedFire[cleanedFire$STATE=='AZ',]
fireAR <- cleanedFire[cleanedFire$STATE=='AR',]
fireCA <- cleanedFire[cleanedFire$STATE=='CA',]
fireCO <- cleanedFire[cleanedFire$STATE=='CO',]
fireCT <- cleanedFire[cleanedFire$STATE=='CT',]
fireDE <- cleanedFire[cleanedFire$STATE=='DE',]
fireFL <- cleanedFire[cleanedFire$STATE=='FL',]
fireGA <- cleanedFire[cleanedFire$STATE=='GA',]
fireHI <- cleanedFire[cleanedFire$STATE=='HI',]
fireID <- cleanedFire[cleanedFire$STATE=='ID',]
fireIL <- cleanedFire[cleanedFire$STATE=='IL',]
fireIN <- cleanedFire[cleanedFire$STATE=='IN',]
fireIA <- cleanedFire[cleanedFire$STATE=='IA',]
fireKS <- cleanedFire[cleanedFire$STATE=='KS',]
fireKY <- cleanedFire[cleanedFire$STATE=='KY',]
fireLA <- cleanedFire[cleanedFire$STATE=='LA',]
fireME <- cleanedFire[cleanedFire$STATE=='ME',]
fireMD <- cleanedFire[cleanedFire$STATE=='MD',]
fireMA <- cleanedFire[cleanedFire$STATE=='MA',]
fireMI <- cleanedFire[cleanedFire$STATE=='MI',]
fireMN <- cleanedFire[cleanedFire$STATE=='MN',]
fireMS <- cleanedFire[cleanedFire$STATE=='MS',]
fireMO <- cleanedFire[cleanedFire$STATE=='MO',]
fireMT <- cleanedFire[cleanedFire$STATE=='MT',]
fireNE <- cleanedFire[cleanedFire$STATE=='NE',]
fireNV <- cleanedFire[cleanedFire$STATE=='NV',]
fireNH <- cleanedFire[cleanedFire$STATE=='NH',]
fireNJ <- cleanedFire[cleanedFire$STATE=='NJ',]
fireNM <- cleanedFire[cleanedFire$STATE=='NM',]
fireNY <- cleanedFire[cleanedFire$STATE=='NY',]
fireNC <- cleanedFire[cleanedFire$STATE=='NC',]
fireND <- cleanedFire[cleanedFire$STATE=='ND',]
fireOH <- cleanedFire[cleanedFire$STATE=='OH',]
fireOK <- cleanedFire[cleanedFire$STATE=='OK',]
fireOR <- cleanedFire[cleanedFire$STATE=='OR',]
firePA <- cleanedFire[cleanedFire$STATE=='PA',]
fireRI <- cleanedFire[cleanedFire$STATE=='RI',]
fireSC <- cleanedFire[cleanedFire$STATE=='SC',]
fireSD <- cleanedFire[cleanedFire$STATE=='SD',]
fireTN <- cleanedFire[cleanedFire$STATE=='TN',]
fireTX <- cleanedFire[cleanedFire$STATE=='TX',]
fireUT <- cleanedFire[cleanedFire$STATE=='UT',]
fireVT <- cleanedFire[cleanedFire$STATE=='VT',]
fireVA <- cleanedFire[cleanedFire$STATE=='VA',]
fireWA <- cleanedFire[cleanedFire$STATE=='WA',]
fireWV <- cleanedFire[cleanedFire$STATE=='WV',]
fireWI <- cleanedFire[cleanedFire$STATE=='WI',]
fireWY <- cleanedFire[cleanedFire$STATE=='WY',]

fireCountAL <- fireAL %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountAK <- fireAK %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountAZ <- fireAZ %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountAR <- fireAR %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountCA <- fireCA %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountCO <- fireCO %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountCT <- fireCT %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountDE <- fireDE %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountFL <- fireFL %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountGA <- fireGA %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountHI <- fireHI %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountID <- fireID %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountIL <- fireIL %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountIN <- fireIN %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountIA <- fireIA %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountKS <- fireKS %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountKY <- fireKY %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountLA <- fireLA %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountME <- fireME %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountMD <- fireMD %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountMA <- fireMA %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountMI <- fireMI %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountMN <- fireMN %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountMS <- fireMS %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountMO <- fireMO %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountMT <- fireMT %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountNE <- fireNE %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountNV <- fireNV %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountNH <- fireNH %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountNJ <- fireNJ %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountNM <- fireNM %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountNY <- fireNY %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountNC <- fireNC %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountND <- fireND %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountOH <- fireOH %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountOK <- fireOK %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountOR <- fireOR %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountPA <- firePA %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountRI <- fireRI %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountSC <- fireSC %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountSD <- fireSD %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountTN <- fireTN %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountTX <- fireTX %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountUT <- fireUT %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountVT <- fireVT %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountVA <- fireVA %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountWA <- fireWA %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountWV <- fireWV %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountWI <- fireWI %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 
fireCountWY <- fireWY %>% group_by(FIRE_YEAR) %>% summarize(number_of_fires = n()) 

### code pertaining to dygraphs

causes_count_df = cleanedFire %>%
  count(STAT_CAUSE_DESCR)
states_count_df = cleanedFire%>%
  count(STATE)
owner_count_df = cleanedFire %>%
  count(OWNER_DESCR)
firesize_count_df = cleanedFire%>%
  count(FIRE_SIZE_CLASS)

causes_pie_df <- data.frame(
  count = causes_count_df$n,
  label = causes_count_df$STAT_CAUSE_DESCR
)
states_pie_df = data.frame(
  count = states_count_df$n,
  label = states_count_df$STATE
)
owner_pie_df = data.frame(
  count = owner_count_df$n,
  label = owner_count_df$OWNER_DESCR
)
firesize_pie_df = data.frame(
  count = firesize_count_df$n,
  label = firesize_count_df$FIRE_SIZE_CLASS
)

causes_pie_chart <- causes_pie_df %>%
  hchart(
    "pie", hcaes(x = label, y = count),
    name = "Fire Cause"
  )

#states_pie_chart

owner_pie_chart <- owner_pie_df %>%
  hchart(
    "pie", hcaes(x = label, y = count),
    name = "Owner Count"
  )
#owner_pie_chart

firesize_pie_chart <- firesize_pie_df %>%
  hchart(
    "pie", hcaes(x = label, y = count),
    name = "Owner Count"
  )

#firesize_pie_chart

#### SHINY

ui <- shinyUI(navbarPage(theme = shinytheme("united"), "Wildfires in the United States",
                         
                         tabPanel("Map Visualization",
                                  sidebarPanel(
                                    # Input: Selector for variable to plot ----
                                    selectInput("variable", "Variable:",
                                                c("Total Count" = "n",
                                                  "Wildfire Duration" = "DURATION_DAYS",
                                                  "Wildfire Size" = "FIRE_SIZE")), 
                                  ),
                                  # Main panel for displaying outputs ----
                                  mainPanel(
                                    # Output: Plot of the requested variable ----
                                    plotOutput("usFirePlot")
                                  )
                         ),
                         
                         tabPanel("Wildfires by Year",
                                  sidebarPanel(
                                    # Input: Selector for choosing dataset ----
                                    selectInput(inputId = "dataset",
                                                label = "Choose a State:",
                                                choices = c("Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", 
                                                            "Delaware" , "Florida" , "Georgia", "Hawaii", "Idaho", "Illinois", 
                                                            "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", 
                                                            "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska",
                                                            "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", 
                                                            "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
                                                            "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia",
                                                            "Wisconsin", "Wyoming")),
                                  ),
                                  mainPanel(
                                    # Output: Tabset w/ plot, summary, and table ----
                                    tabsetPanel(type = "tabs",
                                                tabPanel("Bar Plot", plotOutput("plot"))
                                    ),
                                    tableOutput("summary")
                                  )
                         ),
                         tabPanel("Pie Chart Visualization",
                                  sidebarPanel(
                                    # Input: Selector for variable to plot ----
                                    selectInput(inputId = "pie",
                                                label = "Choose a Pie Chart:",
                                                choices = c("Fire Cause", "Fire Size", "Owner of Land")),
                                  ),
                                  # Main panel for displaying outputs ----
                                
                                  mainPanel(
                                    # Output: Plot of the requested variable ----
                                    tabsetPanel(type = "tabs",
                                                tabPanel("Pie Chart", dygraphOutput("Pieplot"))
                                    )
                                  )
                         ),
                         
                         tabPanel("Modeling",
                                  sidebarPanel(
                                    # Input: Selector for variable to plot ----
                                    selectInput(inputId = "modeling",
                                                label = "Choose a Model:",
                                                choices = c("First Attempt: Regression", "Second Attempt: Classification", "Final Model")),
                                  ),
                                  # Main panel for displaying outputs ----
                                  mainPanel(
                                    # Output: Plot of the requested variable ----
                                    tabsetPanel(type = "tabs",
                                                tabPanel("Modeling", plotOutput("models"))
                                    )
                                  )
                         )
)
)



# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {
  
  # Make title for plot based on input variable ----
  name <- reactive({
    if (input$variable=="n") {
      paste("Total Number of Wildfires")
    } else if (input$variable=="DURATION_DAYS") {
      paste("Average Wildfire Duration")
    } else if (input$variable=="FIRE_SIZE") {
      paste("Average Size of Wildfires")
    }
  })
  
  # Make caption for plot based on input variable ----
  caption <- reactive({
    if (input$variable=="n") {
      paste("Number of Wildfires")
    } else if (input$variable=="DURATION_DAYS") {
      paste("Wildfire Duration (Days)")
    }  else if (input$variable=="FIRE_SIZE") {
      paste("Wildfire Size (Sq. Acres)")
    }
  })
  
  # Function to plot the requested variable ----
  plotFunc <- function() {
    plot_usmap(data = fires_state, values = input$variable, color = "gray", labels=TRUE) + 
      scale_fill_continuous(name = caption(), label = scales::comma, type = "viridis") + 
      labs(title = paste0(name()," by State between 1992 and 2015"), 
           caption = "Source: Forest Service Research Data Archive") +
      theme(plot.title = element_text(face="bold", size = 12, hjust = 0.5), plot.caption = element_text(size = 12, hjust=0), 
            legend.position = "right", legend.title=element_text(size=12), legend.text = element_text(size=11), 
            plot.margin = margin(.1,.1,.1,.1, "cm"), panel.background = element_rect(fill = "lightblue"))
  }
  
  
  # Generate a plot of the requested variable ----
  output$usFirePlot <- renderPlot({
    plotFunc()
  })
  
  # Return the requested dataset ----
  datasetInput <- reactive({
    switch(input$dataset,
           "Alabama" = fireCountAL,
           "Alaska" = fireCountAK,
           "Arizona" = fireCountAZ,
           "Arkansas" = fireCountAR,
           "California" = fireCountCA,
           "Colorado" = fireCountCO,
           "Connecticut" = fireCountCT,
           "Delaware" = fireCountDE,
           "Florida" = fireCountFL,
           "Georgia" = fireCountGA,
           "Hawaii" = fireCountHI,
           "Idaho" = fireCountID,
           "Illinois" = fireCountIL,
           "Indiana" = fireCountIN,
           "Iowa" = fireCountIA,
           "Kansas" = fireCountKS,
           "Louisiana" = fireCountLA,
           "Maine" = fireCountME,
           "Maryland" = fireCountMD,
           "Massachusetts" = fireCountMA,
           "Michigan" = fireCountMI,
           "Minnesota" = fireCountMN,
           "Mississippi" = fireCountMS,
           "Missouri" = fireCountMO,
           "Montana" = fireCountMT,
           "Nebraska" = fireCountNE,
           "New Hampshire" = fireCountNH,
           "New Jersey" = fireCountNJ,
           "New Mexico" = fireCountNM,
           "New York" = fireCountNY,
           "North Carolina" = fireCountNC,
           "North Dakota" = fireCountND,
           "Ohio" = fireCountOH,
           "Oklahoma" = fireCountOK,
           "Oregon" = fireCountOR,
           "Pennsylvania" = fireCountPA,
           "Rhode Island" = fireCountRI,
           "South Carolina" = fireCountSC,
           "South Dakota" = fireCountSD,
           "Tennessee" = fireCountTN,
           "Texas" = fireCountTX,
           "Utah" = fireCountUT,
           "Vermont" = fireCountVT,
           "Virginia" = fireCountVA,
           "Washington" = fireCountWA,
           "West Virginia" = fireCountWV,
           "Wisconsin" = fireCountWI,
           "Wyoming" = fireCountWY)
  })
  
  
  output$plot <- renderPlot({
    ggplot(data = datasetInput(), aes(x=FIRE_YEAR,y = number_of_fires )) +geom_bar(stat = 'identity', fill = 'red') +
      geom_smooth(method = 'lm', se = FALSE, size = 0.4, color = 'black') +
      labs(x = 'Fire Year', y = 'Number of wildfires', title = 'Wildfires by Year')
  })
  
  # Generate a summary of the data ----
  output$summary <- renderTable({
    summary(datasetInput())
  })
  
  # Return the requested dataset ----
  pieInput <- reactive({
    switch(input$pie,
           "Fire Cause" = states_pie_chart,
           "Fire Size" = firesize_pie_chart,
           "Owner of Land" = owner_pie_chart)
  })
  
  # Generate a plot of the requested variable ----
  output$Pieplot <- renderPlot({
    plotFunc()
  })
  
  
  
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
