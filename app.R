library(shiny)

datAll=read.csv('Downloads/unhcr_popstats_export_persons_of_concern_all_data.csv', header = TRUE)
#colnames(dat)
wrd = map('world', fill=T)

#we need this to be unique only!
#choices = attributes(unique(datAll$Origin))$levels
choices = as.character(unique(datAll$Origin[]))
length(unique(sapply(strsplit(wrd$names, ':', fixed=T), function(x) x[[1]])))
# 253 unique countries in this set-- compare to dataset read in

length(unique(datAll$Country.of.asylum.or.residence))
# 195 unique countries of residence or asylum
length(unique(datAll$Origin))
# 220 unique countries of origin

#world = map(database="world")

#must create data frame to display here
#choices = world[4]
ui=fluidPage("Refugee Count Prediction App", selectInput(inputId = "country",
                                        label = "Choose a destination country",
                                        choices),
             plotOutput("countryDat"))
server=function(input,output){
  output$countryDat=renderPlot(map(database="world"))
  
}
shinyApp(ui=ui, server=server)