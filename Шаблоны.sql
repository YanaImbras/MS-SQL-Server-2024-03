/*�������*/

use WideWorldImporters

-- ������ + � ����� ������� SQL ��������� ���������?
select CityName as city, count(*) as qty
from Application.Cities as c
where LastEditedBy = 1
group by CityName
having count(*) > 25
order by count(*) desc

-- ������������������ ���������� Ctrl + M
select c.CityName as city, count(*) as qty
from Application.Cities as c
where c.LastEditedBy = 1 
	and city = 'Ashport' --error
group by c.CityName
having qty > 25 --error
order by qty desc --ok

-- ��� ����� ������
select c.CityName as city1
	, city2 = c.CityName
	, c.CityName city3
	, c.CityName as [city 4]
	, c.CityName as 'city 5'
	, 'city 6' = c.CityName
from Application.Cities as c

--�������� ��� ��������� �������� ����� ��������
select c1.CityName, c2.CityName 
from Application.Cities as c1
cross join Application.Cities as c2

use WideWorldImporters --����� ����

--�������� ��������� � �������
select * from WideWorldImporters.Application.People
select * from Application.People
select * from People --���� ����� != dbo

-- * � ������������� �� ������� ��������, ����� ������� ������ �������
set statistics time, io on

select * from Sales.OrderLines       --CPU time = 453 ms,  elapsed time = 4488 ms.
select OrderID from Sales.OrderLines --CPU time = 157 ms,  elapsed time = 2216 ms.

set statistics time, io off

-- ��� ������
select CityName from Application.Cities
select distinct CityName from Application.Cities

-- ****************************************
-- ����������� ���-�� �����
-- ****************************************

select top 10 * from Application.Cities --������

-- ��� ���������� ������� �� ������������ - �� Abbott
select top 10 CityID, CityName, StateProvinceID from Application.Cities
select top 10 CityID, CityName, StateProvinceID from Application.Cities order by CityName --����� ������ ���������� 

-- ���������� �� ���������� �����
select top 10 CityID, CityName, StateProvinceID from Application.Cities order by CityName asc, StateProvinceID asc
select top 10 CityID, CityName, StateProvinceID from Application.Cities order by 2, 3 desc
--���������� ��������� ��� ���������� ������� => ����������� ����� �� ��������
select top 10 CityName, StateProvinceID, LastEditedBy from Application.Cities order by 2, 3 desc


--���-�� ����� - ����� ����������
DECLARE @n INT = 5
SELECT (TOP @n) * FROM Application.Cities

-- ****************************************
-- ������������ �������
-- ****************************************

DECLARE @m INT = 5
SELECT *
FROM Application.Cities as c
ORDER BY c.CityName ASC OFFSET 0 ROWS -- ���������� ����������� 
FETCH NEXT @m ROWS ONLY

-- ����� �������
DECLARE @pagesize BIGINT = 10, -- ������ ��������
	@pagenum BIGINT = 1;-- ����� ��������

SELECT StockItemID, StockItemName, UnitPrice
FROM Warehouse.StockItems
ORDER BY UnitPrice DESC OFFSET(@pagenum - 1) * @pagesize ROWS -- ���������� ����������� 
FETCH NEXT @pagesize ROWS ONLY

-- ****************************************
-- ����� ��������� ��������
-- ****************************************
-- SELECT TOP N WITH TIES ... - ������� N ����� + ��� ������ � ��������� ��������� �������� ����������


--������ �� �������� ����
SELECT StockItemID, StockItemName, UnitPrice
FROM Warehouse.StockItems
ORDER BY UnitPrice DESC

--������, �������� � 3�� ����� ������� �� ������ => ������ 1 ������ � ��������� ����� (285.00)
SELECT TOP 3 StockItemID, StockItemName, UnitPrice
FROM Warehouse.StockItems
ORDER BY UnitPrice DESC

-- ������� ������ � ��������� ��������� �������� ����������
-- ������� �� ������� ���������� - UnitPrice = 285.00 => 2 ������ � UnitPrice = 285.00
SELECT TOP 3 WITH TIES StockItemID, StockItemName, UnitPrice
FROM Warehouse.StockItems
ORDER BY UnitPrice DESC -- ���������� �����������!!


