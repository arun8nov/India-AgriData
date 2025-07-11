# import libraries
import pandas as pd

# Read and process India Rainfall data
Rain_df = pd.read_csv('IndiaRainFall.csv',index_col=0)
Rain_df = Rain_df[['SUBDIVISION','Latitude','Longitude','YEAR','ANNUAL']].reset_index(drop=True)
Rain_df.columns = ['State Name','Lat','Long','Year','Annual Rainfall(mm)']


# Load the dataset from the provided URL
url = 'https://docs.google.com/spreadsheets/d/1PHf2rFB53qUu7j8-r4qcHQdrhvxOyiyhyMWIY-nb_m8/export?format=csv&gid=321359364'
df = pd.read_csv(url)

# Drop duplicate rows based on all columns
df.drop_duplicates(inplace=True)

# change float64 columns to round to 2 decimal places
for col in df.select_dtypes(include=['float64']).columns:
    df[col] = df[col].round(2)

# Fill NaN values with '0' in all columns
df.fillna('0', inplace=True)

df.to_csv('IndiaCropData.csv', index=False)

Rain_df.to_csv('IndiaRainFallData.csv', index=False)

print("India Crop Data and India Rain Fall Data  Proceed Sucessfully")