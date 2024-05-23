
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
# had Pristine. I think this is clear, as it is the capital city of Kosovo. 


# Now I want to see how the interactions evolved with the years in the country

summary_yearly_interactions <- kosovo_cleaned_data %>%
  group_by(year) %>%
  summarise(average_yearly_interaction = mean(interaction, na.rm = TRUE))

View(summary_yearly_interactions)


# Let's visualize this

library(ggplot2)

ggplot(data = summary_yearly_interactions, aes(x = year, y = average_yearly_interaction)) +
  geom_line(color = "red", size = 1.5) + 
  geom_point(color = "darkgreen", size = 4) +
  labs(title = "Average Interactions per year",
       x = "Year",
       y = "Average Interaction") +
  theme_minimal()


# We see the interactions over the five years and in 2020 the most protests took place in
# Kosovo. My first argument is that the protests are definitely not decreasing. 


# Now I want to analyze how many words in the variable sub_event_type are mentioned and
# which one

word_counts <- kosovo_cleaned_data %>%
  count(sub_event_type, sort = TRUE)
  
# View the word counts

print(word_counts) #The most mentioned word is "peaceful protest" over the five years
                   #The most second mentioned word is "Attack" over the five years


# I want now to filter the counted words by year

filtered_data <- kosovo_cleaned_data %>%
  filter(year >= 2018 & year <= 2023)

word_counts_by_year <- filtered_data %>%
  group_by(year, sub_event_type) %>%
  count(sort = FALSE)

# View the result

print(word_counts_by_year)


# Now I have two important data frames:

# word_counts_by_year & summary_yearly_interactions

# I want to analyze if there is a relationship between the frequency of sub-event types
# and the average yearly interaction of protests.












# I see that there are still many 



Regression analysis will help you understand the relationship between the average 
interaction in cities and the frequency of different sub-event types. Here’s how you can 
approach it in R:











