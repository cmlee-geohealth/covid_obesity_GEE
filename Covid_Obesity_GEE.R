# set the working directory
wd = 'C:/Users/tuo03314/OneDrive - Temple University/3 Fall 2024/EPBI 8204/Final_Project/Data Processing'
setwd(wd)

# load libraries
library(lme4)
library(performance)
library(ggplot2)
library(geepack)

# turn off scientific notation
# options(scipen = 999)

# load the data
cdc_places_data = read.csv('../Data/CDC Places/cdc_places_data.csv')

# From the Study Proposal

# dimension of the data
dim(cdc_places_data)

# summary information of the data
desc_obese <- summary(cdc_places_data$obese, na.rm = TRUE)
desc_obese
# standard deviation
sd_obese <- sd(cdc_places_data$obese, na.rm = TRUE)
sd_obese

### description of the data’s structure and justification (e.g., using ICC and/or data visualizations) why multilevel modeling is suitable.

head(cdc_places_data, 3)

# empty model
null_model =  lmer(obese ~ 1 + (1|tract), data=cdc_places_data)
summary(null_model)

# calculate ICC
icc <- performance::icc(null_model)
icc

# Data cleaning

# Unique number of census tracts
length(unique(cdc_places_data$tract)) 

# Count the number of years for each tract
tract_year_counts <- aggregate(year ~ tract, 
                               data = cdc_places_data, 
                               FUN = function(x) length(unique(x)))

# Count the number of each census tract
year_counts_summary <- table(tract_year_counts$year)

# Display the summary
year_counts_summary


# Count the number of records for each tract
tract_counts <- table(cdc_places_data$tract)

# Filter tracts with exactly 5 years of records
tracts_with_five_years <- names(tract_counts[tract_counts == 5])

# Subset the data to include only these tracts
cdc_places_data <- cdc_places_data[cdc_places_data$tract %in% tracts_with_five_years, ]


# Descriptive staitstics --------------------------------------------------

# The descriptive statistics of each variable
range_lpa <- range(cdc_places_data$lpa, na.rm = TRUE)
mean_lpa <- mean(cdc_places_data$lpa, na.rm = TRUE)
median_lpa <- median(cdc_places_data$lpa, na.rm = TRUE)

range_mhlth <- range(cdc_places_data$mhlth, na.rm = TRUE)
mean_mhlth <- mean(cdc_places_data$mhlth, na.rm = TRUE)
median_mhlth <- median(cdc_places_data$mhlth, na.rm = TRUE)

range_obese <- range(cdc_places_data$obese, na.rm = TRUE)
mean_obese <- mean(cdc_places_data$obese, na.rm = TRUE)
median_obese <- median(cdc_places_data$obese, na.rm = TRUE)

## Trends over time

# Factor variables
cdc_places_data$year <- factor(cdc_places_data$year, 
                               levels = 1:5, 
                               labels = 2018:2022)

# Visualization -----------------------------------------------------------

# Plot for lpa
p_lpa <- ggplot(cdc_places_data, aes(x = year, y = lpa, group = tract)) +
  geom_line(alpha = 0.3, color = "lightgray") + # Add lines for each tract
  stat_summary(fun = mean, geom = "line", aes(group = 1), color = "darkgreen", linewidth = 1) + # Add mean line
  labs(
    title = "Lack of Physical Activity between 2018-2022",
    x = "Year",
    y = "lpa"
  ) +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))
print(p_lpa)

trend_lpa <- aggregate(lpa ~ year, data = cdc_places_data, FUN = mean, na.rm = TRUE)
print(trend_lpa)

# Plot for mhlth
p_mhlth <- ggplot(cdc_places_data, aes(x = year, y = mhlth, group = tract)) +
  geom_line(alpha = 0.3, color = "lightgrey") + # Add lines for each tract
  stat_summary(fun = mean, geom = "line", aes(group = 1), color = "darkblue", linewidth = 1) + # Add mean line
  labs(
    title = "Mental Distress between 2018-2022",
    x = "Year",
    y = "mhlth"
  ) +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))
print(p_mhlth)

trend_mhlth <- aggregate(mhlth ~ year, data = cdc_places_data, FUN = mean, na.rm = TRUE)
print(trend_mhlth)

# Plot for obese
p_obese <- ggplot(cdc_places_data, aes(x = year, y = obese, group = tract)) +
  geom_line(alpha = 0.3, color = "lightgrey") + # Add lines for each tract
  stat_summary(fun = mean, geom = "line", aes(group = 1), color = "darkred", linewidth = 1) + # Add mean line
  labs(
    title = "Obesity between 2018-2022",
    x = "Year",
    y = "obese"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))
print(p_obese)

trend_obese <- aggregate(obese ~ year, data = cdc_places_data, FUN = mean, na.rm = TRUE)
print(trend_obese)

# Plot lpa vs obese
p_lpa_obese <- ggplot(cdc_places_data, aes(x = lpa, y = obese)) +
  geom_point(alpha = 0.5, color = "lightgrey") + # Scatter points
  geom_smooth(method = "lm", formula = y ~ x, color = "darkgreen", se = FALSE) + # Regression line
  labs(
    title = "lpa and obese",
    x = "lpa",
    y = "obese"
  ) +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))
print(p_lpa_obese)

# Plot mhlth vs obese
p_mhlth_obese <- ggplot(cdc_places_data, aes(x = mhlth, y = obese)) +
  geom_point(alpha = 0.5, color = "lightgrey") + # Scatter points
  geom_smooth(method = "lm", formula = y ~ x, color = "darkblue", se = FALSE) + # Regression line
  labs(
    title = "mhlth and obese",
    x = "mhlth",
    y = "obese"
  ) +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))
print(p_mhlth_obese)

# Calculate correlation
cor_lpa_obese <- cor(cdc_places_data$lpa, cdc_places_data$obese, use = "complete.obs")
cor_mhlth_obese <- cor(cdc_places_data$mhlth, cdc_places_data$obese, use = "complete.obs")

cor_lpa_obese
cor_mhlth_obese

# Statistical analysis ----------------------------------------------------

# GEE Model

cdc_places_data$obese <- round(cdc_places_data$obese, 0)

# Fit the Poisson GEE model
poisson_gee_model <- geeglm(
  obese ~ lpa + mhlth + year, 
  id = tract,                
  data = cdc_places_data,
  family = poisson,          
  corstr = "exchangeable"    
)

# Summarize the model
summary(poisson_gee_model)

# Model diagnostics -------------------------------------------------------

## Residual

# Pearson residuals
residuals_gee <- residuals(poisson_gee_model, type = "pearson")

# Find fitted values
fitted_values <- fitted(poisson_gee_model)

# Plot
plot(fitted_values, residuals_gee,
     xlab = "Fitted Values", 
     ylab = "Residuals", 
     main = "Residuals vs Fitted")
abline(h = 0, col = "darkorange", lwd = 2)

## Normality

# Histogram of residuals
hist(residuals_gee, 
     main = "Residuals", 
     xlab = "Residuals", 
     col = "darkblue", 
     border = "darkgray")

# QQ plot
qqnorm(residuals_gee, main = "QQ Plot")
qqline(residuals_gee, col = "darkgreen", lwd = 2) 
