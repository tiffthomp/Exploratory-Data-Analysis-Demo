library(readr) # Add these packages to packrat?
library(dplyr)

cat("This script demonstrates the Exploratory Data Analysis Checklist, as described in
Peng and Matsui's 'The Art of Data Science.'

I will be working with hourly ozone data from 2016, published by the EPA.\n")

######################################
# 1: Read in the Data
######################################
cat("Step 1: Read in the Data

Fetching the data from the EPA website...\n")
zipFile <- tempfile()
download.file("http://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/hourly_44201_2016.zip",zipFile)
cat("Reading in the data...\n")
ozone <- read_csv(unz(zipFile,"hourly_44201_2016.csv"))
unlink(zipFile)
names(ozone) <- make.names(names(ozone))
cat("Data set read in successfully.\n")

#######################################
# 2: Check the Metadata
#######################################
cat("Step 2: Check the Metadata (aka Check Your n's)\n")
str(ozone)
cat("Confirm that the number of rows, the number of columns, and the data fields + data types
are what you expected.\n")

#######################################
# 3: Look at Top and Bottom of Data
#######################################
cat("Step 3: Look at the Top and Bottom of the Data Set\n")
head(ozone)
tail(ozone)
cat("Check the data above for formatting issues or garbage rows.\n")

#######################################
# 4: Check n's against Landmarks
#######################################
cat("Step 4: Check 'n's against Landmarks\n")
head(table(ozone$Time.Local))
cat("Check that all hours are represented above.")
select(ozone,State.Name) %>% unique %>% nrow
cat("Check that all states are represented.\n
Why are there 52 states? Inspect unique elements of State.Name:")
unique(ozone$State.Name)
cat("Puerto Rico and Washington DC are valid U.S. locations.
So far, this data is valid.\n")

######################################
# 5: Validate with External Data
######################################
cat("Step 5: Validate with External Data\n")
quantile(ozone$Sample.Measurement, seq(0,1,0.1))
cat("Compare data above against EPA's 2015 acceptable max average concentration: 0.070 ppm\n")
cat("Look at outliers:")
filter(ozone,Sample.Measurement < 0) %>% select(State.Code,County.Code,Date.Local,Time.Local,Sample.Measurement)
filter(ozone,Sample.Measurement > 0.070) %>% select(State.Code,County.Code,Date.Local,Time.Local,Sample.Measurement)
cat("Data is correct order of magnitude; distribution range makes sense; ")
