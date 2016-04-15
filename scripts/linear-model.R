library(reshape)

dat_sub = datCleaned[datCleaned$Origin == 'Rwanda', ]

#subset last 20 years of data-- past that it has been determined that it cannot be assumed that an NA really means 0.
#too high of a chance that this is true lack of data which would mess up the results of the linear model.
dat_sub = subset(dat_sub, dat_sub$Year >= 1995)

refugeesum = with(dat_sub, 
                  tapply(Refugees, INDEX=list(Country.of.asylum.or.residence, Year), sum, na.rm=T)) 

#Version 1: replace NAs with 0s
#refugeesum = ifelse(is.na(refugeesum), 0, refugeesum)
#Version 2: don't replace NAs with 0s, just remove them
#Version 3: impute

countries = rownames(refugeesum)

#format into proper dataframe
refugeesumDF = melt(refugeesum, id=c("1995","1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003",
                                   "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011",
                                   "2012", "2013", "2014"))
colnames(refugeesumDF) <- c("Country.of.asylum.or.residence", "Year","Refugees")

#create array to hold slopes
out = rep(NA, length(countries)-1)

#for each country of asylum
for (i in 2:length(countries)) {
  
  mod = lm(Refugees ~ Year, data=refugeesumDF, subset = Country.of.asylum.or.residence == countries[i], na.action = na.exclude)
  #plot(Refugees ~ Year, data=refugeesumDF, subset = Country.of.asylum.or.residence == countries[i])
  #abline(mod)
  
  #print(summary(mod)$r.squared)
  
  #if model performs well enough
  val = summary(mod)$r.squared
  if (!is.na(val) && val >= 0.5) {
      #get slope of line for that country
      beta = coef(mod)[2]
      #append it to storage array
      out[i-1] = beta
    }
}  
  