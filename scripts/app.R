library(shiny)
library(maps)
library(sp)
library(maptools)

#source('./scripts/clean_data.R')
#datCleaned = read.csv('./data/datCleaned.csv')

#save(datCleaned, file='./data/datCleaned.Rdata')
#load('./data/datCleaned.Rdata')
#get unique origins, destinations, and years for inputs in app
origins = unique(datCleaned$Origin[])
destinations = unique(datCleaned$Country.of.asylum.or.residence[])
years = unique(datCleaned$Year[])

#start mapping
mapChoicesAll = sapply(strsplit(wrd$names, ':', fixed=T), function(x) x[[1]])
# counts_by_country_proj = proj4string(counts_by_country)***
wrd_sp = map2SpatialPolygons(wrd, IDs=mapChoicesAll, CRS("+proj=longlat"))

#Code for app
ui = fluidPage(
  "Refugee Count Prediction App", selectInput(inputId = "country",
                                              label = "Choose an origin country",
                                              origins), 
  selectInput(inputId = "year", label = "Choose year", c('all', years)),
  plotOutput("countryDat"))

server=function(input,output){
  output$countryDat=renderPlot({
    
    if(input$year == 'all') {
      dat_sub = datCleaned[datCleaned$Origin == input$country, ]
      refugeesum = with(dat_sub, 
                        tapply(Refugees, Country.of.asylum.or.residence, sum, na.rm=T))
    }
    else {
      dat_sub = datCleaned[datCleaned$Origin == input$country & datCleaned$Year == input$year, ]
      refugeesum = with(dat_sub, 
                        tapply(Refugees, Country.of.asylum.or.residence, sum, na.rm=T)) 
    }
    #where country is blank (what used to be "Various/Unknown"), set count to NA
    refugeesum = c(refugeesum, NA)
    #get total of all refugees (note: includes various/unknown***)
    totalRefs = sum(refugeesum, na.rm = T)
    #vector of positions in refugeesum where names match mapChoices- must be in same order
    row_indices = match(mapChoices, names(refugeesum))
    #replace NA values with index of last element of refugeesum vector which is NA
    row_indices = ifelse(is.na(row_indices), length(refugeesum), row_indices)
    #order 
    refugeesumOrdered = refugeesum[row_indices]
    #refugeesumOrdered = ifelse(is.na(refugeesumOrdered), 0, refugeesumOrdered)
    counts_by_country = data.frame(mapChoices, refugeesumOrdered)
    props_by_country = data.frame(mapChoices, refugeesumOrdered/totalRefs*100)
    colnames(props_by_country)[2] = 'proportion_total_refs'
    rownames(counts_by_country) = mapChoices
    rownames(props_by_country) = mapChoices
    spdf = SpatialPolygonsDataFrame(wrd_sp, counts_by_country)
    spdf2 = SpatialPolygonsDataFrame(wrd_sp, props_by_country)
    spplot(spdf, 'refugeesumOrdered')
    spplot(spdf2, 'proportion_total_refs')
    
    #plot slopes
    
  })
  
  
  }
shinyApp(ui=ui, server=server)