-- 3 ������:  ������� �� �������� ����������  - UnitPrice = 285.00, StockItemID = 73 => ������ 1 ������
SELECT TOP 3 WITH TIES StockItemID, StockItemName, UnitPrice
FROM Warehouse.StockItems
ORDER BY UnitPrice DESC,  StockItemID -- ���������� �����������!!


use WideWorldImporters;

-------------
-- where - ���������� ����� �� ������� 
-- ������� ��������� 3 ��������: true, false, unknown (������������ - ���� � ���� null)
-- � ���� ������� ������, � ������� ������� ��������� ( = true )
-------------
select Size, * from Warehouse.StockItems where 0=1 --������� �����?
select Size, * from Warehouse.StockItems where 1=1 --������� �����? 229

select Size, * from Warehouse.StockItems where Size = '1/12 scale' --9 �����
select Size, * from Warehouse.StockItems where Size != '1/12 scale' --154 ������  Size <> '1/12 scale'
--���������: Size = null
select Size, * from Warehouse.StockItems where Size = null --���������� ��������� != TRUE


-- null � where: is null, is not null
select Size, * from Warehouse.StockItems where Size is null

-- null � �������: isnull(), coalesce()
-- coalisce () - ����� ������� �� null-��������
select Size, ColorId, isnull(Size, 0) as [isnull], coalesce(Size, ColorId, -10) as [coalesce]
from Warehouse.StockItems 
where Size is null


-- isnull() - �������������� � ���� 1�� ��������� 
-- coalesce() - ��� ������ �����������
select val, isnull(val, 1.4) as [isnull], coalesce(val, 1.4) as [coalesce]
from (
	select 1 as val
	union all 
	select null
) t

-------------
-- ������� � WHERE
-------------

SELECT OrderID, OrderDate, year(OrderDate)
FROM Sales.Orders o
WHERE year(OrderDate) = 2013
-- �� ��� ����� �� ������ (�� ����� �������������� ������ (���� �� �����-������ ��������)).

-- ����� ����� BETWEEN
SELECT OrderDate, OrderID
FROM Sales.Orders o
WHERE OrderDate BETWEEN '2013-01-01' AND '2013-12-31'

-- WHERE �� ���������
SELECT  OrderLineID AS [Order Line ID], Quantity, UnitPrice, (Quantity * UnitPrice) AS [TotalCost]
FROM Sales.OrderLines
WHERE (Quantity * UnitPrice) > 1000

--like 
select * from Warehouse.StockItems where StockItemName like 'USB%' -- ����������
select * from Warehouse.StockItems where StockItemName like '%USB%' --��� ������ USB
select * from Warehouse.StockItems where StockItemName like '%USB' -- �������������

-------------
-- ��������� �������: AND, OR, NOT
-------------
-- ������� StockItems, ��� ���� �� 350 �� 500 � �������� ���������� � USB ��� Ride

-- ������ ������ ������ � ����� < 350? 
select RecommendedRetailPrice, *
from Warehouse.StockItems
where
    RecommendedRetailPrice between 350 and 500 --���� �� 350 �� 500
	AND StockItemName like 'USB%' --�������� ���������� � USB
 	OR StockItemName like 'Ride%' --�������� ���������� � Ride


--pgdn







-- AND, OR - ���� ����������� ���������� - ������� ��� AND, ����� OR
-- ����� ���������� - ������
select RecommendedRetailPrice, *
from Warehouse.StockItems
where
    RecommendedRetailPrice between 350 and 500 --���� �� 350 �� 500
	and (StockItemName like 'USB%' --�������� ���������� � USB
    or StockItemName like 'Ride%') --�������� ���������� � Ride

-------------
--������ � ������
-------------
declare @dt datetime = getdate()
select year(@dt) as [���]  
	, [�����] = month(@dt)
	, datepart(quarter, @dt) as '�������'
	, datename(month, @dt) as "����� "
	, FORMAT(@dt, 'MMMM', 'ru-ru') as [����� Ru]
	, FORMAT(@dt, 'D', 'ru-ru') as 'Russian'
	, FORMAT(@dt, 'D', 'en-US' ) 'US English'  
	, convert(varchar, @dt, 104) as [����] 
	, datetrunc(month, @dt) as begin_of_month  --c SQL2022 ������ ������
	, eomonth(@dt) as end_of_month

