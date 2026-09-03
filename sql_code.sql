--find top 10 highest revenue generating products 
select top 10 [Product Name], sum(Sales) as sales
from retail_orders
group by [Product Name]
order by sales desc




--find top 5 highest selling products in each region
with cte as (
select [Region],[Product Name],sum(Sales) as sales
from retail_orders
group by [Region],[Product Name])
select * from (
select *
, row_number() over(partition by [Region] order by sales desc) as rn
from cte) A
where rn<=5



--find month over month growth comparison for 2012 and 2013 sales eg : jan 2012 vs jan 2013
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




--for each category which month had highest sales 
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




--which sub category had highest growth by profit in 2013 compared to 2012
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
,(sales_2013-sales_2012)
from  cte2
order by (sales_2013-sales_2012) desc
