# -NFT-sales-data-analayzation-for-Cryptopunks-using-SQL
This project analyzes real-world sales data from Cryptopunks, one of the most renowned Non-Fungible Token (NFT) projects. NFTs, stored on a blockchain, represent unique digital items, transforming ownership, trading, and valuation in the digital domain.
Objectives:
Sales Analysis: Investigate the sales data of Cryptopunks NFTs to gain insights into sales trends, transaction volumes, and pricing dynamics.
Top Transactions: Identify the top 5 most expensive transactions in terms of USD price.
Moving Average Calculation: Compute the moving average of USD prices for each transaction, smoothing out price fluctuations.
Average Sale Prices: Determine the average sale price of each NFT name in USD, providing insights into the value of different NFTs.
Sales Distribution: Analyze sales distribution by day of the week, along with average prices in ETH.
Summary Generation: Construct a summary column describing each sale, including buyer, seller, date, and sale price.
View Creation: Create a view containing all purchases made by a specific buyer wallet address.
Histogram Generation: Generate a histogram of ETH price ranges to visualize the distribution of prices.
Unioned Query: Combine queries to find the highest and lowest purchase prices for each NFT.
Monthly Sales Analysis: Determine the NFT that sold the most each month/year combination and its price in USD.
Total Volume Calculation: Calculate the total sales volume rounded to the nearest hundred on a monthly basis.
Transaction Count: Count the total number of transactions made by a specific wallet address over the time period.
Estimated Average Value Calculator: Develop a daily average value calculator based on representative pricing criteria, excluding outliers.
How to Use:
 1. Clone the repository to your local machine using Git.
 2. Ensure that you have access to the Cryptopunks NFT sales data.
 3. Open the SQL queries file and execute the queries using your preferred database management tool.
 4. Review the output of each query to gain insights into the Cryptopunks NFT sales data.
Project Structure:
SQL Queries: Contains all SQL queries used for data analysis and manipulation.
README.md: Documentation providing an overview of the project, objectives, tools, and instructions for running the queries.
Data: Sample dataset or reference to the database containing Cryptopunks NFT sales data.
Cryptopunk, Pricedata:table creation(dumping data to the table).
