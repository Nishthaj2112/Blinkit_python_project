DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
      (
       transactions_id INT PRIMARY KEY,
       sale_date DATE,  
       sale_time TIME,
       customer_id  INT, 
       gender VARCHAR(15),
       age INT,
       category VARCHAR(15),
       quantiy INT,
       price_per_unit FLOAT,
	   cogs FLOAT,
       total_sale FLOAT
      );

SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

-- data cleaning
SELECT * FROM retail_sales
WHERE 
      transactions_id IS NULL
      OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL 
	  OR
	  quantiy IS NULL
	  OR
	  price_per_unit IS NULL
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
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL 
	  OR
	  quantiy IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL;

--how many sales we have?
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- how many unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retail_sales;

-- how many categories we have ?
SELECT COUNT(DISTINCT category) AS total_sale FROM retail_sales;

--type of categories
SELECT DISTINCT category FROM retail_sales;

-- write query to retrieve all columns for sales made on 2022-11-05
SELECT * 
FROM retail_sales
WHERE sale_date= '2022-11-05';

--query to retrieve all transactions where the category is
--clothing and the qty sold is more than 4 in the month of nov-2022?
SELECT * 
FROM retail_sales
WHERE 
	  category= 'Clothing'
	  AND
	  TO_CHAR(sale_date,'YYYY-MM')='2022-11'
	  AND
	  quantiy>=4;

-- query to calculate total sales (total_sale) for each category.
SELECT category,
       SUM(total_sale) AS net_sale,
	   COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1

--query to find avg age of customers who purchased items from the 'beauty' category
SELECT 
       ROUND(AVG(age),2) as average_age
FROM retail_sales
WHERE category='Beauty'

--query to find all transactions where the total sale is greater than 1000
SELECT * 
FROM retail_sales
WHERE total_sale>1000

--to find total no of transactions(transaction_id) made by each gender in each category
SELECT 
       category,
	   gender,
	   COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category,
         gender
ORDER BY 1

--To calculate avg sale for each month .Find out best selling month in each year.
SELECT 
       year,
	   month,
	   avg_sale
FROM (SELECT                                                 --table
      EXTRACT (YEAR FROM sale_date) AS year,                  --year,month,rank are columns
	  EXTRACT (MONTH FROM sale_date) AS month,
	 AVG(total_sale) AS avg_sale,
  RANK () OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC )AS rank
FROM retail_sales
GROUP BY 1,2)
WHERE rank=1

-- query to find top 5 customers based on the highest total sales 
SELECT customer_id,
       SUM(total_sale) AS net_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--TO find no of unique customers who purchased items from each category
SELECT 
       category,
	   Count(DISTINCT customer_id) as total_customers
FROM retail_sales
GROUP BY 1

--another method
select category,
       count(distinct customer_id) as count_unique_cs
from retail_sales 
group by category 
having count(*) >1;

--to create each shift and no.of orders(EXAMPLE- morning<=12,afternoon between 12&17 ,evening>17)
WITH hourly_sale
AS
(
   SELECT *,
       CASE
	   WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'morning'
	   WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
	   ELSE 'evening'
	   END AS shift                              --column
   FROM retail_sales
)
SELECT 
     shift,
	 COUNT(*) AS total_orders
FROM hourly_sale 
GROUP BY shift

-- above ques can also be solved as 
SELECT
CASE
WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift,
COUNT(*) AS number_of_orders
FROM retail_sales
GROUP BY 1;
