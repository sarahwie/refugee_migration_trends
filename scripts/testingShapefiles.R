#Testing shapefiles deal
library(maps) 
library(sp)
library(maptools)
library(rgdal)
library(lattice)
library(classInt)

#get unique origins, destinations, and years for inputs in app
origins = unique(datCleaned$Origin[])
destinations = unique(datCleaned$Country.of.asylum.or.residence[])
years = unique(datCleaned$Year[])

#start mapping
mapChoicesAll = sapply(strsplit(wrd$names, ':', fixed=T), function(x) x[[1]])
# counts_by_country_proj = proj4string(counts_by_country)***
wrd_sp = map2SpatialPolygons(wrd, IDs=mapChoicesAll, CRS("+proj=longlat"))
plot(wrd_sp, axes=T)

#what? Dan did this***
#wrd_sp@data = data.frame()

# add data to make spatial polygons data frame
# this needs to be a count of all refugees arriving in a given country, combined on country names
refugeesum = with(datCleaned, 
                  tapply(Refugees, Country.of.asylum.or.residence, sum, na.rm=T))
#where country is blank (what used to be "Various/Unknown"), set count to NA
refugeesum = c(refugeesum, NA)
  
#vector of positions in refugeesum where names match mapChoices- must be in same order
row_indices = match(mapChoices, names(refugeesum))
#replace NA values with index of last element of refugeesum vector which is NA
row_indices = ifelse(is.na(row_indices), length(refugeesum), row_indices)
#order 

  

wrd_sp@data = data.frame(refugeesum[row_indices])

counts_by_country = data.frame(shortCountryNames, refugeeCounts)
rownames(counts_by_country) = wrd$names
counts_by_country

spdf = SpatialPolygonsDataFrame(sp, counts_by_country)
#column to shade on
spplot(spdf, 'refugees')

#Different method
read.shape = function(shape_name, path=NULL) {
  require(rgdal)
  if (is.null(path)) {
    path = getwd()
  }
  fileName = paste(shape_name, '.shp', sep='')    
  shp = readOGR(file.path(path, fileName), shape_name)
}  

fire2010 = read.shape("modis_fire_2010_365_conus", path="./data/MODISfire2010")

#Spatial polygons vs. spatial points dataframe


#Rasters
library(raster)
load('./data/bioclim_10m.Rdata')
plot(bioStack, "mat")

