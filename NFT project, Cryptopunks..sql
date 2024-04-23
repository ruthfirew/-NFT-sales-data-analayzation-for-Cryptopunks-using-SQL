#How many sales occurred during this time period? 
USE hero;
SELECT COUNT(*) AS total_sales
FROM pricedata
WHERE event_date >= '01-01-2018' AND event_date < '31-12-2021';
#2Return the top 5 most expensive transactions (by USD price) for this data set. Return the name, ETH price, and USD price, as well as the date.
SELECT name, eth_price, usd_price, event_date
FROM pricedata
ORDER BY usd_price DESC
LIMIT 5;
#3Return the top 5 most expensive transactions (by USD price) for this data set. Return the name, ETH price, and USD price, as well as the date.
SELECT
  event_date,
  usd_price,
  AVG(usd_price) OVER (ORDER BY event_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS moving_average
FROM
  pricedata;
#4Return all the NFT names and their average sale price in USD. Sort descending. Name the average column as average_price.
SELECT
  name,
  AVG(usd_price) AS average_price
FROM
  pricedata
GROUP BY
  name
ORDER BY
  average_price DESC;
#5Return each day of the week and the number of sales that occurred on that day of the week, as well as the average price in ETH. Order by the count of transactions in ascending order
SELECT
  DAYNAME(event_date) AS day_of_week,
  COUNT(*) AS transaction_count,
  AVG(eth_price) AS average_eth_price
FROM
  pricedata
GROUP BY
  day_of_week
ORDER BY
  transaction_count ASC;
  #6Construct a column that describes each sale and is called summary. The sentence should include who sold the NFT name, who bought the NFT, who sold the NFT, the date, and what price it was sold for in USD rounded to the nearest thousandth.
 SELECT
  CONCAT(
    name,
    ' was sold for $',
    ROUND(usd_price, 3),
    ' to ',
    buyer_address,
    ' from ',
    seller_address,
    ' on ',
    event_date
  ) AS summary
FROM
  pricedata;
  #7Create a view called “1919_purchases” and contains any sales where “0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685” was the buyer
CREATE VIEW 1919_purchases AS
SELECT * FROM  pricedata
WHERE
  buyer_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';
  #8Create a histogram of ETH price ranges. Round to the nearest hundred value. 
  SELECT
  ROUND(eth_price, -2) AS eth_price_range,
  COUNT(*) AS frequency
FROM
  pricedata
GROUP BY
  eth_price_range
ORDER BY
  eth_price_range;
#9Return a unioned query that contains the highest price each NFT was bought for and a new column called status saying “highest” with a query that has the lowest price each NFT was bought for and the status column saying “lowest”. The table should have a name column, a price column called price, and a status column. Order the result set by the name of the NFT, and the status, in ascending order. 

#Highest price for each NFT
WITH HighestPrices AS (
    SELECT
        name,
        MAX(usd_price) AS price,
        'highest' AS status
    FROM
        pricedata
    GROUP BY
        name
),
#Lowest price for each NFT
LowestPrices AS (
    SELECT
        name,
        MIN(usd_price) AS price,
        'lowest' AS status
    FROM
        pricedata
    GROUP BY
        name
)
# Union the results and order by name and status
SELECT
    name,
    price,
    status
FROM
    HighestPrices
UNION ALL
SELECT
    name,
    price,
    status
FROM
    LowestPrices
ORDER BY
    name ASC,
    status ASC;
  #10What NFT sold the most each month / year combination? Also, what was the name and the price in USD? Order in chronological format. 
  WITH RankedSales AS (
    SELECT
        name,
        usd_price,
        event_date,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM TO_DATE(event_date, 'MM-DD-YYYY
        ')), EXTRACT(MONTH FROM TO_DATE(event_date, 'MM-DD-YYYY')) ORDER BY usd_price DESC) AS sale_rank
    FROM
        pricedata
)
SELECT
    name,
    usd_price,
    event_date,
    EXTRACT(YEAR FROM TO_DATE(event_date, 'MM-DD-YYYY')) AS sale_year,
    EXTRACT(MONTH FROM TO_DATE(event_date, 'MM-DD-YYYY')) AS sale_month
FROM
    RankedSales
WHERE
    sale_rank = 1
ORDER BY
    sale_year ASC,
    sale_month ASC,
    event_date ASC;
#11Return the total volume (sum of all sales), round to the nearest hundred on a monthly basis (month/year).


 SELECT
    TO_CHAR(TO_DATE(event_date, 'YYYY-MM-DD'), 'YYYY-MM') AS month_year,
    ROUND(SUM(usd_price), -2) AS total_volume
FROM
    pricedata
GROUP BY
    TO_CHAR(TO_DATE(event_date, 'MM-DD-YYYY'), 'MM-YYYY')
ORDER BY
    TO_CHAR(TO_DATE(event_date, 'MM-DD-YYYY'), 'MM-YYYY');

#12Count how many transactions the wallet "0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685"had over this time period.
SELECT
    COUNT(*) AS transaction_count
FROM
    pricedata
WHERE
    buyer_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685'
    OR seller_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';

#13Create an “estimated average value calculator” that has a representative price of the collection every day based off of these criteria:
 #Exclude all daily outlier sales where the purchase price is below 10% of the daily average price
 #Take the daily average of remaining transactions
 #a) First create a query that will be used as a subquery. Select the event date, the USD price, and the average USD price for each day using a window function. Save it as a temporary table.
 #b) Use the table you created in Part A to filter out rows where the USD prices is below 10% of the daily average and return a new estimated value which is just the daily average of the filtered data
# A
CREATE TEMPORARY TABLE daily_avg_prices AS
SELECT
  event_date,
  usd_price,
  AVG(usd_price) OVER (PARTITION BY event_date) AS daily_avg_price
FROM
  pricedata;

# B
CREATE TEMPORARY TABLE filtered_data AS
SELECT
  event_date,
  AVG(usd_price) AS estimated_avg_value
FROM
  daily_avg_prices
WHERE
  usd_price >= 0.1 * daily_avg_price
GROUP BY
  event_date;

#14Give a complete list ordered by wallet profitability (whether people have made or lost money)
SELECT
  pd.buyer_address AS wallet_address,
  SUM(CASE WHEN pd.usd_price >= fd.estimated_avg_value THEN 1 ELSE -1 END) AS profitability
FROM
  pricedata pd
JOIN
  filtered_data fd ON pd.event_date = fd.event_date
GROUP BY
  pd.buyer_address
ORDER BY
  profitability DESC;