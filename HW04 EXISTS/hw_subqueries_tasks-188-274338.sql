/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "03 - Подзапросы, CTE, временные таблицы".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- Для всех заданий, где возможно, сделайте два варианта запросов:
--  1) через вложенный запрос
--  2) через WITH (для производных таблиц)
-- ---------------------------------------------------------------------------

USE WideWorldImporters


/*
1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), 
и не сделали ни одной продажи 04 июля 2015 года. 
Вывести ИД сотрудника и его полное имя. 
Продажи смотреть в таблице Sales.Invoices.
*/

with TotalSalesCountCTE 
		as 
		(
SELECT 
	PersonId
	, FullName
	, (
		SELECT COUNT(InvoiceId) AS SalesCount
		FROM Sales.Invoices
		WHERE Invoices.SalespersonPersonID = People.PersonID -- зависимость от основного запроса
		and Sales.Invoices.InvoiceDate = '20150704'
		) AS TotalSalesCount
FROM Application.People
WHERE IsSalesperson = 1
		)

Select
*
from TotalSalesCountCTE 
where TotalSalesCount = 0;



/*
2. Выберите товары с минимальной ценой (подзапросом). Сделайте два варианта подзапроса. 
Вывести: ИД товара, наименование товара, цена.
*/

select  top 1
	sol.OrderLineID
	, sol.Description
	, (
		select
		min (sol1.UnitPrice)
		from Sales.OrderLines as sol1
		where sol1.OrderLineID=sol.OrderLineID
		) as [Минимальная цена]
from Sales.OrderLines as sol
order by [Минимальная цена], sol.OrderLineID

/*2 Вариант*/
select  top 1
	sol.OrderLineID
	, sol.Description
	, min (sol.UnitPrice) as [Минимальная цена]
from Sales.OrderLines as sol
group by sol.UnitPrice, sol.OrderLineID, sol.Description
order by [Минимальная цена]

/*3 Вариант*/
select  top 1
	sol.OrderLineID
	, sol.Description
	, sol.UnitPrice
from Sales.OrderLines as sol
where exists(
		select 
		min (sol1.UnitPrice)
		from Sales.OrderLines as sol1
		where sol1.OrderLineID=sol.OrderLineID
		)
order by sol.UnitPrice


/*
3. Выберите информацию по клиентам, которые перевели компании пять максимальных платежей 
из Sales.CustomerTransactions. 
Представьте несколько способов (в том числе с CTE). 
*/

/* Вариант 1*/

Select
*
, sc.CustomerName
From (
SELECT 
	CustomerID
	,ROW_NUMBER() OVER(order by TransactionAmount desc) 
    AS R
FROM Sales.CustomerTransactions
) as t
join Sales.Customers as sc on sc.CustomerID = t.CustomerID
Where t.R <= 5;

/* Вариант 2*/

WITH RankedTransactions AS 
	(SELECT 
	 sct.CustomerID
	 , sc.CustomerName
	, TransactionAmount
	, RANK() OVER (ORDER BY TransactionAmount DESC) AS Rank    
	FROM Sales.CustomerTransactions as sct
	join Sales.Customers as sc on sc.CustomerID = sct.CustomerID
	)

SELECT 
CustomerID
, CustomerName
, TransactionAmount
FROM RankedTransactions 
WHERE Rank <= 5;

/* Вариант 3*/

WITH TopTransactions AS 
	(
	SELECT TOP 5 
	sct.CustomerID
	, sc.CustomerName
	, TransactionAmount
		FROM Sales.CustomerTransactions  as sct
	join Sales.Customers as sc on sc.CustomerID = sct.CustomerID  
		ORDER BY TransactionAmount DESC
	)

SELECT 
	CustomerID
	, CustomerName
	, TransactionAmount
FROM TopTransactions;


/*
4. Выберите города (ид и название), в которые были доставлены товары, 
входящие в тройку самых дорогих товаров, а также имя сотрудника, 
который осуществлял упаковку заказов (PackedByPersonID).
*/


WITH RankedTransactions AS 
	(SELECT distinct
	 wsi.StockItemID 
	 ,wsi.UnitPrice
	, ROW_NUMBER() OVER(order by wsi.UnitPrice desc) AS [ROW]    
from [Warehouse].[StockItems] as wsi
group by wsi.StockItemID, wsi.UnitPrice 
	)

SELECT  distinct
so.CustomerID
, so.PickedByPersonID
, ap.FullName
, ac.CityID as [ID Города]
, ac.CityName as [Город]
, RT.UnitPrice
FROM RankedTransactions as RT
left join [Warehouse].[StockItems] as wsi on wsi.StockItemID = RT.StockItemID
left join Sales.OrderLines as l on l.StockItemID =wsi.StockItemID
left join Sales.Orders as so on so.OrderID=l.OrderID 
left join Sales.Customers as sc on sc.CustomerID=so.CustomerID
left join [Application].[Cities] as ac on ac.CityID=sc.DeliveryCityID
left join [Application].[People] as ap on ap.PersonID = so.PickedByPersonID
WHERE [ROW] <= 3
order by RT.UnitPrice desc;

-- ---------------------------------------------------------------------------
-- Опциональное задание
-- ---------------------------------------------------------------------------
-- Можно двигаться как в сторону улучшения читабельности запроса, 
-- так и в сторону упрощения плана\ускорения. 
-- Сравнить производительность запросов можно через SET STATISTICS IO, TIME ON. 
-- Если знакомы с планами запросов, то используйте их (тогда к решению также приложите планы). 
-- Напишите ваши рассуждения по поводу оптимизации. 

-- 5. Объясните, что делает и оптимизируйте запрос

SELECT 
	Invoices.InvoiceID, 
	Invoices.InvoiceDate,
	(SELECT People.FullName
		FROM Application.People
		WHERE People.PersonID = Invoices.SalespersonPersonID
	) AS SalesPersonName,
	SalesTotals.TotalSumm AS TotalSummByInvoice, 
	(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
		FROM Sales.OrderLines
		WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
			FROM Sales.Orders
			WHERE Orders.PickingCompletedWhen IS NOT NULL	
				AND Orders.OrderId = Invoices.OrderId)	
	) AS TotalSummForPickedItems
FROM Sales.Invoices 
	JOIN
	(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
		ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC


