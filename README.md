# SP500

Table of contents
1. Business problem
2. Data Collection
3. Data Pre processing
4. Data Modeling
5. Exploratory Data Analysis

## Business problem


## Data Collection

You can access the dataset on [Kaggle]([https://www.kaggle.com/datasets](https://www.kaggle.com/datasets/andrewmvd/sp-500-stocks/data)).

### Schema Overview

The database schema is structured into three main tables: `companies`, `index`, and `stocks`, each holding specific data on S&P 500 companies, index values, and stock performance.

#### Table: `companies`
This table contains metadata for each S&P 500 company, including the following columns:

- `exchange`: stock exchange where the company’s shares are traded
- `symbol`: stock ticker symbol for the company
- `shortname`: abbreviated name of the company
- `longname`: full name of the company
- `sector`: sector in which the company operates
- `industry`: specific industry within the sector
- `currentprice`: current stock price
- `marketcap`: market capitalization, calculated as `number of outstanding shares × price per share`
- `ebitda`: earnings before interest, taxes, depreciation, and amortization
- `revenuegrowth`: company’s revenue growth
- `city`: city where the company is headquartered
- `state`: state where the company is headquartered
- `country`: country where the company is headquartered
- `fulltimeemployees`: total number of full-time employees
- `longbusinesssummary`: summary of the company’s business
- `weight`: company’s representation percentage in the S&P 500 index, based on market capitalization

#### Table: `index`
This table records historical values of the S&P 500 index, with the following columns:

- `date`: date of the index value
- `s&p500`: S&P 500 index value on the specified date

#### Table: `stocks`
This table provides daily stock performance data for each S&P 500 company, with the following columns:

- `date`: date of the stock data
- `symbol`: company’s stock ticker symbol
- `adjclose`: adjusted close price, reflecting adjustments for dividends and stock splits
- `close`: closing price at market close
- `high`: highest trading price during the day
- `low`: lowest trading price during the day
- `open`: opening price at market open
- `volume`: total volume of shares traded

## Data Pre Processing 

In order to prepare the S&P 500 Stocks dataset, there were three main steps needed to perform.

The first step in the pre-processing process was using Python and the `pandas` library. Pandas is a powerful tool that allows data manipulation and analysis. With these tools, we were able to analyze the `sp500_companies` table and eliminate the `longbusinesssummary` column, as it was not needed for the analysis.

Regarding the `sp500_stocks` table, we identified that not every company enters the S&P 500 index at the same time. As a result, some dates had missing values. We decided to delete all rows that contained null values, ensuring consistency in the dataset.

Once these tasks were completed, the datasets were exported as CSV files with the following parameters:

```python
df.to_csv('sp500_data.csv', sep=';', index=False, quotechar='"', na_rep='NULL')
```

## Data Modeling

The creation of the database and its tables in SQL involves setting up the necessary structures to hold the data for the S&P 500 companies, index values, and stock performance. Below is the SQL code used to create the database and tables:

```sql
CREATE DATABASE IF NOT EXISTS sp500;

CREATE TABLE sp500_companies (
    stock_exchange VARCHAR(10),
    stock_ticker VARCHAR(10) PRIMARY KEY,
    shortname VARCHAR(100),
    longname VARCHAR(255),
    sector VARCHAR(100),
    industry VARCHAR(100),
    current_price DECIMAL(8, 2),
    market_cap BIGINT,
    ebitda BIGINT,
    revenue_growth DECIMAL(5, 4),
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(50),
    full_time_employees INT,
    weight DECIMAL(8, 6)
);

CREATE TABLE sp500_index (
    index_date DATE PRIMARY KEY,
    sp500_value DECIMAL(6, 2) 
);

CREATE TABLE sp500_stocks (
    stock_date DATE,
    stock_ticker VARCHAR(6),
    adj_close DECIMAL(8, 4),
    close_value DECIMAL(8, 4),
    high_value DECIMAL(8, 4),
    low_value DECIMAL(8, 4),
    open_value DECIMAL(8, 4),
    volume BIGINT default NULL,
    PRIMARY KEY (stock_date, stock_ticker),
    FOREIGN KEY (stock_ticker) REFERENCES sp500_companies(stock_ticker)
);
```

The following diagram visually represents the structure of the relational schema, illustrating the relationships between the tables and how they are interconnected. It provides a clear overview of the data model and can help in understanding the database's design.

## Exploratory Data Analysis
