
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


# Clean the data for missing values

# Check for missing values in the entire dataframe

any_na <- any(is.na(df_kosovo))
any_na # There is no missing value - great


# I remove the columns which I do not need

library(dplyr)

kosovo_cleaned_data <- select(df_kosovo, -event_id_cnty, -source, -admin3, -latitude,
                              -longitude, -fatalities, -tags, -timestamp, -location,
                              -admin2)

View(kosovo_cleaned_data)


# I rename the column admin1 which indicated the city

kosovo_cleaned_data <- kosovo_cleaned_data %>%
  rename(city = admin1)


# Check the average of interactions in the data set

summary_interactions <- kosovo_cleaned_data %>%
  group_by(city) %>%
  summarise(average_interaction = mean(interaction, na.rm = TRUE))
  
View(summary_interactions)

# Order the average interactions per city 

ordered_interactions <- summary_interactions[order(-summary_interactions$average_interaction), ]

# Print the ordered dataframe

print(ordered_interactions)

# From 2018 until 2023 we see that the most interactions, so the different types of events
# hat Pristina. I think this is cleas, as it is the capital city of Kosovo. 


# Now I want to see how the interactions evolved with the years in the country

summary_yearly_interactions <- kosovo_cleaned_data %>%
  group_by(year) %>%
  summarise(average_yearly_interaction = mean(interaction, na.rm = TRUE))

View(summary_yearly_interactions)


# Let's visualize this

# Assuming you have the 'summary_yearly_interactions' dataframe

hist(summary_yearly_interactions$year,
     main = "Average Yearly Interactions",
     xlab = "Years",
     ylab = "Average Interaction",
     col = "skyblue",
     border = "darkblue")













