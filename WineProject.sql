select *
from [Wine Project]. .[winemag-data_first150k]

use [Wine Project]
go

SELECT *
FROM [Wine Project].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'winemag-data_first150k'

SELECT count(*) as row_count
FROM [winemag-data_first150k]

select distinct count(column1) as check_dups
from [winemag-data_first150k]

select distinct count(column1)
from [winemag-data_first150k]

--Top 10 winery with the best Pinot Noir


--The different types of wine
SELECT variety, count(variety) as count_variety
from [Wine Project]. .[winemag-data_first150k]
group by variety

Select distinct top (10) winery, province, points, price 
from [Wine Project]. .[winemag-data_first150k]
where variety  = 'Pinot Noir' and price is not null
Order by points desc

SELECT distinct top(10) winery, variety, province, points, price
from [winemag-data_first150k]
where variety like 'cabernet sauvignon%' and price is not null
order by points desc

SELECT distinct top(10) winery, variety,province, points, price
from [winemag-data_first150k]
where variety like 'Bordeaux%' and price is not null
order by points desc

--Prices of Bordeaux-style Red Blend wine variety
select variety,price
from [Wine Project]. . [winemag-data_first150k]
where variety = 'Bordeaux-style Red Blend'
order by price desc

--Best Rated wine variety
select variety, avg(points) as average_points, round(avg(price),2) as average_price, count(variety) as count
from [Wine Project]. .[winemag-data_first150k]
where price is not null 
group by variety
having count(variety) >= 10 
order by average_points desc

--Comparison between average points and average price to variety
with avgvarietyrating (variety, points, price, counts)
as (
	select variety, avg(points) as average_points, round(avg(price),2) as average_price, count(variety) as count
	from [Wine Project]. .[winemag-data_first150k]
	where price is not null 
	group by variety
	having count(variety) >= 10 
	)

select a.variety, a.points, a.price, (points/price) as points_price_ratio
from avgvarietyrating a
order by points_price_ratio desc
--There for in conclusion there is a difference between points and price to variety

--Best winery for people who like sweet wines
select top (10) winery, country, avg(points) as AveragePoints, avg(price) as AveragePrice, variety
from [Wine Project]. .[winemag-data_first150k]
where description like '%sweet%'
group by winery,variety,country
order by AveragePoints desc

DROP table if exists sweetwine
Create table sweetwine(
	winery nvarchar(50),
	country  nvarchar(50),
	AvgPoints  numeric,
	Price  numeric,
	variety  nvarchar(50)
)
insert into sweetwine
	select winery, country, avg(points) as AveragePoints, price , variety
	from [Wine Project]. .[winemag-data_first150k]
	where description like '%sweet%'
	group by winery,variety,country,price
	order by AveragePoints desc

Select *
From sweetwine

--Average Price between sweet wine and nonsweet wine
DROP table if exists nonsweetwine
Create table nonsweetwine(
	winery nvarchar(100),
	country  nvarchar(50),
	AvgPoints  numeric,
	Price  numeric,
	variety  nvarchar(50)
)
insert into nonsweetwine
	select winery, country, avg(points) as AveragePoints, price, variety
	from [Wine Project]. .[winemag-data_first150k]
	where description not like '%sweet%'
	group by winery,variety,country,price
	order by AveragePoints desc

select *
from nonsweetwine

select round(avg(non.Price),2) as NonsweetAvgPrice, round(avg(sweet.Price),2) as SweetAvgPrice
from sweetwine sweet
	Inner join nonsweetwine non
	on non.variety = sweet.variety

--In conclusion there is a small difference between sweet wines and nonsweet wines by $0.08 

--Finding top 100 different wines that are "Fruity"
SELECT column1 AS Fruits, column2 AS Vegetables
FROM Food;

DELETE FROM food
WHERE column1 = 'Fruits' AND column2 = 'Vegetables'

select top (100) country, province, region_1,region_2, description, points, price, variety, winery, 
	Count(*) OVER (Partition BY winery)
from [Wine Project].dbo.[winemag-data_first150k]  wine
WHERE Exists (select column1 as fruits from [Wine Project]. .food  food
				Where wine.description like concat('%',food.column1,'%'))
Order by points desc
