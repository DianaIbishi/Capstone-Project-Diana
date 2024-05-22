
# You can also call the ACLED API directly. In order to retrieve data from the API, you must make a GET or POST request to the following URL: 
  
# https://api.acleddata.com/acled/read/?key=****************1234&email=you@youremail.com


# As my first version of the capestone project did not work (I think because of the format), I
# am going to try something else. 

# I really like the theme about political unrest, so protests and events, that's why I keep
# going with the protests in Kosvo. 

# Another research question came up to my mind:

# How have the frequency and intensity of protests in Kosovo evolved from 2000 to 2024?

# I want ot test if there are less protests than in 2000. The war with serbia was actutally in
# 1999 over. However I am interested in checking if the protests have increased or decreased?



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

response <- GET(url, query = list("api-key" = api_key, 
                                  country = "Kosovo",
                                  region = "Europe",
                                  start.date = "2000-01-01",
                                  end.date = "2023-31-12",
                                  event.type =  "protests",
                                  actor.type = "protesters"
                                  ))






