Occupational Health Data Management and Analysis Pipeline
Project Overview
This project focuses on cleaning, managing, and analysing occupational health data using R. The dataset represents 1,000 participants from three study sites: SITEA, SITEB, and SITEC.
The main aim is to improve data quality, handle missing values, identify duplicates and outliers, and prepare a clean dataset for further analysis.
Project Structure
occupational-health-data-pipeline/
├── data/
│   ├── raw/
│   │   └── occupational_health_raw.csv
│   └── processed/
│       └── occupational_health_clean.csv
├── scripts/
│   ├── 01_data_cleaning.R
│   └── 02_summary_tables.R
├── docs/
│   └── codebook.md
├── dashboard/
│   └── occupational_health_summary.pbix
└── README.md

Data Management Process
The project includes the following steps:
Data import: Load the raw occupational health dataset into R.
Missing values: Identify missing values and blank entries.
Duplicate records: Identify and remove duplicate rows.
Outlier checks: Check for unusual values, such as unrealistic ages.
Data cleaning: Standardise variable formats and correct inconsistencies.
Variable recoding: Create age groups and BMI categories.
Data validation: Check the consistency of selected variables, including BMI.
Data export: Save the cleaned dataset as a CSV file.
Summary analysis: Generate descriptive statistics and summary tables by study site.
Summary of the Dataset
Total participants: 1,000
Number of study sites: 3
SITEA: 335 participants
SITEB: 333 participants
SITEC: 332 participants
BMI Distribution
Normal weight: 273 participants
Overweight: 396 participants
Obese: 331 participants
Tools Used
R
RStudio
tidyverse
Microsoft Power BI (optional, for data visualisation)
How to Run the Project
Install R and RStudio.
Download or clone this repository.
Open the project in RStudio.
Place the raw dataset in the data/raw/ folder.
Run scripts/01_data_cleaning.R to clean and validate the data.
Run scripts/02_summary_tables.R to generate summary tables.
Find the cleaned dataset in data/processed/.
Output
The main output is occupational_health_clean.csv, which contains the cleaned dataset for further analysis.
The project also includes summary tables and a codebook describing the dataset variables.
Author
Saraswathi
Interested in research data management, data quality, and health data analysis.