--���� � ������� where - ������ ������ 'yyyyMMdd' ��� 'yyyy-mm-dd'
select OrderDate from Sales.Orders where OrderDate = '20150502'
select OrderDate from Sales.Orders where OrderDate = '02.05.2015' --������ ������ ���-��?


select @@language, FORMAT(cast('02.05.2015' as date), 'D', 'ru-ru') 

SET LANGUAGE 'Russian' --�� ������ ������
select @@language, FORMAT(cast('02.05.2015' as date), 'D', 'ru-ru') 

SET LANGUAGE 'English' --����� �������
select @@language, FORMAT(cast('02.05.2015' as date), 'D', 'ru-ru') 

-- ���������� ������������� ������ 'yyyyMMdd' ��� 'yyyy-mm-dd'


use WideWorldImporters;
-- ����������� + gif

----------------------------
-- ��� ������, �� ������ ���� ���������
-- ������ ��������� ������ �������
select top 5 * from Sales.Orders -- Alt + F1 -- ������ �������� fk 
-- FK_Sales_Orders_CustomerID_Sales_Customers => Sales_Orders_CustomerID = Sales_Customers.?
select top 5 * from Sales.Customers

select top 5 * 
from Sales.Orders as o
join Sales.Customers as c on c.CustomerID = o.CustomerID --o.CustomerID is not null => inner join (������ �� ��������) 


----------------------------
drop table if exists #cafe1, #cafe2
create table #cafe1 (id int identity, name nvarchar(10))
create table #cafe2 (id int identity, name nvarchar(10))

insert #cafe1 (name) values(N'������'), (N'�����'), (N'������')
insert #cafe2 (name) values(N'������'), (N'�����'), (null)

select * from #cafe1
select * from #cafe2

----------------------------
-- cross join -��� ���������� �� ����� ���� ������
select *
from #cafe1 as c1
cross join #cafe2 as c2 

-- ��� ���
select *
from #cafe1 as c1
, #cafe2 as c2 


--������� ������: ��������� ��� ��������� �������� �������� ����� �� 2� ������� ��� ����1

--������
select c1.name, c2.name 
from #cafe1 as c1
cross join #cafe1 as c2 

--��� �������
select name, name 
from #cafe1
cross join #cafe1

----------------------------
-- inner join - ���������� ���������� �� ������� (����� �������)
-- ������� ������: ����� ������, ������� ���� � ����1 � ����2
select * from #cafe1
select * from #cafe2

select c1.name, c2.name 
from #cafe1 as c1
inner join #cafe2 as c2 on c2.name = c1.name

-- ��� ���
select c1.name, c2.name 
from #cafe1 as c1
join #cafe2 as c2 on c2.name = c1.name


--�������� - ���� ��������� ������� �� ������������� ����
--������� �����
insert #cafe1 (name) values(N'������')
insert #cafe2 (name) values(N'������')

select * from #cafe1
select * from #cafe2

--������� ������� ���� � ����� ����?
--� ������� ����� ������ ������?
select c1.name, c2.name 
from #cafe1 as c1
inner join #cafe2 as c2 on c2.name = c1.name


--������ ����� (�� ������ ��� ��������)
delete from #cafe1 where id = 4
delete from #cafe2 where id = 4

select * from #cafe1
select * from #cafe2

----------------------------
-- left join
-- ������� ������: ����� ������ ���� � ����1, �� ��� � ����2
-- ����� ������ � where ������, ����� ������������� ���������� ������� � ����2
select *
from #cafe1 as c1
left join #cafe2 as c2 on c2.name = c1.name



--��������� ������ ������� �� ����1 ������� �� ������� �� ����2, �������� ������� ���������� �� � 

select *
from #cafe1 as c1
left join #cafe2 as c2 on c2.name = c1.name 
where c2.name like N'�%'
-- ������ ��������, ������ ��� ��������� �� ����� �����, � ��� null
-- ������� - ��������� �� ����� ������
select *
from #cafe1 as c1
left join #cafe2 as c2 on c2.name = c1.name and c2.name like N'�%'

