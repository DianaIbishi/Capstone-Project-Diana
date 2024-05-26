
# The multiple linear regression I can perform with the average_yearly_interaction as the 
# dependent variable and the counts of different sub-event types as independent variables. 
# I can analyze how the counts of various sub-event types collectively contribute 
# to the average yearly interaction.


install.packages("car")

library(dplyr)
library(tidyr)
library(lmtest)  # for diagnostic tests
library(car)     # for VIF calculation


# Rename 'n' column to avoid conflicts with function names

merged_df_kosovo <- merged_df_kosovo %>%
  rename(protest_counts = n)

# Fit multiple linear regression model
# average_yearly_interaction as a dependent variable.

model <- lm(average_yearly_interaction ~ ., data = merged_df_kosovo)

# Summary of the model

summary(model)

# Extract the coefficients

summary(model)$coefficient

# Two coefficients are very significant: 1. Peaceful protest (2.4855) and 2. Attack (1.1972)

# So here I could interpret that the more protests happen in Kosovo which are either 
# peaceful or attacks the more this influences the average interaction of protest per year.
# But of course is this the case, as the more protests there are the more interaction we have.


# Now I want to test how much the error rate of the model is:

sigma(model)/mean(merged_df_kosovo$average_yearly_interaction)

# The result is: 0.03268 -> The error rate of this model is quite low: 3.268 % - great 


# Diagnostic tests

# For example, I can check multicollinearity using VIF

vif(model)

# year : GVIF of 1.08 which is very low and doesn't show any multicollinearity
# sub_event_type : GVIF of 1.12 which is very low and doesn't show any multicollinearity
# protest_counts : GVIF of 4.71 which is a moderate level of multicollinearity

# protest_counts needs a further investigation because it is not above >5 but there could
# be a multicollinearity between the variable protest_counts and the interactions






