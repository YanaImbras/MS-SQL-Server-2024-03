/*Шаблоны*/

use WideWorldImporters

-- алиасы + В каком порядке SQL выполняет операторы?
select CityName as city, count(*) as qty
from Application.Cities as c
where LastEditedBy = 1
group by CityName
having count(*) > 25
order by count(*) desc

-- последовательность выполнения Ctrl + M
select c.CityName as city, count(*) as qty
from Application.Cities as c
where c.LastEditedBy = 1 
	and city = 'Ashport' --error
group by c.CityName
having qty > 25 --error
order by qty desc --ok

-- как можно задать
select c.CityName as city1
	, city2 = c.CityName
	, c.CityName city3
	, c.CityName as [city 4]
	, c.CityName as 'city 5'
	, 'city 6' = c.CityName
from Application.Cities as c

--получить все возможные маршруты между городами
select c1.CityName, c2.CityName 
from Application.Cities as c1
cross join Application.Cities as c2

use WideWorldImporters --выбор базы

--варианты обращения к таблице
select * from WideWorldImporters.Application.People
select * from Application.People
select * from People --если схема != dbo

-- * с осторожностью на больших таблицах, лучше указать нужные колонки
set statistics time, io on

select * from Sales.OrderLines       --CPU time = 453 ms,  elapsed time = 4488 ms.
select OrderID from Sales.OrderLines --CPU time = 157 ms,  elapsed time = 2216 ms.

set statistics time, io off

-- без дублей
select CityName from Application.Cities
select distinct CityName from Application.Cities

-- ****************************************
-- ограничение кол-ва строк
-- ****************************************

select top 10 * from Application.Cities --быстро

-- без сортировки порядок не гарантирован - см Abbott
select top 10 CityID, CityName, StateProvinceID from Application.Cities
select top 10 CityID, CityName, StateProvinceID from Application.Cities order by CityName --будет другая информация 

-- сортировка по нескольким полям
select top 10 CityID, CityName, StateProvinceID from Application.Cities order by CityName asc, StateProvinceID asc
select top 10 CityID, CityName, StateProvinceID from Application.Cities order by 2, 3 desc
--сортировка изменится при добавлении колонок => сортировать лучше по названию
select top 10 CityName, StateProvinceID, LastEditedBy from Application.Cities order by 2, 3 desc


--кол-во строк - через переменную
DECLARE @n INT = 5
SELECT (TOP @n) * FROM Application.Cities

-- ****************************************
-- Постраничная выборка
-- ****************************************

DECLARE @m INT = 5
SELECT *
FROM Application.Cities as c
ORDER BY c.CityName ASC OFFSET 0 ROWS -- сортировка обязательна 
FETCH NEXT @m ROWS ONLY

-- общая формула
DECLARE @pagesize BIGINT = 10, -- Размер страницы
	@pagenum BIGINT = 1;-- Номер страницы

SELECT StockItemID, StockItemName, UnitPrice
FROM Warehouse.StockItems
ORDER BY UnitPrice DESC OFFSET(@pagenum - 1) * @pagesize ROWS -- сортировка обязательна 
FETCH NEXT @pagesize ROWS ONLY

-- ****************************************
-- вывод граничных значений
-- ****************************************
-- SELECT TOP N WITH TIES ... - выводит N строк + все строки с граничным значением столбцов сортировки


--товары по убыванию цены
SELECT StockItemID, StockItemName, UnitPrice
FROM Warehouse.StockItems
ORDER BY UnitPrice DESC

--товары, входящие в 3ку самых дорогих на складе => потеря 1 товара с граничной ценой (285.00)
SELECT TOP 3 StockItemID, StockItemName, UnitPrice
FROM Warehouse.StockItems
ORDER BY UnitPrice DESC

-- выводит строки с граничным значением столбцов сортировки
-- граница по столбцу сортировки - UnitPrice = 285.00 => 2 строки с UnitPrice = 285.00
SELECT TOP 3 WITH TIES StockItemID, StockItemName, UnitPrice
FROM Warehouse.StockItems
ORDER BY UnitPrice DESC -- сортировка обязательна!!


-- 3 строки:  граница по столбцам сортировки  - UnitPrice = 285.00, StockItemID = 73 => только 1 строка
SELECT TOP 3 WITH TIES StockItemID, StockItemName, UnitPrice
FROM Warehouse.StockItems
ORDER BY UnitPrice DESC,  StockItemID -- сортировка обязательна!!


use WideWorldImporters;

-------------
-- where - фильтрация строк по условию 
-- условие принимает 3 значения: true, false, unknown (неопределено - если в поле null)
-- в итог попадут строки, у которых условие выполнено ( = true )
-------------
select Size, * from Warehouse.StockItems where 0=1 --сколько строк?
select Size, * from Warehouse.StockItems where 1=1 --сколько строк? 229

select Size, * from Warehouse.StockItems where Size = '1/12 scale' --9 строк
select Size, * from Warehouse.StockItems where Size != '1/12 scale' --154 строки  Size <> '1/12 scale'
--остальные: Size = null
select Size, * from Warehouse.StockItems where Size = null --логическое выражение != TRUE


-- null в where: is null, is not null
select Size, * from Warehouse.StockItems where Size is null

-- null в колонке: isnull(), coalesce()
-- coalisce () - вывод первого не null-значения
select Size, ColorId, isnull(Size, 0) as [isnull], coalesce(Size, ColorId, -10) as [coalesce]
from Warehouse.StockItems 
where Size is null


-- isnull() - преобразование к типу 1го параметра 
-- coalesce() - тип данных сохраняется
select val, isnull(val, 1.4) as [isnull], coalesce(val, 1.4) as [coalesce]
from (
	select 1 as val
	union all 
	select null
) t

-------------
-- Функции в WHERE
-------------

SELECT OrderID, OrderDate, year(OrderDate)
FROM Sales.Orders o
WHERE year(OrderDate) = 2013
-- Но так лучше не писать (не может использоваться индекс (если он когда-нибудь появится)).

-- Лучше через BETWEEN
SELECT OrderDate, OrderID
FROM Sales.Orders o
WHERE OrderDate BETWEEN '2013-01-01' AND '2013-12-31'

-- WHERE по выражению
SELECT  OrderLineID AS [Order Line ID], Quantity, UnitPrice, (Quantity * UnitPrice) AS [TotalCost]
FROM Sales.OrderLines
WHERE (Quantity * UnitPrice) > 1000

--like 
select * from Warehouse.StockItems where StockItemName like 'USB%' -- начинается
select * from Warehouse.StockItems where StockItemName like '%USB%' --где угодно USB
select * from Warehouse.StockItems where StockItemName like '%USB' -- заканчиввется

-------------
-- несколько условий: AND, OR, NOT
-------------
-- вывести StockItems, где цена от 350 до 500 и название начинается с USB или Ride

-- почему попали строки с ценой < 350? 
select RecommendedRetailPrice, *
from Warehouse.StockItems
where
    RecommendedRetailPrice between 350 and 500 --цена от 350 до 500
	AND StockItemName like 'USB%' --название начинается с USB
 	OR StockItemName like 'Ride%' --название начинается с Ride


--pgdn







-- AND, OR - есть очередность выполнения - вначале все AND, затем OR
-- смена приоритета - скобки
select RecommendedRetailPrice, *
from Warehouse.StockItems
where
    RecommendedRetailPrice between 350 and 500 --цена от 350 до 500
	and (StockItemName like 'USB%' --название начинается с USB
    or StockItemName like 'Ride%') --название начинается с Ride

-------------
--работа с датами
-------------
declare @dt datetime = getdate()
select year(@dt) as [Год]  
	, [Месяц] = month(@dt)
	, datepart(quarter, @dt) as 'Квартал'
	, datename(month, @dt) as "Месяц "
	, FORMAT(@dt, 'MMMM', 'ru-ru') as [Месяц Ru]
	, FORMAT(@dt, 'D', 'ru-ru') as 'Russian'
	, FORMAT(@dt, 'D', 'en-US' ) 'US English'  
	, convert(varchar, @dt, 104) as [Дата] 
	, datetrunc(month, @dt) as begin_of_month  --c SQL2022 начало месяца
	, eomonth(@dt) as end_of_month

--дата в условии where - удобен формат 'yyyyMMdd' или 'yyyy-mm-dd'
select OrderDate from Sales.Orders where OrderDate = '20150502'
select OrderDate from Sales.Orders where OrderDate = '02.05.2015' --почему разное кол-во?


