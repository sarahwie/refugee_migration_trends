# refugee_migration_trends
Repository for final project for Quantitative Methods course at the College of Charleston.

The app developed by this code is located at http://uniola.biology.cofc.edu:3232/refugee_migration_trends/.

This code generates a local RShiny app that will display a heatmap of refugee migration patterns, 
specifically a trendmap of migration from a user-selected country of origin to all possible destination countries. 
Data comes from the UNHCR for 1951 to 2014 (the most recent data available that is collected by them). 

The scripts to run the app are server.R and ui.R. Run these two files in RStudio to create a local instance. The global environment is set in the global.R file.

The data folder contains the data exported from the site on March 14, 2016, found here: http://popstats.unhcr.org/en/persons_of_concern

The data folder also includes a mapping_countries.csv file which was used to reconcile the names of countries which are different from the names used in the sp R package. This is explained in more detail in the clean_data Markdown document.

The scripts folder currently contains 3 scripts:

cleanFunction.R --> Run this script first in order to load the data and preprocess it.

mapFunctions.R --> functions that are called by server.R in order to create the data structures needed for mapping.

cleanData.Rmd --> This is an R Markdown file which explains in more detail what the cleanFunction.R code does. It is the same code so you do not need to run it twice.

The packages which must be installed to run this code (and the versions used):

sp (Version 1.1-1)

maps (3.1.0)

maptools (0.8-39)

shiny (0.13.1)

reshape (0.8.5)
