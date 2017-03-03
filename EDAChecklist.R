library(readr)
library(dplyr)

######################################
# 1: Read in the Data
######################################
cat("Reading in EPA Ozone data...")
zipFile <- tempfile()
download.file("http://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/hourly_44201_2016.zip",zipFile)
ozone <- read_csv(unz(zipFile,"hourly_44201_2016.csv"))
unlink(zipFile)
names(ozone) <- make.names(names(ozone))

#######################################
# 2: Check the Metadata
#######################################
cat("Check number rows, number columns, data fields, data types:")
str(ozone)

#######################################
# 3: Look at Top and Bottom of Data
#######################################
cat("Check top and bottom of data for formatting issues/garbage rows:")
head(ozone)
tail(ozone)

#######################################
# 4: Check "n"s against Landmarks
#######################################
cat("Check that all hours are represented:")
head(table(ozone$Time.Local))
cat("Check that all states are represented:")
select(ozone,State.Name) %>% unique %>% nrow
cat("Why are there 52 states? Inspect unique elements of State.Name:")
unique(ozone$State.Name)
cat("Puerto Rico and Washington DC are valid U.S. locations.")

######################################
# 5: Validate with External Data
######################################
cat("Compare data against EPA's 2015 acceptable max concentration: 0.070 ppm")
quantile(ozone$Sample.Measurement, seq(0,1,0.1))
cat("Look at outliers:")
filter(ozone,Sample.Measurement < 0) %>% select(State.Code,County.Code,Date.Local,Time.Local,Sample.Measurement)
filter(ozone,Sample.Measurement > 0.070) %>% select(State.Code,County.Code,Date.Local,Time.Local,Sample.Measurement)
cat("Data is correct order of magnitude; distribution range makes sense; ")