select @@language, FORMAT(cast('02.05.2015' as date), 'D', 'ru-ru') 

SET LANGUAGE 'Russian' --на уровне сеанса
select @@language, FORMAT(cast('02.05.2015' as date), 'D', 'ru-ru') 

SET LANGUAGE 'English' --верну обратно
select @@language, FORMAT(cast('02.05.2015' as date), 'D', 'ru-ru') 

-- используем универсальный формат 'yyyyMMdd' или 'yyyy-mm-dd'


use WideWorldImporters;
-- презентация + gif

----------------------------
-- как понять, по какому полю соединять
-- заказы дополнить именем клиента
select top 5 * from Sales.Orders -- Alt + F1 -- полное название fk 
-- FK_Sales_Orders_CustomerID_Sales_Customers => Sales_Orders_CustomerID = Sales_Customers.?
select top 5 * from Sales.Customers

select top 5 * 
from Sales.Orders as o
join Sales.Customers as c on c.CustomerID = o.CustomerID --o.CustomerID is not null => inner join (ничего не потеряем) 


----------------------------
drop table if exists #cafe1, #cafe2
create table #cafe1 (id int identity, name nvarchar(10))
create table #cafe2 (id int identity, name nvarchar(10))

insert #cafe1 (name) values(N'яблоки'), (N'груши'), (N'бананы')
insert #cafe2 (name) values(N'яблоки'), (N'груши'), (null)

select * from #cafe1
select * from #cafe2

----------------------------
-- cross join -все комбинации из строк двух таблиц
select *
from #cafe1 as c1
cross join #cafe2 as c2 

-- или так
select *
from #cafe1 as c1
, #cafe2 as c2 


--типовая задача: составить все возможные варианты рецептов смузи из 2х фруктов для кафе1

--алиасы
select c1.name, c2.name 
from #cafe1 as c1
cross join #cafe1 as c2 

--без алиасов
select name, name 
from #cafe1
cross join #cafe1

----------------------------
-- inner join - внутреннее соединение по условию (самое быстрое)
-- типовая задача: найти фрукты, которые есть в кафе1 и кафе2
select * from #cafe1
select * from #cafe2

select c1.name, c2.name 
from #cafe1 as c1
inner join #cafe2 as c2 on c2.name = c1.name

-- или так
select c1.name, c2.name 
from #cafe1 as c1
join #cafe2 as c2 on c2.name = c1.name


--проблема - если связываем таблицы по неуникальному полю
--добавим дубли
insert #cafe1 (name) values(N'яблоки')
insert #cafe2 (name) values(N'яблоки')

select * from #cafe1
select * from #cafe2

--сколько фруктов есть в обоих кафе?
--а сколько строк вернет запрос?
select c1.name, c2.name 
from #cafe1 as c1
inner join #cafe2 as c2 on c2.name = c1.name


--удалим дубли (но помним про проблемы)
delete from #cafe1 where id = 4
delete from #cafe2 where id = 4

select * from #cafe1
select * from #cafe2

----------------------------
-- left join
-- типовая задача: какие фрукты есть в кафе1, но нет в кафе2
-- какой фильтр в where задать, чтобы отфильтровать отсутствие фруктов в кафе2
select *
from #cafe1 as c1
left join #cafe2 as c2 on c2.name = c1.name



--дополнить список фруктов из кафе1 данными по фруктам из кафе2, название которых начинается на Я 

select *
from #cafe1 as c1
left join #cafe2 as c2 on c2.name = c1.name 
where c2.name like N'я%'
-- данные теряются, потому что фильтруем по левой части, а там null
-- решение - фильтруем во время джоина
select *
from #cafe1 as c1
left join #cafe2 as c2 on c2.name = c1.name and c2.name like N'я%'

----------------------------
-- right join - применяется редко, обычно пишем left join
-- какие фрукты есть в кафе2, но нет в кафе1
select *
from #cafe1 as c1
right join #cafe2 as c2 on c2.name = c1.name
--where с1.id is null

----------------------------
--full join = left join + right join
--все фрукты из cafe1, дополненные информацией из cafe2 или NULL
--все фрукты из cafe2 которые не попали в итоговую таблицу или NULL
select *
from #cafe1 as c1
full join #cafe2 as c2 on c2.name = c1.name

