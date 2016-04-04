# refugee_migration_trends
Repository for final project for Quantitative Methods course at the College of Charleston.

This code generates an RShiny app that will display a heatmap of refugee migration patterns 
as well as a trendmap of migration from a user-selected country of origin to all possible destination countries. 
Data comes from the UNHCR for 1951 to 2014 (the most recent data available that is collected by them). 

The data folder contains the data exported from the site, found here: http://popstats.unhcr.org/en/persons_of_concern

The scripts folder currently contains 3 scripts:

app.R --> the code to generate the RShiny app (run last).
testingShapefiles.R --> exploratory code (not complete) to create the maps (run second).
cleanFunction.R --> code to clean the datafile (run first).
