library(shiny)
library(maps)

#Code for app
ui=fluidPage("Refugee Count Prediction App", selectInput(inputId = "country",
                                        label = "Choose an origin country",
                                        origins), selectInput(inputId = "year", label = "Choose year", years),
             plotOutput("countryDat"))
server=function(input,output){
  output$countryDat=renderPlot({
    
    map('world', fill=T)
    #input$country will be the country of origin. must incorporate into this output section.
  })}
shinyApp(ui=ui, server=server)