--------------------------------
-- "Съедание данных" LEFT JOIN
--------------------------------
SELECT
  s.SupplierID,
  s.SupplierName,
  t.SupplierTransactionID,
  t.TransactionDate,
  t.TransactionAmount
FROM Purchasing.Suppliers s
LEFT JOIN Purchasing.SupplierTransactions t ON t.SupplierID = s.SupplierID
ORDER BY s.SupplierID;

-- Добавим TransactionTypes через INNER JOIN
SELECT
  s.SupplierID,
  s.SupplierName,
  t.SupplierTransactionID,
  tt.TransactionTypeName
FROM Purchasing.Suppliers s
LEFT JOIN Purchasing.SupplierTransactions t ON t.SupplierID = s.SupplierID
INNER JOIN Application.TransactionTypes tt ON tt.TransactionTypeID = t.TransactionTypeID
ORDER BY s.SupplierID;

-- Как сделать так, чтобы данные не пропали?

SELECT
  s.SupplierID,
  s.SupplierName,
  t.SupplierTransactionID,
  tt.TransactionTypeName
FROM Purchasing.Suppliers s
LEFT JOIN Purchasing.SupplierTransactions t ON t.SupplierID = s.SupplierID
LEFT JOIN Application.TransactionTypes tt ON tt.TransactionTypeID = t.TransactionTypeID
ORDER BY s.SupplierID;


use WideWorldImporters;

drop table if exists #t1, #t2;

create table #t1 (id int identity, name varchar(1))
create table #t2 (id int identity, name varchar(1))

insert #t1 (name) values ('a'), ('b'), ('b'), (null) --множество 1
insert #t2 (name) values ('a'), ('c'), (null) --множество 2

select * from #t1 
select * from #t2 

--вывести данные 2х таблиц - в одну 
--сколько строк получится в union и union all?
--какой вариант быстрее? (Ctrl + M)
select name from #t1 --множество строк t1
union all
select name from #t2 --множество строк t2

select name from #t1 --множество строк t1
union
select name from #t2 --множество строк t2

--нужна cовместимость по типам 
select 'a' as col
union all
select 123 

--------------------
--except - вычитание
select * from #t1 
select * from #t2

--найти name из t1, которые не встречаются в t2
select name from #t1 
except 
select name from #t2

----------------
-- intersect - пересечение множества строк 2х таблиц
select * from #t1 
select * from #t2

select name from #t1 
intersect 
select name from #t2



use WideWorldImporters

-- Исходная таблица
SELECT *	
FROM Sales.Orders

-- Сколько всего строк
SELECT count(*)
      ,count(1)
	  ,count(t.BackorderOrderID)
	  --,t.ExpectedDeliveryDate as dt  --С группировкой по полю
FROM Sales.Orders t
--group by(t.ExpectedDeliveryDate) --С группировкой по полю
--order by dt


-- Работа с NULL, DISTINCT
/*source*/ 
SELECT * FROM Purchasing.SupplierTransactions ORDER BY FinalizationDate

SELECT --t.TransactionTypeID,  --С группировкой по полю
 COUNT(*) TotalRows, -- Количество строк
 COUNT(t.FinalizationDate) AS FinalizationDate_Count, -- Игнорирование NULL
 COUNT(DISTINCT t.SupplierID) AS SupplierID_DistinctCount, -- Количество уникальных значений в столбце
 COUNT(ALL t.SupplierID) AS SupplierID_AllCount, -- Количество всех значений в столбце
 SUM(t.TransactionAmount) AS TransactionAmount_SUM,
 SUM(DISTINCT t.TransactionAmount) AS TransactionAmount_SUM_DISTINCT,
 AVG(t.TransactionAmount) AS TransactionAmount_AVG, 
 MIN(t.TransactionAmount) AS TransactionAmount_MIN,
 MAX(t.TransactionAmount)AS TransactionAmount_MAX
FROM Purchasing.SupplierTransactions t
--group by t.TransactionTypeID  --С группировкой по полю


-- Использование функций (сколько формируются позиции заказа)
SELECT 
    MIN(DATEDIFF(hour, o.OrderDate, l.PickingCompletedWhen)) AS [MIN],
    AVG(DATEDIFF(hour, o.OrderDate, l.PickingCompletedWhen)) AS [AVG],    
    MAX(DATEDIFF(hour, o.OrderDate, l.PickingCompletedWhen)) AS [MAX]
