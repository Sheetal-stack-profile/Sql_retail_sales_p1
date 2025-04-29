
---- SQL RETAILS SALES ANALYSIS - P1
CREATE DATABASE PROJECT
USE PROJECT


---- SQL RETAILS SALES ANALYSIS - P1
DROP TABLE IF EXISTS RETAIL_SALES;
CREATE TABLE RETAIL_SALES
						( TRANSACTIONS_ID INT PRIMARY KEY,
						SALES_DATE DATE, 
						SALES_TIME TIME,
						CUSTOMER_ID INT,
						GENDER VARCHAR (15),
						AGE INT,
						CATEGORY VARCHAR(15),
						QUANTITY INT,
						PRICE_PER_UNIT FLOAT,
						COGS FLOAT,
						TOTAL_SALES FLOAT
						)
SELECT * FROM RETAIL_SALES

BULK INSERT [dbo].[RETAIL_SALES]
FROM 'D:\MSBI\SQL - Retail Sales Analysis_utf .csv'
WITH (FIRSTROW =2,
	  FIELDTERMINATOR = ',',
	  ROWTERMINATOR = '\n')

SELECT TOP 100 * FROM RETAIL_SALES;


------- How to find Null ------------------
select * from RETAIL_SALES where TRANSACTIONS_ID is null or SALES_DATE is null or SALES_TIME is null or CUSTOMER_ID is null
or GENDER is null or AGE is null or category is null or price_per_unit is null or cogs is null or total_sales is null

----- Delete NULL VALUES -----------------

Delete from RETAIL_SALES where TRANSACTIONS_ID is null or SALES_DATE is null or SALES_TIME is null or CUSTOMER_ID is null
or GENDER is null or AGE is null or category is null or price_per_unit is null or cogs is null or total_sales is null

--- Data Exploration -------

----- How many sales we have ? --------

select COUNT(*) as total_sales from RETAIL_SALES

--- How many customers we have?

select distinct COUNT( customer_id) as total_customers from RETAIL_SALES

------Category name ---------

Select distinct category from RETAIL_SALES

------- Data Analysis and business key problems and answer --------------

--Q. Write a Sql queries to reterive all columns for sales made on '2022-11-05'

select * from RETAIL_SALES where SALES_DATE = '2022-11-05'

--Q. WAQ to reterive all transactions where the category is 'clothing' and the quantity sold is more the 2 in the
--month of nov-2022?

select category,quantity,SALES_DATE from RETAIL_SALES where CATEGORY = 'clothing ' and QUANTITY>2 and 
SALES_DATE between '2022-11-01' and '2022-11-30'

--OR

SELECT * FROM RETAIL_SALES WHERE CATEGORY='CLOTHING' AND QUANTITY>2 AND FORMAT(SALES_DATE, 'yyyy-MM') = '2022-11'

--Q. Write a sql query to calculate the total sales (total_sale) for each category?

select sum(total_sales) as total_sales,COUNT(*) as total_oder, category from RETAIL_SALES group by category

--Q. Write a sql query to find the average age of customers who purchased itens from the 'Beauty' category?

select category, ROUND( AVG(age),2) as average_age  from RETAIL_SALES where CATEGORY='Beauty' group by category

--Q. Write a sql query to find all tranctions where total_sale is grater than 1000?

select * from RETAIL_SALES where TOTAL_SALES>1000


--Q. Write a sql query to find the total number of tranactions  (tranction_id) made by each gender in each category.?

select COUNT(*) as total_tranctions,gender,category from RETAIL_SALES group by GENDER, CATEGORY order by 
total_tranctions asc

--Q. Write a sql query to calculate the average sale for each month Find out best selling month in each year?

select * from (
select 
		YEAR(sales_date) as sales_year ,
		MONTH (sales_date) as sales_month,
		AVG(total_sales) as average_salary,
		row_number() over(partition by YEAR(sales_date)order by AVG(total_sales) desc) as rn
	from RETAIL_SALES
	group by YEAR(SALES_DATE), MONTH(SALES_DATE) 
)as monthly_avg
where rn = 1

--Q. WAQ to find the top 5 customers based on the highest total sales?

select top 5 customer_id, SUM(total_sales) as total_sale from RETAIL_SALES group by customer_id order by 2 desc

--Q. WAQ to find the number of unique customers who purchased items each category?

select   COUNT( distinct customer_id) as unique_customer ,category from RETAIL_SALES  group by category 


--Q. WAQ to create each shift and number of orders (Example Morning <=12,afternoon between 12 & 17 , Evening > 17 )

with shift_time
as
(
SELECT *,
    CASE
        WHEN DATEPART(HOUR, SALES_TIME) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, SALES_TIME) >= 12 AND DATEPART(HOUR, SALES_TIME) <= 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, SALES_TIME) > 17 THEN 'Evening'
        ELSE 'No Shift time'
    END AS Shifts
FROM RETAIL_SALES
)

select shifts, COUNT(*) as total_count from shift_time group by Shifts


---- Ends of Project

















