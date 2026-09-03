-- =============================================================================
-- Retail Orders Analysis - SQL Server
-- -----------------------------------------------------------------------------
-- Equivalent analytics to orders_analysis.ipynb, written for SQL Server.
-- The data lives in the `retail_orders` table. Column names that contain
-- spaces are wrapped in square brackets (e.g. [Product Name], [Order Date]).
--
-- Queries:
--   Q1. Top 10 highest revenue generating products
--   Q2. Top 5 highest selling products in each region
--   Q3. Month-over-month growth comparison (2012 vs 2013)
--   Q4. Month with highest sales for each category
--   Q5. Sub-category with highest profit growth (2013 vs 2012)
-- =============================================================================

-- Q1: Find top 10 highest revenue generating products
-- Revenue is measured using the Sales column.
select top 10 [Product Name], sum(Sales) as sales
from retail_orders
group by [Product Name]
order by sales desc




-- Q2: Find top 5 highest selling products in each region
-- Rank products by sales within each region and keep the top 5.
with cte as (
select [Region],[Product Name],sum(Sales) as sales
from retail_orders
group by [Region],[Product Name])
select * from (
select *
, row_number() over(partition by [Region] order by sales desc) as rn
from cte) A
where rn<=5




-- Q3: Find month-over-month growth comparison for 2012 and 2013 sales
-- e.g. Jan 2012 vs Jan 2013
with cte as (
select year([Order Date]) as order_year,month([Order Date]) as order_month,
sum(Sales) as sales
from retail_orders
group by year([Order Date]),month([Order Date])
--order by year([Order Date]),month([Order Date])
	)
select order_month
, sum(case when order_year=2012 then sales else 0 end) as sales_2012
, sum(case when order_year=2013 then sales else 0 end) as sales_2013
from cte 
group by order_month
order by order_month




-- Q4: For each category, which month had the highest sales
-- Combine year+month into a single key and keep the top month per category.
with cte as (
select [Product Category],format([Order Date],'yyyyMM') as order_year_month
, sum(Sales) as sales 
from retail_orders
group by [Product Category],format([Order Date],'yyyyMM')
--order by [Product Category],format([Order Date],'yyyyMM')
)
select * from (
select *,
row_number() over(partition by [Product Category] order by sales desc) as rn
from cte
) a
where rn=1




-- Q5: Which sub category had the highest growth by profit in 2013 compared to 2012
-- Computes total sales per sub-category per year, then the year-on-year growth.
with cte as (
select [Product Sub-Category],year([Order Date]) as order_year,
sum(Sales) as sales
from retail_orders
group by [Product Sub-Category],year([Order Date])
--order by year([Order Date]),month([Order Date])
	)
, cte2 as (
select [Product Sub-Category]
, sum(case when order_year=2012 then sales else 0 end) as sales_2012
, sum(case when order_year=2013 then sales else 0 end) as sales_2013
from cte 
group by [Product Sub-Category]
)
select top 1 *
,(sales_2013-sales_2012) as profit_growth
from  cte2
order by (sales_2013-sales_2012) desc