FROM Sales.OrderLines l
JOIN Sales.Orders o ON o.OrderID = l.OrderID
WHERE l.PickingCompletedWhen IS NOT NULL

---- STRING_AGG = объединение полей в строку
SELECT SupplierName
FROM Purchasing.Suppliers s 
JOIN Purchasing.SupplierCategories c ON c.SupplierCategoryID = s.SupplierCategoryID

SELECT STRING_AGG(SupplierName, ', ') as fio --within group(order by SupplierName desc) as fio --сортировка
FROM Purchasing.Suppliers s 
JOIN Purchasing.SupplierCategories c ON c.SupplierCategoryID = s.SupplierCategoryID
order by fio --desc

-- Поставщики в разрезе категорий
SELECT 
  c.SupplierCategoryName,
  s.SupplierName
FROM Purchasing.Suppliers s 
JOIN Purchasing.SupplierCategories c 
  ON c.SupplierCategoryID = s.SupplierCategoryID
ORDER BY c.SupplierCategoryName, s.SupplierName;

SELECT 
  c.SupplierCategoryName AS Category,
  STRING_AGG(s.SupplierName, ', ') AS Suppliers
FROM Purchasing.Suppliers s 
JOIN Purchasing.SupplierCategories c 
  ON c.SupplierCategoryID = s.SupplierCategoryID
GROUP BY c.SupplierCategoryName;


-- Есть обратная функция STRING_SPLIT
-- https://docs.microsoft.com/ru-ru/sql/t-sql/functions/string-split-transact-sql?view=sql-server-ver15

SELECT res.value
FROM STRING_SPLIT('Lorem ipsum dolor sit amet.  ', ' ') res;

-------- Сравнение с агрегатами
-- Неправильно = КАК это расчитать???
SELECT * 
FROM Sales.OrderLines
WHERE UnitPrice * Quantity > AVG(UnitPrice * Quantity)


-------------
-- подзапрос для среднего
SELECT AVG(UnitPrice * Quantity) 
FROM Sales.OrderLines

SELECT * 
FROM Sales.OrderLines 
WHERE UnitPrice * Quantity  > 
	(SELECT 
		AVG(UnitPrice * Quantity) 
	FROM Sales.OrderLines)

--HAVING ???
SELECT UnitPrice,Quantity,AVG(UnitPrice * Quantity)
FROM Sales.OrderLines
group by UnitPrice,Quantity
HAVING UnitPrice * Quantity > AVG(UnitPrice * Quantity)

------
-- Группировка по нескольким полям, по функции, ORDER BY по агрегирующей функции
------
-- Сколько заказов собрал сотрудник по годам
SELECT 
  p.FullName,
  YEAR(o.OrderDate) AS OrderYear, 
  COUNT(*) AS OrdersCount  
FROM Sales.Orders o
JOIN Application.People p ON p.PersonID = o.PickedByPersonID
GROUP BY YEAR(o.OrderDate), p.FullName

 -- HAVING
SELECT 
  YEAR(o.OrderDate) AS OrderYear, 
  p.FullName AS PickedBy,
  COUNT(*) AS OrdersCount  
FROM Sales.Orders o
JOIN Application.People p ON p.PersonID = o.PickedByPersonID
GROUP BY YEAR(o.OrderDate), p.FullName
HAVING COUNT(*) > 1200 -- <========
ORDER BY OrdersCount DESC;

-- -- Но если условия можно написать в WHERE, то лучше писать их в WHERE
SELECT 
  YEAR(o.OrderDate) AS OrderDate, 
  COUNT(*) AS OrdersCount  
FROM Sales.Orders o
GROUP BY YEAR(o.OrderDate)
HAVING YEAR(o.OrderDate) > 2014;

-- -- с WHERE план одинаковый
SELECT 
  YEAR(o.OrderDate) AS OrderDate, 
  COUNT(*) AS OrdersCount  
FROM Sales.Orders o
WHERE YEAR(o.OrderDate) > 2014
GROUP BY YEAR(o.OrderDate);

-- GROUPING SETS
-- -- Что это такое - аналог с UNION

SELECT TOP 5 NULL AS ContactID, YEAR(o.OrderDate) AS [OrderYear], COUNT(*) AS OrderCountPerYear
FROM Sales.Orders o
GROUP BY YEAR(o.OrderDate)

