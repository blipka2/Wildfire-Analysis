library(shiny)
library(ggplot2)
library(dplyr)

# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Wildfires in the United States"),
  
  # Sidebar layout with a input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Selector for choosing dataset ----
      selectInput(inputId = "dataset",
                  label = "Choose a State:",
                  choices = c("California", "Illinois", "Georgia", "Arizona", "New York")),
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Bar Plot", plotOutput("plot")),
                  tabPanel("Summary", verbatimTextOutput("summary"))
      )
      
    )
  )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {
  
  # Return the requested dataset ----
  datasetInput <- reactive({
    switch(input$dataset,
           "California" = fireCountCA,
           "Illinois" = fireCountIL,
           "Georgia" = fireCountGA,
           "Arizona" = fireCountAZ,
           "New York" = fireCountNY)
  })
  

  output$plot <- renderPlot({
    ggplot(data = datasetInput(), aes(x=FIRE_YEAR,y = number_of_fires )) +geom_bar(stat = 'identity', fill = 'red') +
      geom_smooth(method = 'lm', se = FALSE, size = 0.4, color = 'black') + 
      labs(x = 'Fire Year', y = 'Number of wildfires', title = 'Wildfires by Year')
    })
  
  # Generate a summary of the data ----
  output$summary <- renderPrint({
    summary(datasetInput())
  })
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
