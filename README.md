# S&P 500 Market Insights: Stock Price Volatility Analysis

## Business understanding

The **S&P 500 Index** is one of the most widely followed stock market indices, representing the performance of 500 of the largest publicly traded companies in the United States. The index includes companies from a diverse set of sectors and industries, making it a key indicator of the health of the U.S. economy and stock market. The companies in the S&P 500 are selected based on their market capitalization, liquidity, and other criteria, with larger companies having a greater influence on the index's movements.

This project aims to analyze the financial and operational performance of the companies within the **S&P 500 Index** by leveraging historical data on stock performance, financial health, and other business metrics. The analysis will focus the following area:

- **Stock Price Volatility**: Assessing the volatility of stock prices for individual companies within the index. This analysis will help investors understand which stocks and sectors are more susceptible to price fluctuations and market uncertainty.

## Table of Contents
2. [Data Collection](#data-collection)
3. [Data Preprocessing](#data-preprocessing)
4. [Data Modeling](#data-modeling)
5. [Exploratory Data Analysis](#exploratory-data-analysis)

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

## Data Preprocessing 

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

## Exploratory Data Analysis

### Stock Price Volatility Analysis

Stock price volatility measures how much a stock’s price fluctuates over time. High volatility means large price swings, while low volatility suggests stability. Key factors influencing volatility include economic events, interest rate changes, and company news. Volatility is crucial for investors, as high volatility can mean higher risk but potentially greater returns, while low volatility indicates stability and lower risk.

- Goal: Identify stocks with the highest volatility within the S&P 500 and analyze possible reasons for it.
- Approach:
  - Calculate daily price changes in the stocks table using high and low values, as well as open and close prices, to create a volatility metric. The formula applied for this task will be **AVG(high_value - low_value)**
  - Investigate correlations between high volatility and factors like revenue growth, market capitalization, ebitda and weight from the companies table.

```python
import pandas as pd
import pymysql
import matplotlib.pyplot as plt
import seaborn as sns
import warnings

# connection to mysql database
connection = pymysql.connect(
    host='localhost',
    user='root',
    password='maxyboki',
    database='sp500'
)

warnings.filterwarnings("ignore")

query = """WITH StockVolatility AS ( 
    SELECT 
        stock_ticker,
        AVG(high_value - low_value) AS avg_daily_volatility
    FROM 
        sp500_stocks
    GROUP BY 
        stock_ticker
)
SELECT 
    c.shortname,
    c.sector,
    c.market_cap,
    c.revenue_growth,
    c.ebitda, 
    c.weight,  
    sv.stock_ticker,
    sv.avg_daily_volatility
FROM 
    StockVolatility sv
JOIN 
    sp500_company c ON sv.stock_ticker = c.stock_ticker
WHERE 
    c.market_cap IS NOT NULL 
    AND c.revenue_growth IS NOT NULL
ORDER BY 
    sv.avg_daily_volatility DESC;"""

df_stockVolatility = pd.read_sql(query, connection)

# close connection
connection.close()

corr_matrix = df_stockVolatility[['avg_daily_volatility', 'market_cap', 'ebitda','weight','revenue_growth']].corr()


plt.figure(figsize=(8, 6))
sns.heatmap(corr_matrix, annot=True, cmap='coolwarm', fmt='.2f', linewidths=0.5)
plt.title('Correlation Matrix')
plt.show()

```

![image](https://github.com/user-attachments/assets/fb08cae4-c074-49d6-b74a-058e780345c0)

Based on the correlation matrix, here are some insights into the relationships between the variables:

1. Volatility (`avg_daily_volatility`):

The correlation with other variables is very weak (close to 0). This suggests that volatility does not have a strong linear relationship with market capitalization, EBITDA, weight, or revenue growth.

2. Market Capitalization (`market_cap`):

EBITDA: There's a strong positive correlation of 0.85. This suggests that larger companies tend to have higher EBITDA values.
Weight: The correlation of 1.0 indicates that `market_cap` and `weight` are perfectly correlated, meaning these two variables are likely the same or derived from the same metric.
Revenue Growth: The correlation with `market_cap` is 0.18, which is low but indicates a slight positive relationship, suggesting that larger companies tend to have somewhat higher revenue growth.

3. EBITDA (`ebitda`):

Market Cap and Weight: These have strong positive correlations with 0.85, indicating that companies with higher EBITDA are typically larger and have greater weight in the index.
Revenue Growth: There is a weak positive correlation of 0.06, suggesting that higher EBITDA does not strongly correlate with revenue growth in this dataset.

4. Weight (`weight`):

This variable shows a perfect correlation with `market_cap` (as indicated by the correlation coefficient of 1.0), and also a high correlation with `ebitda` (0.85), reinforcing the relationship between these factors.

5. Revenue Growth (`revenue_growth`):

The correlation with the other variables is relatively weak. The highest correlation is with market_cap and weight at 0.18, indicating a slight positive relationship.

#### Conclusion:
- No strong direct correlation with volatility: There is no strong linear relationship between volatility and the other factors like market cap, EBITDA, weight, or revenue growth.
- Strong correlations between market cap, EBITDA, and weight: Larger companies with higher market cap tend to have higher EBITDA and greater weight in the index, but these factors are not strongly tied to revenue growth or volatility.
- Revenue growth: Exhibits weak correlations with all other variables, suggesting that growth in revenue may not directly influence these key financial metrics in this dataset.

