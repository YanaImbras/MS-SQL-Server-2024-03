/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "06 - Оконные функции".

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
-- ---------------------------------------------------------------------------

USE WideWorldImporters
/*
1. Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года 
(в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки).
Выведите: id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом

Пример:
-------------+----------------------------
Дата продажи | Нарастающий итог по месяцу
-------------+----------------------------
 2015-01-29   | 4801725.31
 2015-01-30	 | 4801725.31
 2015-01-31	 | 4801725.31
 2015-02-01	 | 9626342.98
 2015-02-02	 | 9626342.98
 2015-02-03	 | 9626342.98
Продажи можно взять из таблицы Invoices.
Нарастающий итог должен быть без оконной функции.
*/

Select
 sil.InvoiceID as [id продажи]
, si.InvoiceDate as [дату продажи]
, sc.CustomerName as [название клиента]
, sum(sil.UnitPrice) as [сумму продажи]
,(
select
sum(sil1.UnitPrice)
from Sales.InvoiceLines as sil1
join Sales.Invoices as si1 on si1.InvoiceID=sil1.InvoiceID
where DATEPART(year, si1.InvoiceDate) <= DATEPART(year, si.InvoiceDate)          
and DATEPART(month, si1.InvoiceDate) <= DATEPART(month, si.InvoiceDate)
and si1.InvoiceDate >= '2015-01-01'
) as [сумму нарастающим итогом]
from Sales.Invoices as si
join Sales.Customers as sc on sc.CustomerID=si.CustomerID
join Sales.InvoiceLines as sil on sil.InvoiceID=si.InvoiceID
where si.InvoiceDate >= '2015-01-01'
Group by sil.InvoiceID, si.InvoiceDate, sc.CustomerName
Order by sil.InvoiceID, si.InvoiceDate


go


/*
2. Сделайте расчет суммы нарастающим итогом в предыдущем запросе с помощью оконной функции.
   Сравните производительность запросов 1 и 2 с помощью set statistics time, io on
*/

Select
 sil.InvoiceID as [id продажи]
, si.InvoiceDate as [дату продажи]
, sc.CustomerName as [название клиента]
, sum(sil.UnitPrice) as [сумму продажи]
,SUM(SUM(sil.[UnitPrice])) OVER (Order by DATEPART(year, si.InvoiceDate), DATEPART(month, si.InvoiceDate)) as [сумму нарастающим итогом]
from Sales.Invoices as si
join Sales.Customers as sc on sc.CustomerID=si.CustomerID
join Sales.InvoiceLines as sil on sil.InvoiceID=si.InvoiceID
where si.InvoiceDate >= '2015-01-01'
Group by sil.InvoiceID, si.InvoiceDate, sc.CustomerName
Order by sil.InvoiceID, si.InvoiceDate


go

/*
3. Вывести список 2х самых популярных продуктов (по количеству проданных) 
в каждом месяце за 2016 год (по 2 самых популярных продукта в каждом месяце).
*/

With SEO
as (
select
 sol.[Description] as [название продукта]
 ,ROW_NUMBER() OVER(PARTITION BY MONTH(si.InvoiceDate) Order by SUM(sil.Quantity) desc) as [Num]
 ,MONTH(si.InvoiceDate) as [месяц]
from Sales.Invoices as si
join Sales.InvoiceLines as sil on sil.InvoiceID=si.InvoiceID
join Sales.OrderLines as sol on sol.OrderID = si.OrderID
where YEAR(si.InvoiceDate) = 2016
Group by sol.[Description], MONTH(si.InvoiceDate)
)
Select 
SEO.[название продукта]
, SEO.месяц
from SEO
where SEO.[Num] <= 2
Order by SEO.месяц, SEO.[название продукта]


