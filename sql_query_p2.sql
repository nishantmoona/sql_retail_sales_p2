SELECT *
FROM retail_sales
LIMIT 10;

SELECT COUNT(*)
FROM retail_sales;

SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;


SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL 
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL 
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
SELECT COUNT(*)
FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL 
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration

-- How many Sales we have
SELECT COUNT(*) AS total_sales
FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT(customer_id)) AS total_sale
FROM retail_sales;

-- How many different category we have?
SELECT DISTINCT(category) AS total_sale
FROM retail_sales;

--Data Analysis & Business Problems
-- 1. SQL query to retrieve all colums for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. SQL Query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of November 2022.
SELECT category, 
	SUM(quantiy)
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy >= 4
GROUP BY category;

-- 3. SQL Query to calculate the total sales for each category.
SELECT category,
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;

-- 4. SQL Query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2) AS average_age
FROM retail_sales
WHERE category = 'Beauty'

-- 5. SQL query to find all the transactions where the total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- 6. SQL Query to find the total number of transactions made by each gender in each category
SELECT 
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- 7. SQL query to calculate the average sale for each month. Find out the best selling month in each year.
SELECT
	EXTRACT(YEAR FROM sale_date) AS year,
	-- YEAR(sale_date) from MySQL
	EXTRACT (MONTH FROM sale_date) AS month,
	AVG(total_sale) AS avg_sale
FROM retail_sales
GROUP BY YEAR, MONTH
ORDER BY YEAR, avg_sale DESC;

-- Now we want the best month from each year. SO we will use WINDOW function called RANK.
SELECT *
FROM (
		SELECT
			EXTRACT(YEAR FROM sale_date) AS year,
			-- YEAR(sale_date) from MySQL
			EXTRACT (MONTH FROM sale_date) AS month,
			AVG(total_sale) AS avg_sale,
			RANK () OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
		FROM retail_sales
		GROUP BY YEAR, MONTH
		--ORDER BY YEAR, avg_sale DESC;
) AS T1
WHERE RANK = 1

-- 8. SQL query to find the top 5 customers based on the highest total_sales.
SELECT
	customer_id,
	SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

-- 9. SQL Query to find the number of unique customers who purchased items from each category.
SELECT
	category,
	COUNT(DISTINCT(customer_id)) AS unique_customers
FROM retail_sales
GROUP BY category

-- 10. SQL Query to create each shift and number of orders(Example Morning <=12, Afternoon between  12 & 17, Evening > 17)
WITH hourly_sale
AS
(
	SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift
	FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) AS total_orders 
FROM hourly_sale
GROUP BY shift

--We are not using GROUP BY statement as it will be a complicated query. So we will use CTEs.

--End of this Project

-- SELECT EXTRACT(HOUR FROM CURRENT_TIME)
	

