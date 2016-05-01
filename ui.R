library(shiny)

#Code for app
shinyUI(fluidPage(
  titlePanel("Refugee Data Visualized: Movement over Time and Place"), 
  
  sidebarPanel(width = 4,
    selectInput(inputId = "country",
              label = "Choose an origin country.",
              origins), 
    sliderInput(inputId = "year", label = "Choose year(s) of migration.", min = min(years), max = max(years), value = c(min(years), max(years)), step = 1, sep=""),
    helpText("Data taken from the UNHCR Persons of Concern dataset. 
             See github.com/sarahwie/refugee_migration_trends", "for more info."),
    helpText("Produced by Sarah Wiegreffe for a Quantitative Methods course project with Professor Dan McGlinn at the College of Charleston, Spring 2016.")
  ),  
             
  mainPanel(
    #style="position:fixed; right:0;",
            tabsetPanel(
            tabPanel("Refugee Counts Map", label = "country", plotOutput("countryDat"), helpText("Countries shaded white indicate no data is available for them.")),
            tabPanel("Refugee Percentages Map", plotOutput("countryProp"), helpText("Countries shaded white indicate no data is available for them."), helpText("The legend indicates percentage of the total migrating population.")), 
            tabPanel("Migration Trends Over Time", plotOutput("countrySlope"), helpText("Only linear trends with an R-squared value greater than 0.5 are displayed."), helpText("We recommend using more recent data for this map, specifically 1995 and onward.")),
            id="outputs"
            )
  )
))