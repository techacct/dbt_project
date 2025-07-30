import os
import pandas as pd
from sqlalchemy import create_engine
from snowflake.sqlalchemy import URL
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Read Snowflake credentials
sf_user = os.getenv("SNOWFLAKE_USER")
sf_pass = os.getenv("SNOWFLAKE_PASS")
sf_account = os.getenv("SNOWFLAKE_ACCOUNT")
sf_warehouse = os.getenv("SNOWFLAKE_WAREHOUSE")
sf_database = os.getenv("SNOWFLAKE_DATABASE")
sf_schema = os.getenv("SNOWFLAKE_SCHEMA")
sf_role = os.getenv("SNOWFLAKE_ROLE")

# Create SQLAlchemy engine for Snowflake
sf_engine = create_engine(URL(
    user=sf_user,
    password=sf_pass,
    account=sf_account,
    warehouse=sf_warehouse,
    database=sf_database,
    schema=sf_schema,
    role=sf_role
))

# Define list of tables to extract and load

target_schema = "raw"

import os
import pandas as pd

# Define the path to your CSV directory
csv_dir = "datasets"
target_schema = "raw"

# Loop through all CSV files in the directory
for filename in os.listdir(csv_dir):
    if filename.endswith(".csv"):
        table_name = os.path.splitext(filename)[0]  # get filename without .csv

        print(f"Processing file: {filename} ➝ table: {table_name}")

        # Read the CSV file into a DataFrame
        csv_path = os.path.join(csv_dir, filename)
        df = pd.read_csv(csv_path)

        # Load into Snowflake schema 'raw'
        df.to_sql(
            name=table_name,
            con=sf_engine,
            index=False,
            if_exists='replace',
            method='multi',
            schema=target_schema
        )

        print(f"Loaded {len(df)} rows into raw.{table_name}")

print("All CSV files have been loaded into Snowflake.")