----------------------------
-- right join - ����������� �����, ������ ����� left join
-- ����� ������ ���� � ����2, �� ��� � ����1
select *
from #cafe1 as c1
right join #cafe2 as c2 on c2.name = c1.name
--where �1.id is null

----------------------------
--full join = left join + right join
--��� ������ �� cafe1, ����������� ����������� �� cafe2 ��� NULL
--��� ������ �� cafe2 ������� �� ������ � �������� ������� ��� NULL
select *
from #cafe1 as c1
full join #cafe2 as c2 on c2.name = c1.name

--------------------------------
-- "�������� ������" LEFT JOIN
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

-- ������� TransactionTypes ����� INNER JOIN
SELECT
  s.SupplierID,
  s.SupplierName,
  t.SupplierTransactionID,
  tt.TransactionTypeName
FROM Purchasing.Suppliers s
LEFT JOIN Purchasing.SupplierTransactions t ON t.SupplierID = s.SupplierID
INNER JOIN Application.TransactionTypes tt ON tt.TransactionTypeID = t.TransactionTypeID
ORDER BY s.SupplierID;

-- ��� ������� ���, ����� ������ �� �������?

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

insert #t1 (name) values ('a'), ('b'), ('b'), (null) --��������� 1
insert #t2 (name) values ('a'), ('c'), (null) --��������� 2

select * from #t1 
select * from #t2 

--������� ������ 2� ������ - � ���� 
--������� ����� ��������� � union � union all?
--����� ������� �������? (Ctrl + M)
select name from #t1 --��������� ����� t1
union all
select name from #t2 --��������� ����� t2

select name from #t1 --��������� ����� t1
union
select name from #t2 --��������� ����� t2

--����� c������������ �� ����� 
select 'a' as col
union all
select 123 

--------------------
--except - ���������
select * from #t1 
select * from #t2

--����� name �� t1, ������� �� ����������� � t2
select name from #t1 
except 
select name from #t2

----------------
-- intersect - ����������� ��������� ����� 2� ������
select * from #t1 
select * from #t2

select name from #t1 
intersect 
select name from #t2



use WideWorldImporters

-- �������� �������
SELECT *	
FROM Sales.Orders

-- ������� ����� �����
SELECT count(*)
      ,count(1)
	  ,count(t.BackorderOrderID)
	  --,t.ExpectedDeliveryDate as dt  --� ������������ �� ����
FROM Sales.Orders t
--group by(t.ExpectedDeliveryDate) --� ������������ �� ����
--order by dt


-- ������ � NULL, DISTINCT
/*source*/ 
SELECT * FROM Purchasing.SupplierTransactions ORDER BY FinalizationDate

SELECT --t.TransactionTypeID,  --� ������������ �� ����
 COUNT(*) TotalRows, -- ���������� �����
 COUNT(t.FinalizationDate) AS FinalizationDate_Count, -- ������������� NULL
 COUNT(DISTINCT t.SupplierID) AS SupplierID_DistinctCount, -- ���������� ���������� �������� � �������
 COUNT(ALL t.SupplierID) AS SupplierID_AllCount, -- ���������� ���� �������� � �������
 SUM(t.TransactionAmount) AS TransactionAmount_SUM,
 SUM(DISTINCT t.TransactionAmount) AS TransactionAmount_SUM_DISTINCT,
 AVG(t.TransactionAmount) AS TransactionAmount_AVG, 
 MIN(t.TransactionAmount) AS TransactionAmount_MIN,
 MAX(t.TransactionAmount)AS TransactionAmount_MAX
FROM Purchasing.SupplierTransactions t
--group by t.TransactionTypeID  --� ������������ �� ����


-- ������������� ������� (������� ����������� ������� ������)
SELECT 
    MIN(DATEDIFF(hour, o.OrderDate, l.PickingCompletedWhen)) AS [MIN],
    AVG(DATEDIFF(hour, o.OrderDate, l.PickingCompletedWhen)) AS [AVG],    
    MAX(DATEDIFF(hour, o.OrderDate, l.PickingCompletedWhen)) AS [MAX]
