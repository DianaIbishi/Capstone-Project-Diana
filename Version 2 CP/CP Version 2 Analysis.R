
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

# So here I can interpret that the more protests happen in Kosovo which are either 
# peaceful or attacks the more this influences the average interaction of protest per year.

# Now I want to test how much the error rate of the model is:

sigma(model)/mean(merged_df_kosovo$average_yearly_interaction)

# The result is: 0.03268 -> The error rate of this model is quite low: 3.268 % - great 






# Diagnostic tests
# For example, you can check multicollinearity using VIF
vif(model)

# You can also perform other diagnostic tests like heteroscedasticity, normality of residuals, etc.
# For example, Breusch-Pagan test for heteroscedasticity
bptest(model)














