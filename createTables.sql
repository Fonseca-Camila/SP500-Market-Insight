DROP DATABASE IF EXISTS sp500;
CREATE DATABASE IF NOT EXISTS sp500; 
USE sp500;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';

DROP TABLE IF EXISTS sp500_companies,
                     sp500_index,
                     sp500_stocks;

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