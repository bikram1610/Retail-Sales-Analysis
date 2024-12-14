-- Create Table
create table retail_sales
	(
		transactions_id int primary key,
		sale_date date,
		sale_time time	,
		customer_id int,
		gender varchar(10),
		age int,
		category varchar(20),
		quantiy	int,
		price_per_unit float,
		cogs float,	
		total_sale float
	)

-- Show Table
select * from retail_sales;

-- Count Number of Records
select count(*) from retail_sales

-- Finding null values
select * from retail_sales where
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

-- Delete Null Values
delete from retail_sales
where
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

-- How many customers do we have?
select count(distinct(customer_id))
from retail_sales

-- Different categories
select distinct(category) from retail_sales

-- Basic Analysis

-- 1. Retrieve all columns for sales made on '2022-11-05:
select * from retail_sales where sale_date = '2022-11-05'

-- 2. Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from retail_sales
where category
like '%Clothing%' and quantiy >= 4
and to_char(sale_date, 'YYYY-MM') = '2022-11'

-- 3. Calculate the total orders and sales for each category
select category, count(transactions_id) as Orders , sum(total_sale) as Sales
from retail_sales
group by category

-- 4. Find the average age of customers who purchased items from the 'Beauty' category
select round(avg(age),0) as avg_age
from retail_sales
where category = 'Beauty'

-- 5. Find all transactions where the total_sale is greater than 1000
select * from retail_sales where total_sale > 1000

-- 6. Find the total number of transactions made by each gender in each category
select category, gender, count(transactions_id)
from retail_sales
group by gender, category
order by category

-- 7. Calculate the average sale for each month. Find out best selling month in each year
select Year, Month, Avg_Sale from
(
	select 
		extract(year from sale_date) as Year,
		extract(month from sale_date) as Month,
		(avg(total_sale),2) as Avg_Sale,
		RANK() OVER(PARTITION BY EXTRACT(Year FROM sale_date) ORDER BY AVG(total_sale) DESC) as Rank
	from retail_sales
	group by Year, Month
) as t1
where rank = 1

-- 8. Find the top 5 customers based on the highest total sales
select customer_id, sum(total_sale) as Total 
from retail_sales
group by customer_id 
order by Total desc 
limit 5

-- 9. Find the number of customers who purchased items from each category
select category, count(transactions_id) as Customers
from retail_sales
group by category
order by customers desc

-- 10. Create each shift and number of orders (Example Morning, Day, Night)
with hourly_sale as
(
	select transactions_id,
	case 
		when extract(Hour from sale_time) between 6 and 11 then 'Morning'
		when extract(Hour from sale_time) between 12 and 17 then 'Day'
		else 'Night'
	end as Shift
	from retail_sales
)
select 
    shift,
    count(transactions_id) as total_orders    
from hourly_sale
group by shift
order by shift