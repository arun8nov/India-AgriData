# Importing the required libraries
import mysql.connector
import os
from dotenv import load_dotenv
from processedata import Crop_df,Rain_df,Temp_df
from sqlalchemy import create_engine

# Load environment variables from .env file
load_dotenv()

# Get the database credentials from environment variables
db_host = os.getenv("DB_HOST")
db_port = os.getenv("DB_PORT")
db_user = os.getenv("DB_USER")
db_password = os.getenv("DB_PASSWORD")

# connect to my sql
connection = mysql.connector.connect(

    host=db_host,
    port=db_port,
    user=db_user,
    password=db_password
)
# Assign the database name to a variable
db_name = 'india_agri'

# Check the connection status and create dabase and use it

if connection.is_connected():
    db_info = connection.get_server_info()
    print(f"🎉 Successfully connected to MySQL Server version {db_info}")
    cursor = connection.cursor()
    cursor.execute(f"DROP DATABASE IF EXISTS {db_name};CREATE DATABASE {db_name};USE {db_name};")
    record = cursor.fetchone()

else:
    print("Error connecting to MySQL")

# Table name assigning

T1 = 'IndiaCropData'
T2 = "IndiaRainFallData"
T3 = "IndianTempData"

# connect mysql using sqlalchemy
connection_string = f'mysql+pymysql://{db_user}:{db_password}@{db_host}/{db_name}'
engine = create_engine(connection_string)

# push the tables to the database
try:
    Crop_df.to_sql(
        name=T1,
        con=engine,
        if_exists='replace',
        index=False
    )
    Rain_df.to_sql(
        name=T2,
        con=engine,
        if_exists='replace',
        index=False
    )
    Temp_df.to_sql(
        name=T3,
        con=engine,
        if_exists='replace',
        index=False
    )
    print(f"Successfully pushed DataFrames to the database tables named as {T1},{T2},{T3} .")

except Exception as e:
    print(f"An error occurred: {e}")