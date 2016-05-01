library(maps)

#import data from UNHCR
datAll=read.csv('./data/unhcr_popstats_export_persons_of_concern_all_data.csv', header = TRUE)

#basic map
wrd = map('world', fill=T)

#get name differences between unique countries of destination from datafile vs. map.
#we don't care about origin countries matching the map because they will not be displayed on it.

#remove ':'s from map names for the purpose of matching to dataset
mapChoices = unique(sapply(strsplit(wrd$names, ':', fixed=T), function(x) x[[1]]))

#get differences
setdiff(unique(datAll$Country.of.asylum.or.residence[]), mapChoices)

#look up missing values from the final mapChoices list with this command
#subset(wrd$names, grepl(paste('China', collapse= "|"), wrd$names))
#map by hand in a csv file

#function definition
cleanData = function(df) {
  
  df_clean = df[, c("Year", "Country.of.asylum.or.residence", "Origin", "Refugees")]
  
  #Convert datatypes of columns away from factors
  df_clean$Country.of.asylum.or.residence = as.character(df_clean$Country.of.asylum.or.residence)
  df_clean$Origin = as.character(df_clean$Origin)
  df_clean$Refugees = as.numeric(levels(df_clean$Refugees))[df_clean$Refugees]
  
  #fix mapping issues by changing some asylum country names in dataset to match 
  #those in map package's vocabulary.
  #import csv with mappings done by hand.
  nameUpdates = read.csv('./data/mapping_countries.csv', header = TRUE,
                         stringsAsFactors = FALSE)[,1:2]
  #str(nameUpdates)
  
  for (i in 1:dim(nameUpdates)[1]){
    df_clean$Country.of.asylum.or.residence[grepl(nameUpdates[i,1], 
                                                df_clean$Country.of.asylum.or.residence, fixed = TRUE)] = nameUpdates[i,2]
  }
  
  return(df_clean)
}

#call function
datCleaned = cleanData(datAll)

#Check that conversion process worked- should be none (old name)
datCleaned[datCleaned$Country.of.asylum.or.residence == 'United Rep. of Tanzania',]
#should be some rows now (new name)
datCleaned[datCleaned$Country.of.asylum.or.residence == 'Tanzania',]

#check that differences are reconciled- should return nothing except for any names containing ":"
setdiff(unique(datCleaned$Country.of.asylum.or.residence[]), mapChoices)

#check datatypes of columns
str(datCleaned)

#get unique origins, destinations, and years for inputs in app
origins = unique(datCleaned$Origin[])
destinations = unique(datCleaned$Country.of.asylum.or.residence[])
years = unique(datCleaned$Year[])

#start mapping
mapChoicesAll = sapply(strsplit(wrd$names, ':', fixed=T), function(x) x[[1]])