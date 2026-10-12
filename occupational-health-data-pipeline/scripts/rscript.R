# Loading libraries
library(tidyverse)

# 1. importing raw data
raw_data <- read_csv("C:\\Users\\saras\\Downloads\\occupational-health-data-pipeline\\DATA\\occupational_health_raw.csv")


# Checking structure of columns
str(raw_data)

# Quick look at summary stats to spot obvious data entry errors
summary(raw_data)



# Checking missing or blank counts for every column automatically

missing_summary <- raw_data %>%
  summarise(across(everything(), ~ sum(is.na(.) | . == "", na.rm = TRUE))) %>%
  pivot_longer(everything(), names_to = "column_name", values_to = "missing_or_blank_count") %>%
  filter(missing_or_blank_count > 0) # Show only columns that have issues

print(missing_summary)


# Checking for duplicate participant IDs
duplicate_ids <- raw_data %>%
  filter(duplicated(participant_id) | duplicated(participant_id, fromLast = TRUE))

# Checking for completely identical duplicate rows
exact_duplicates <- raw_data %>%
  filter(duplicated(.) | duplicated(., fromLast = TRUE))

# Print results
print("--- DUPLICATE PARTICIPANT IDs ---")
print(duplicate_ids)

print("--- EXACT DUPLICATE ROWS ---")
print(exact_duplicates)


# 1. Remove duplicate rows and save to a new data frame
clean_step1 <- unique(raw_data)

# Print how many rows were kept
print(nrow(raw_data))   # Original count
print(nrow(clean_step1)) # Count after removing duplicates

# 2. Print unique values for key text columns to check for typos

unique(clean_step1$sex)

unique(clean_step1$smoking_status)

unique(clean_step1$alcohol_frequency)

unique(clean_step1$physical_activity)

unique(clean_step1$education_level)

unique(clean_step1$employment_status)

unique(clean_step1$qualityissueflag)

unique(clean_step1$studysite)

unique(clean_step1$diabetes_status)

unique(clean_step1$hypertension_status )
unique(clean_step1$medication_use )
unique(clean_step1$datacollectionmethod )


# 2. Checking summary statistics (Min, Max, Mean) for all numeric columns
summary(clean_step1[c("age_years", "height_cm", "weight_kg", "bmi", 
                      "systolic_bp", "diastolic_bp", 
                      "fastingglucosemmol_l", "totalcholesterolmmol_l")])



# 1. Standardize medication_use (change "YES" to "Yes")
clean_step1$medication_use[clean_step1$medication_use == "YES"] <- "Yes"

# Checking unique values again to verify it worked
unique(clean_step1$medication_use)

# 2. Flag or handle the age outlier (age > 120 is an error)
# Let's see which participant has age 250
clean_step1[clean_step1$age_years > 120, c("participant_id", "age_years")]

# 3. Create a clean analysis dataset by setting impossible age to NA (or filtering it out)
clean_step2 <- clean_step1

# If age is 250, turn it into NA so it doesn't break calculations
clean_step2$age_years[clean_step2$age_years > 120] <- NA

# Check summary of age_years now
summary(clean_step2$age_years)


# 1. Recode NA in alcohol_frequency to "Unknown"
clean_step2$alcohol_frequency[is.na(clean_step2$alcohol_frequency)] <- "Unknown"

# 2. Recalculate BMI for records where height and weight are present
clean_step2$bmi_recalculated <- round(clean_step2$weight_kg / ((clean_step2$height_cm / 100)^2), 1)

# 3. Fill missing BMI using the recalculated BMI if missing
clean_step2$bmi <- ifelse(is.na(clean_step2$bmi), clean_step2$bmi_recalculated, clean_step2$bmi)

# 4. Check missing summary again across all numeric variables
summary(clean_step2[c("age_years", "height_cm", "weight_kg", "bmi", "alcohol_frequency")])




# 1. Recode BMI into WHO standard clinical categories
clean_step2$bmi_category <- cut(
  clean_step2$bmi,
  breaks = c(0, 18.5, 25, 30, Inf),
  labels = c("Underweight", "Normal", "Overweight", "Obese"),
  right = FALSE
)

# 2. Recode Age into standard epidemiological age groups
clean_step2$age_group <- cut(
  clean_step2$age_years,
  breaks = c(0, 35, 50, 65, 100),
  labels = c("<35", "35-49", "50-64", "65+"),
  right = FALSE
)

# 3. Check the new categories using a simple table function
table(clean_step2$bmi_category, useNA = "ifany")
table(clean_step2$age_group, useNA = "ifany")



# 1. Save your fully cleaned and recoded dataset to your processed folder
write.csv(
  clean_step2,
  "C:/Users/saras/Downloads/occupational-health-data-pipeline/DATA/occupational_health_clean.csv",
  row.names = FALSE
)
# 2. Generate a baseline summary table by Study Site (SITEA, SITEB, SITEC)
# Let's calculate mean age and BMI by study site
aggregate(cbind(age_years, bmi) ~ studysite, data = clean_step2, FUN = function(x) c(Mean = mean(x, na.rm = TRUE), SD = sd(x, na.rm = TRUE)))

# 3. Check participant count per study site
table(clean_step2$studysite)







