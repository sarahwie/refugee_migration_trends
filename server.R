library(shiny)
library(maps)
library(sp)
library(maptools)
library(reshape)

source('./scripts/mapFunctions.R')

shinyServer(function(input,output){
  
  wrd_sp = map2SpatialPolygons(wrd, IDs=mapChoicesAll, CRS("+proj=longlat"))
  
  #counts map
  output$countryDat=renderPlot({
    
    #this code getting the subset has to be repeated inside each render function 
    #because of R Shiny's scope: in order for this to regenerate each time the user changes the input
    dat_sub = datCleaned[datCleaned$Origin == input$country & datCleaned$Year == input$year, ]
    #dat_sub = subset(dat_sub, dat_sub$Year >= input$year[1] & dat_sub$Year <= input$year[2])

    refugeesum = with(dat_sub, 
                        tapply(Refugees, Country.of.asylum.or.residence, sum, na.rm=T)) 
    validate(
      need(isTRUE(length(refugeesum)!=0), "No data available for this country and this time frame.")
    )
    
    #call function
    counts_by_country = getCountryCounts(refugeesum)

    spdf = SpatialPolygonsDataFrame(wrd_sp, counts_by_country)
    spplot(spdf, 'refugeesumOrdered')
  })
  
  #proportions map
  output$countryProp=renderPlot({
    
    dat_sub = datCleaned[datCleaned$Origin == input$country, ]
    dat_sub = subset(dat_sub, dat_sub$Year >= input$year[1] & dat_sub$Year <= input$year[2])
    
    refugeesum = with(dat_sub, 
                      tapply(Refugees, Country.of.asylum.or.residence, sum, na.rm=T)) 
    validate(
      need(isTRUE(length(refugeesum)!=0), "No data available for this country and this time frame.")
    )
    
    props_by_country = getCountryProps(refugeesum)
    
    spdf2 = SpatialPolygonsDataFrame(wrd_sp, props_by_country)
    #plot with percentage labels
    spplot(spdf2, 'proportion_total_refs',
           legendEntries = paste0("%", levels(spdf2$proportion_total_refs)))
    
  })

  #linear trendlines map
  output$countrySlope=renderPlot({
  
    dat_sub = datCleaned[datCleaned$Origin == input$country, ]
    dat_sub = subset(dat_sub, dat_sub$Year >= input$year[1] & dat_sub$Year <= input$year[2])
    
    #plot slopes
    refugeesum = with(dat_sub, 
                      tapply(Refugees, INDEX=list(Country.of.asylum.or.residence, Year), sum, na.rm=T))
    
    validate(
      need(isTRUE(input$year[1] != input$year[2]), "Please select a range of years.")
    )
    
    refugeesumDF = getCountryTrends(refugeesum,input$year[1])
    
    countries = rownames(refugeesum)
    
    #create array to hold slopes
    out = rep(NA, length(countries))
    
    #for each country of asylum
    for (i in 1:length(countries)) {
      
      #build a linear model
      mod = lm(Refugees ~ Year, data=refugeesumDF, subset = Country.of.asylum.or.residence == countries[i], na.action = na.exclude)
      
      #if model performs well enough
      val = summary(mod)$r.squared
      if (!is.na(val) && val >= 0.5) {
        #get slope of line for that country
        beta = coef(mod)[2]
        #append it to storage array
        out[i-1] = beta
      }
    }  
    
    names(out) = countries
    
    refugeesumOrdered = order(out)
    trends_by_country = data.frame(mapChoices, refugeesumOrdered)
    rownames(trends_by_country) = mapChoices
    
    spdf3 = SpatialPolygonsDataFrame(wrd_sp, trends_by_country)
    spplot(spdf3, 'refugeesumOrdered')
    
  })
  
  
})