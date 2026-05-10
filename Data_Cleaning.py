#import pandas package to handle csv files and clean data. 
import pandas as pd

# storing the excel file in a variable called file
file = "Main Tables.xlsx"

# Read each sheet from the excel file which then becomes a dataframe 
H = pd.read_excel(file, sheet_name="Hypercars")
TS = pd.read_excel(file, sheet_name="Tech_Specs")
P = pd.read_excel(file, sheet_name="Performance")
M = pd.read_excel(file, sheet_name="Market")
B = pd.read_excel(file, sheet_name="Brands")

# convert each dataframe into a csv file
H.to_csv("hypercars.csv", index=False)
TS.to_csv("tech_specs.csv", index=False)
P.to_csv("performance.csv", index=False)
M.to_csv("market.csv", index=False)
B.to_csv("brands.csv", index=False)

print(" All sheets converted to CSV successfully!")


# DATA CLEANING SCRIPT

# HANDLE MISSING VALUES

# Convert - in M table to null value 
M.replace(['—', '-'], pd.NA, inplace=True)

# Convert Units_Produced column into a numeric column
M['Units_Produced'] = pd.to_numeric(M['Units_Produced'], errors='coerce')

# Fill missing values with median
M['Units_Produced'].fillna(M['Units_Produced'].median(), inplace=True)

# REMOVE DUPLICATES
H.drop_duplicates(inplace=True)
TS.drop_duplicates(inplace=True)
P.drop_duplicates(inplace=True)
M.drop_duplicates(inplace=True)
B.drop_duplicates(inplace=True)


# FIX DATA TYPES
TS['Horsepower'] = pd.to_numeric(TS['Horsepower'], errors='coerce')
TS['Torque_Nm'] = pd.to_numeric(TS['Torque_Nm'], errors='coerce')
TS['Top_Speed_kmph'] = pd.to_numeric(TS['Top_Speed_kmph'], errors='coerce')

P['Weight_kg'] = pd.to_numeric(P['Weight_kg'], errors='coerce')
P['Power_to_Weight'] = pd.to_numeric(P['Power_to_Weight'], errors='coerce')

M['Price_Million'] = pd.to_numeric(M['Price_Million'], errors='coerce')

# CLEAN TEXT DATA
# Standardize country names
B['Country'] = B['Country'].replace({
    'USA': 'United States of America',
    'UK': 'United Kingdom'
})

# Remove extra spaces
B['Brand_Name'] = B['Brand_Name'].str.strip()
H['Model_Name'] = H['Model_Name'].str.strip()

# HANDLE OUTLIERS
#Cap unrealistic speeds
TS.loc[TS['Top_Speed_kmph'] > 500, 'Top_Speed_kmph'] = 500

# Remove invalid horsepower
TS = TS[TS['Horsepower'] > 0]

# Creates a list (set) of all valid Car_IDs from Hypercars table and Keep only those rows where Car_ID exists in Hypercars table
valid_ids = set(H['Car_ID'])

TS = TS[TS['Car_ID'].isin(valid_ids)]
P = P[P['Car_ID'].isin(valid_ids)]
M = M[M['Car_ID'].isin(valid_ids)]

# 8. SAVE CLEANED DATA
H.to_csv("clean_hypercars.csv", index=False)
TS.to_csv("clean_tech_specs.csv", index=False)
P.to_csv("clean_performance.csv", index=False)
M.to_csv("clean_market.csv", index=False)
B.to_csv("clean_brands.csv", index=False)

print("Data cleaning completed successfully!")