UNION

SELECT TOP 5 o.ContactPersonID AS ContactID, NULL AS [OrderYear], COUNT(*) AS ContactPersonCount
FROM Sales.Orders o
GROUP BY o.ContactPersonID

-- -- GROUPING SETS 
SELECT TOP 10
  o.ContactPersonID,
  YEAR(o.OrderDate) AS OrderYear,
  COUNT(*) AS [Count]
FROM Sales.Orders o
GROUP BY GROUPING SETS (o.ContactPersonID, YEAR(o.OrderDate));


-- ROLLUP (промежуточные итоги)
-- -- запрос для проверки итоговых значений
SELECT 
  YEAR(o.OrderDate) AS OrderYear, 
  COUNT(*) AS OrdersCount  
FROM Sales.Orders o
WHERE o.PickedByPersonID IS NOT NULL
GROUP BY YEAR(o.OrderDate)
ORDER BY YEAR(o.OrderDate);

-- -- rollup
SELECT 
  YEAR(o.OrderDate) AS OrderYear, 
  p.FullName AS PickedBy,
  COUNT(*) AS OrdersCount  
FROM Sales.Orders o
JOIN Application.People p ON p.PersonID = o.PickedByPersonID
WHERE o.PickedByPersonID IS NOT NULL
GROUP BY ROLLUP (YEAR(o.OrderDate), p.FullName)
ORDER BY YEAR(o.OrderDate), p.FullName;
GO


-- ROLLUP и GROUPING
SELECT 
  grouping(YEAR(o.OrderDate)) AS OrderYear_GROUPING,
  grouping(p.FullName) AS PickedBy_GROUPING,
  YEAR(o.OrderDate) AS OrderDate, 
  p.FullName AS PickedBy,
/*  COUNT(*) AS OrdersCount,
  -- -------
  CASE grouping(YEAR(o.OrderDate)) 
    WHEN 1 THEN 'Total'
    ELSE CAST(YEAR(o.OrderDate) AS NCHAR(5))
  END AS Count_GROUPING,

  CASE grouping(p.FullName) 
    WHEN 1 THEN 'Total'
    ELSE p.FullName 
  END AS PickedBy_GROUPING,
*/
  COUNT(*) AS OrdersCount
FROM Sales.Orders o
JOIN Application.People p ON p.PersonID = o.PickedByPersonID
WHERE o.PickedByPersonID IS NOT NULL
GROUP BY ROLLUP (YEAR(o.OrderDate), p.FullName)
ORDER BY YEAR(o.OrderDate), p.FullName;

-- CUBE (тот же ROLLUP, но для всех комбинаций групп)
SELECT 
  grouping(YEAR(o.OrderDate)) AS OrderYear_GROUPING,
  grouping(p.FullName) AS PickedBy_GROUPING,
  grouping_id(YEAR(o.OrderDate),p.FullName), -- битовая маска для grouping 10 = по первому полю grouping дал 1
                                             --                            01 = по второму полю grouping дал 1
                                             --                            11 = по обоим полям  grouping дал 1 = 3(в десятичном исчислении)
  
  YEAR(o.OrderDate) AS OrderDate, 
  p.FullName AS PickedBy,
  COUNT(*) AS OrdersCount  
FROM Sales.Orders o
JOIN Application.People p ON p.PersonID = o.PickedByPersonID
WHERE o.PickedByPersonID IS NOT NULL
GROUP BY CUBE (p.FullName, YEAR(o.OrderDate))
ORDER BY YEAR(o.OrderDate), p.FullName;

--проверка на то, где можно использовать подзапросы
select (select CityID from Application.Cities cc where cc.CityID = c.CityID)
      ,c.CityName
from Application.Cities c
inner join (select * from Application.StateProvinces where StateProvinceCode='CA') a on c.StateProvinceID = a.StateProvinceID
where exists(select * from Application.StateProvinces) 
group by c.CityID, c.CityName --(select CityID from Application.Cities cc where cc.CityID = c.CityID)
having (select CityID from Application.Cities cc where cc.CityID = c.CityID) > count(*)
order by (select CityID from Application.Cities cc where cc.CityID = c.CityID)

--Про COUNT и COUNT_BIG(смотреть планы)
select count(*) as cnt
from Application.Cities
select count_big(*) as cnt
from Application.Cities



