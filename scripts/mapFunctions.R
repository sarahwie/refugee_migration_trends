library(maptools)
library(maps)

#function definition
getCountryCounts = function(refugeesum) {
  
  wrd = map('world', fill=T)
  mapChoices = unique(sapply(strsplit(wrd$names, ':', fixed=T), function(x) x[[1]]))
  
  #where country is blank (what used to be "Various/Unknown"), set count to NA
  refugeesum = c(refugeesum, NA)
  
  refugeesumOrdered = order(refugeesum)
  counts = data.frame(mapChoices, refugeesumOrdered)
  rownames(counts) = mapChoices

  return(counts)
}

getCountryProps = function(refugeesum) {
  
  wrd = map('world', fill=T)
  mapChoices = unique(sapply(strsplit(wrd$names, ':', fixed=T), function(x) x[[1]]))
  
  #where country is blank (what used to be "Various/Unknown"), set count to NA
  refugeesum = c(refugeesum, NA)
  
  #get total of all refugees (note: includes various/unknown***)
  totalRefs = sum(refugeesum, na.rm = T)
  
  refugeesumOrdered = order(refugeesum)
  props = data.frame(mapChoices, refugeesumOrdered/totalRefs*100)
  colnames(props)[2] = 'proportion_total_refs'
  rownames(props) = mapChoices
  
  return(props)
}

getCountryTrends = function(refugeesum, inputYr) {
  
  wrd = map('world', fill=T)
  mapChoices = unique(sapply(strsplit(wrd$names, ':', fixed=T), function(x) x[[1]]))
  
  if (inputYr >= 1995) {
    #replace NAs with 0s
    refugeesum = ifelse(is.na(refugeesum), 0, refugeesum)
  }
  #else don't replace them
  
  #format into proper dataframe
  refugeesumDF = melt(refugeesum)
  colnames(refugeesumDF) <- c("Country.of.asylum.or.residence", "Year","Refugees")
  
  return(refugeesumDF)
}

order = function(array1) {
  
  #reposition vectors
  #vector of positions in refugeesum where names match mapChoices- must be in same order
  row_indices = match(mapChoices, names(array1))
  #replace NA values with index of last element of refugeesum vector which is NA
  row_indices = ifelse(is.na(row_indices), length(array1), row_indices)
  #order 
  ordered = array1[row_indices]
  return(ordered)
  
}

