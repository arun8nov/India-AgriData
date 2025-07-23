# import libraries
import pandas as pd

# Read and process India Rainfall data
Rain_df = pd.read_csv('IndiaRainFall.csv',index_col=0)
Rain_df = Rain_df[['SUBDIVISION','Latitude','Longitude','YEAR','ANNUAL']].reset_index(drop=True)
Rain_df.columns = ['State_Name','Lat','Long','Year','Annual_Rainfall(mm)']
Rain_df = Rain_df.groupby('Year')['Annual_Rainfall(mm)'].mean().reset_index()
Rain_df['Annual_Rainfall(mm)'] = Rain_df['Annual_Rainfall(mm)'].round(2)

# Read and process India Temprature data
Temp_df = pd.read_csv('Indiatemp.csv')
Temp_df = Temp_df[['YEAR','ANNUAL']]
Temp_df.columns = ['Year','Annual Temp deg C']

# Load the dataset from the provided URL
url = 'https://docs.google.com/spreadsheets/d/1PHf2rFB53qUu7j8-r4qcHQdrhvxOyiyhyMWIY-nb_m8/export?format=csv&gid=321359364'
Crop_df = pd.read_csv(url)

# Drop duplicate rows based on all columns
Crop_df.drop_duplicates(inplace=True)

# change float64 columns to round to 2 decimal places
for col in Crop_df.select_dtypes(include=['float64']).columns:
    Crop_df[col] = Crop_df[col].round(2)

# Fill NaN values with '0' in all columns
Crop_df.fillna('0', inplace=True)

# Rename columns to have underscores between words
Crop_df.columns = [i.replace(' ','_') for i in Crop_df.columns]

# Save the processed data to a CSV file
Crop_df.to_csv('data\IndiaCropData.csv', index=False)

Rain_df.to_csv('data\IndiaRainFallData.csv', index=False)

Temp_df.to_csv('data\IndiaTempData.csv', index = False)


print("India Crop Data, India Temprature Data and India Rain Fall Data  Proceed Sucessfully")