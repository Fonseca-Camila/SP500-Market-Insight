LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sp500_companies4.csv'
INTO TABLE sp500_companies
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS (stock_exchange,stock_ticker,shortname,longname,sector,industry,current_price,market_cap,ebitda,revenue_growth,city,state,country,full_time_employees,weight);
SELECT * FROM sp500_companies LIMIT 10;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sp500_index.csv'
INTO TABLE sp500_index
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 
SELECT * FROM sp500_index LIMIT 10;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sp500_stocks1.csv'
INTO TABLE sp500_stocks
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 
SELECT * FROM sp500_stocks LIMIT 10;

--SHOW VARIABLES LIKE 'secure_file_priv';