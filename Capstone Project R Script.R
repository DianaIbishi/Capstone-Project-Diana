# The aim of this capstone project is to compare extreme weather differences in the region of
# Kosovo with the number of protests. 

# I want to explain what I am going to analyze in this paper.

# As explained in the last few paragraphs climate change has a strong impact on Kosovo and 
# the government does not really care about the environmental rules (as it did not sign neither
# the UN Framework Convention on Climate Change (UNFCCC) nor the Kyoto Protocol) or permits. 
# So, I was wondering why in Kosovo no protest climate change take place. As for example 
# climate change has a big impact on the citizens personal life.

# For this project I follow a Hypothesis:

# "Regions experiencing climatic stress are more likely to not protest the government."

# To compare this I will use an API which describes 80 years of weather history data.

# For the number of protests I am going to use the ACLED | Armed Conflict Location & 
# Events Data set. 

# In the end, I will test if my hypothesis is significant and if there is a correlation 
# between the climatic stress (weather data) and the protests.




# Set Working directory and check it with getwd()

setwd("C:/Users/diana/Documents/Uni_Luzern/Master Computational Social Science/2. Semester/Data Mining with R/Capstone-Project-Diana")

getwd()

# precipitation (rain and snow)

# snow (winters with little snow), true from 2012 not more than 0.11 m of snow in winter

# temperature (hotter summers), cannot be really confirmed, very stable over the years

# humidity, true from 2012, couldn't get lower than 40%, always very high: reached 83%
# but cannot be confirmed

# rain, can be confirmed as from 2010 the rainfall increased very much





# Load packages

library(tidyverse)
library(httr2)
library(httr)
library(jsonlite)
library(rvest)
library(base64enc)

# Get API request

# First step: Install the API key

url: "https://cds.climate.copernicus.eu/api/v2"
key: {uid}:{api-key}

# Define Authentication

uid <- "312044"
api_key <- "37e90536-c2cf-4059-adf5-eb65128a373d"
base_url <- "https://cds.climate.copernicus.eu/api/v2"



# Get request: Problematic, due to the python language in CDS

api_key_string <- paste0(uid, ":", api_key)


# Authentication header

auth_header <- add_headers(Authorization = paste("Basic", base64_enc(api_key_string)))


# Define the body

body <- list(
  product_type = "reanalysis",
  variable = c(
    "2m_dewpoint_temperature", "precipitation_type", "total_precipitation",
    "type_of_high_vegetation", "type_of_low_vegetation"
  ),
  year = as.character(2000:2023),
  month = as.character(sprintf("%02d", 1:12)),
  day = as.character(sprintf("%02d", 1:31)),
  time = sprintf("%02d:00", 0:23),
  format = "grib"
)

# Make the request

make_request <- function(body) {
  response <- POST(
    url = paste0(base_url, "/resources/reanalysis-era5-single-levels"),
    auth_header,
    body = toJSON(body),
    encode = "json",
    content_type("application/json")
  )

  if (status_code(response) == 200) {
    # Parse the response
    result <- fromJSON(content(response, "text", encoding = "UTF-8"))
    
    # Get the download URL
    download_url <- result$request_id  # This may need to be adjusted based on the actual response structure
    
    # Download the file
    download.file(download_url, destfile = "download.grib", mode = "wb")
    cat("Download completed successfully.\n")
  } else {
    stop("Error: ", status_code(response), " - ", content(response, "text"))
  }
}


# Make the request every 2 seconds

for (i in 1:length(body$year)) {
  make_request(body)
  Sys.sleep(2)
}



# Function to check the status of a request and download when ready

check_status_and_download <- function(request_id) {
  repeat {
    response <- GET(
      url = paste0(base_url, "/tasks/", request_id),
      auth_header
    )
    
    if (status_code(response) == 200) {
      result <- fromJSON(content(response, "text", encoding = "UTF-8"))
      if (result$state == "completed") {
        download_url <- result$result$url
        download.file(download_url, destfile = paste0("download_", request_id, ".grib"), mode = "wb")
        cat("Download completed successfully.\n")
        break
      } else if (result$state %in% c("queued", "running")) {
        cat("Request is still processing. Waiting for 10 seconds...\n")
        Sys.sleep(10)
      } else {
        stop("Request failed with state: ", result$state)
      }
    } else {
      stop("Error: ", status_code(response), " - ", content(response, "text"))
    }
  }
}


# Loop it to make the requests every 2 seconds

for (i in 1:length(body$year)) {
  request_id <- make_request(body)
  Sys.sleep(2)
  check_status_and_download(request_id)
}

# It did not work to make the request.

# Let's try something else:

request_body <- list(
  product_type = "reanalysis",
  variable = c(
    "2m_dewpoint_temperature", "precipitation_type", "total_precipitation",
    "type_of_high_vegetation", "type_of_low_vegetation"
  ),
  year = "2000",
  month = c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"),
  day = c(
    "01", "02", "03", "04", "05", "06", "07", "08", "09",
    "10", "11", "12", "13", "14", "15", "16", "17", "18", "19",
    "20", "21", "22", "23", "24", "25", "26", "27", "28", "29",
    "30", "31"
  ),
  time = c(
    "00:00", "01:00", "02:00", "03:00", "04:00", "05:00",
    "06:00", "07:00", "08:00", "09:00", "10:00", "11:00",
    "12:00", "13:00", "14:00", "15:00", "16:00", "17:00",
    "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"
  ),
  format = "grib"
)

# Make the request

response <- POST(
  url = "https://cds.climate.copernicus.eu/api/v2/resources/reanalysis-era5-single-levels",
  body = request_body,
  encode = "json",
  authenticate("312044", "37e90536-c2cf-4059-adf5-eb65128a373d", type = "basic")
)

# Check response status

if (status_code(response) == 200) {
  # Save the downloaded file
  content <- content(response, "raw")
  writeBin(content, "download.grib")
  cat("Download completed successfully.\n")
} else {
  cat("Error:", status_code(response), "\n")
  cat(content(response, "text"), "\n")
}

# It seemed that it worked

