
# As my first version of the capstone project did not work (I think because of the format), I
# am going to try something else. 

# I really like the theme about political unrest, so protests and events, that's why I keep
# going with the protests in Kosovo. 

# Another research question came up to my mind:

# How have the frequency and intensity of violent protests in Kosovo evolved from 2018 to 2023?




# Set up Working directory

setwd("C:/Users/diana/Documents/Uni_Luzern/Master Computational Social Science/2. Semester/Data Mining with R/Capstone-Project-Diana/Version 2 CP")

# Load packaged

library(rvest)
library(tidyverse)
library(httr)
library(jsonlite)

# First I extract the API Key and hide it.

api_key_data <- read.csv("api_key.csv", header = FALSE)

# V1 is the default name for the first column if there is no header row

api_key <- api_key_data$V1[1]

# Define the URL

url <- "https://api.acleddata.com/acled/read"

# The GET request

install.packages("acled.api")

library(acled.api)


# Make the API request

response <- acled.api(
  email.address = "diana.ibishi@stud.unilu.ch",
  access.key = api_key,
  country = "Kosovo",
  start.date = "2000-01-01",
  end.date = "2023-12-31")


# Print the result

print(response)

# Name the response data differentely

df_kosovo <- response








