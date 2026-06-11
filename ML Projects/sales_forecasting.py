print("Python Working Successfully")
from tkinter.tix import Select

from tkinter.tix import Select

from matplotlib.pyplot import step
import pandas as pd
import requests
import joblib
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
from sqlalchemy import create_engine
from urllib.parse import quote_plus

# STEP 2 - SQL SERVER CONNECTION

server = "Superior\\SQLEXPRESS"
database = "Sales"

# SQL Server Driver
driver = quote_plus(
    "ODBC Driver 17 for SQL Server"
)

# CREATE ENGINE

engine = create_engine(
    f"mssql+pyodbc://@{server}/{database}"
    f"?driver={driver}"
    f"&trusted_connection=yes"
)

sql_query= """SELECT * FROM  customer"""

df=pd.read_sql(sql_query, engine)

print("SQL Data Loaded")
# STEP 3 - EXTRACT DATA FROM CRM API

#api_url= "https://api.example.com/sales_data"
#response=requests.get(api_url)
#crm_json=response.json()
#crm_df=pd.Datafram(crm_json)

df.head()
print(df.shape)

#step 4 - DATA PREPROCESSING
#data= pd.merge(df, crm_df, on="customer_id")

print(df)

df.describe()