FROM Sales.OrderLines l
JOIN Sales.Orders o ON o.OrderID = l.OrderID
WHERE l.PickingCompletedWhen IS NOT NULL

---- STRING_AGG = ����������� ����� � ������
SELECT SupplierName
FROM Purchasing.Suppliers s 
JOIN Purchasing.SupplierCategories c ON c.SupplierCategoryID = s.SupplierCategoryID

SELECT STRING_AGG(SupplierName, ', ') as fio --within group(order by SupplierName desc) as fio --����������
FROM Purchasing.Suppliers s 
JOIN Purchasing.SupplierCategories c ON c.SupplierCategoryID = s.SupplierCategoryID
order by fio --desc

-- ���������� � ������� ���������
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


-- ���� �������� ������� STRING_SPLIT
-- https://docs.microsoft.com/ru-ru/sql/t-sql/functions/string-split-transact-sql?view=sql-server-ver15

SELECT res.value
FROM STRING_SPLIT('Lorem ipsum dolor sit amet.  ', ' ') res;

-------- ��������� � ����������
-- ����������� = ��� ��� ���������???
SELECT * 
FROM Sales.OrderLines
WHERE UnitPrice * Quantity > AVG(UnitPrice * Quantity)


-------------
-- ��������� ��� ��������
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
-- ����������� �� ���������� �����, �� �������, ORDER BY �� ������������ �������
------
-- ������� ������� ������ ��������� �� �����
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

-- -- �� ���� ������� ����� �������� � WHERE, �� ����� ������ �� � WHERE
SELECT 
  YEAR(o.OrderDate) AS OrderDate, 
  COUNT(*) AS OrdersCount  
FROM Sales.Orders o
GROUP BY YEAR(o.OrderDate)
HAVING YEAR(o.OrderDate) > 2014;

-- -- � WHERE ���� ����������
SELECT 
  YEAR(o.OrderDate) AS OrderDate, 
  COUNT(*) AS OrdersCount  
FROM Sales.Orders o
WHERE YEAR(o.OrderDate) > 2014
GROUP BY YEAR(o.OrderDate);

-- GROUPING SETS
-- -- ��� ��� ����� - ������ � UNION

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


-- ROLLUP (������������� �����)
-- -- ������ ��� �������� �������� ��������
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


-- ROLLUP � GROUPING
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

-- CUBE (��� �� ROLLUP, �� ��� ���� ���������� �����)
SELECT 
  grouping(YEAR(o.OrderDate)) AS OrderYear_GROUPING,
  grouping(p.FullName) AS PickedBy_GROUPING,
  grouping_id(YEAR(o.OrderDate),p.FullName), -- ������� ����� ��� grouping 10 = �� ������� ���� grouping ��� 1
                                             --                            01 = �� ������� ���� grouping ��� 1
                                             --                            11 = �� ����� �����  grouping ��� 1 = 3(� ���������� ����������)
  
  YEAR(o.OrderDate) AS OrderDate, 
  p.FullName AS PickedBy,
  COUNT(*) AS OrdersCount  
FROM Sales.Orders o
JOIN Application.People p ON p.PersonID = o.PickedByPersonID
WHERE o.PickedByPersonID IS NOT NULL
GROUP BY CUBE (p.FullName, YEAR(o.OrderDate))
ORDER BY YEAR(o.OrderDate), p.FullName;

--�������� �� ��, ��� ����� ������������ ����������
select (select CityID from Application.Cities cc where cc.CityID = c.CityID)
      ,c.CityName
from Application.Cities c
inner join (select * from Application.StateProvinces where StateProvinceCode='CA') a on c.StateProvinceID = a.StateProvinceID
where exists(select * from Application.StateProvinces) 
group by c.CityID, c.CityName --(select CityID from Application.Cities cc where cc.CityID = c.CityID)
having (select CityID from Application.Cities cc where cc.CityID = c.CityID) > count(*)
order by (select CityID from Application.Cities cc where cc.CityID = c.CityID)

--��� COUNT � COUNT_BIG(�������� �����)
select count(*) as cnt
from Application.Cities
select count_big(*) as cnt
from Application.Cities