With SEO
as (
select
 sol.[Description] as [название продукта]
 ,ROW_NUMBER() OVER(PARTITION BY MONTH(si.InvoiceDate) Order by SUM(sil.Quantity) desc) as [Num]
 ,MONTH(si.InvoiceDate) as [месяц]
from Sales.Invoices as si
join Sales.InvoiceLines as sil on sil.InvoiceID=si.InvoiceID
join Sales.OrderLines as sol on sol.OrderID = si.OrderID
where YEAR(si.InvoiceDate) = 2015
Group by sol.[Description], MONTH(si.InvoiceDate)
)
Select 
SEO.[название продукта]
,SEO.[месяц]
from SEO
where SEO.[Num] <= 2
Order by SEO.[месяц], SEO.[название продукта]

/*
4. Функции одним запросом
Посчитайте по таблице товаров (в вывод также должен попасть ид товара, название, брэнд и цена):
* пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
* посчитайте общее количество товаров и выведете полем в этом же запросе
* посчитайте общее количество товаров в зависимости от первой буквы названия товара
* отобразите следующий id товара исходя из того, что порядок отображения товаров по имени 
* предыдущий ид товара с тем же порядком отображения (по имени)
* названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
* сформируйте 30 групп товаров по полю вес товара на 1 шт

Для этой задачи НЕ нужно писать аналог без аналитических функций.
*/

Select StockItemID, StockItemName, Brand, UnitPrice,
ROW_NUMBER() OVER(PARTITION BY LEFT(StockItemName, 1) ORDER BY StockItemName),
Count(*) Over()
,COUNT(*) OVER(PARTITION BY LEFT(StockItemName, 1))
,LEAD(StockItemID,1,0) OVER(ORDER BY StockItemName)
,LAG(StockItemID,1,0) OVER(ORDER BY StockItemName)
,LAG(StockItemName,2,'No items') OVER(ORDER BY StockItemName)
,NTILE(30)OVER(Order BY TypicalWeightPerUnit) [GROUP_30]
from Warehouse.StockItems
Order BY StockItemName


go

/*
5. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал.
   В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки.
*/

With SEO
as (
select 
 si.CustomerID 
 ,si.SalespersonPersonID 
 ,sct.TransactionDate
 ,sct.InvoiceID
 ,sct.TransactionAmount
 ,ROW_NUMBER() OVER(PARTITION BY si.SalespersonPersonID Order by sct.TransactionDate desc,  sct.InvoiceID desc) as [Num]
from Sales.CustomerTransactions sct
join Sales.Invoices si on sct.InvoiceID = si.InvoiceID
)

Select 
ap.PersonID as [ид сотрудника]
,ap.FullName as [фамилия сотрудника]
,sc.CustomerID as [ид клиента]
,sc.CustomerName as [название клиента]
,SEO.TransactionDate as [дата продажи]
,SEO.TransactionAmount as [сумму сделки]
from SEO
join Application.People ap on SEO.SalespersonPersonID = ap.PersonID
join Sales.Customers sc on SEO.CustomerID = sc.CustomerID
where SEO.[Num] = 1


go

/*
6. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
*/

With SEO
as (
select
 sol.[Description] as [название продукта]
 ,si.CustomerID as [ид клиета]
 ,sc.CustomerName as [название клиета]
 ,si.InvoiceDate as [дата покупки]
 ,sil.UnitPrice as [цена]
 ,ROW_NUMBER() OVER(PARTITION BY si.CustomerID order by sil.UnitPrice desc) as [Num]
from Sales.Invoices as si
join Sales.InvoiceLines as sil on sil.InvoiceID=si.InvoiceID
join Sales.OrderLines as sol on sol.OrderID = si.OrderID
join Sales.Customers sc on si.CustomerID = sc.CustomerID
Group by sol.[Description], si.CustomerID, sc.CustomerName, si.InvoiceDate, sil.UnitPrice
)
Select 
SEO.[название продукта]
 ,SEO.[ид клиета]
 ,SEO.[название клиета]
 ,SEO.[дата покупки]
 ,SEO.[цена]
from SEO
where SEO.[Num] <= 2


--Опционально можете для каждого запроса без оконных функций сделать вариант запросов с оконными функциями и сравнить их производительность. 