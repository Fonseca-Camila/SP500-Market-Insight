# SP500

Table of contents
1. Business problem
2. Data Collection
3. Data Pre processing
4. Data Modeling
5. Exploratory Data Analysis

## Business problem

The **S&P 500 Index** is one of the most widely followed stock market indices, representing the performance of 500 of the largest publicly traded companies in the United States. The index includes companies from a diverse set of sectors and industries, making it a key indicator of the health of the U.S. economy and stock market. The companies in the S&P 500 are selected based on their market capitalization, liquidity, and other criteria, with larger companies having a greater influence on the index's movements.

This project aims to analyze the financial and operational performance of the companies within the **S&P 500 Index** by leveraging historical data on stock performance, financial health, and other business metrics. The analysis will focus on three key areas:

- **Sector and Industry Performance**: Examining the contribution of each sector and industry to the overall performance of the S&P 500. This will help identify the sectors that are driving the market and which ones are underperforming.
  
- **Stock Price Volatility**: Assessing the volatility of stock prices for individual companies within the index. This analysis will help investors understand which stocks and sectors are more susceptible to price fluctuations and market uncertainty.

- **Longitudinal Financial Health**: Tracking the financial health of S&P 500 companies over time by analyzing key metrics such as market capitalization, EBITDA, revenue growth, and profitability. This will allow stakeholders to identify stable, high-performing companies as well as those that may be facing financial difficulties.


## Data Collection

The Kaggle dataset "S&P 500 Stocks" contains daily stock price data for all companies in the S&P 500 index, regularly updated to reflect the latest market performance. It includes stock prices, trading volumes, and other relevant metrics, which can be used for financial analysis, trend tracking, and market prediction. This dataset helps analyze individual company performance, overall market behavior, and sector performance over time. 
You can access the dataset on [Kaggle](https://www.kaggle.com/datasets/andrewmvd/sp-500-stocks/data).

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

In order to prepare the S&P 500 Stocks dataset, there were three main steps needed to perform:

1. **Data Cleaning for `sp500_companies` Table**:
The first step in the preprocessing process involved using Python and the pandas library, which is commonly used for data manipulation and analysis. With these tools, we were able to analyze the `sp500_companies` table and eliminate the `longbusinesssummary` column, as it was not needed for the analysis.

2. **Handling Missing Values in `sp500_stocks` Table**:
For the `sp500_stocks` table, we identified that not every company enters the S&P 500 index at the same time, resulting in some dates with missing values. To ensure the consistency and completeness of the data, we decided to delete all rows containing null values.

3. **Exporting the Processed Datasets**:
Once these tasks were completed, the datasets were exported as CSV files with the following parameters:

   ```python
   sep=';', index=False, quotechar='"', na_rep='NULL'
    ```
The table sp500_index did not need further modification

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


