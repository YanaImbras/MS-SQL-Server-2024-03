/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "05 - Операторы CROSS APPLY, PIVOT, UNPIVOT".

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
1. Требуется написать запрос, который в результате своего выполнения 
формирует сводку по количеству покупок в разрезе клиентов и месяцев.
В строках должны быть месяцы (дата начала месяца), в столбцах - клиенты.

Клиентов взять с ID 2-6, это все подразделение Tailspin Toys.
Имя клиента нужно поменять так чтобы осталось только уточнение.
Например, исходное значение "Tailspin Toys (Gasport, NY)" - вы выводите только "Gasport, NY".
Дата должна иметь формат dd.mm.yyyy, например, 25.12.2019.

Пример, как должны выглядеть результаты:
-------------+--------------------+--------------------+-------------+--------------+------------
InvoiceMonth | Peeples Valley, AZ | Medicine Lodge, KS | Gasport, NY | Sylvanite, MT | Jessie, ND
-------------+--------------------+--------------------+-------------+--------------+------------
01.01.2013   |      3             |        1           |      4      |      2        |     2
01.02.2013   |      7             |        3           |      4      |      2        |     1
-------------+--------------------+--------------------+-------------+--------------+------------
*/

Select 
InvoiceMonth
,[Tailspin Toys (Peeples Valley, AZ)] as [Peeples Valley, AZ]
,[Tailspin Toys (Medicine Lodge, KS)] as [Medicine Lodge, KS]
,[Tailspin Toys (Gasport, NY)] as [Gasport, NY]
,[Tailspin Toys (Sylvanite, MT)] as [Sylvanite, MT]
,[Tailspin Toys (Jessie, ND)] as [Jessie, ND] 
from
(
select   
FORMAT(DATEADD(MM, DATEDIFF(MM, 0, si.InvoiceDate), 0), 'dd.MM.yyyy') as InvoiceMonth
,(
select sc.CustomerName 
from Sales.Customers sc 
where sc.CustomerID = si.CustomerID
) as CustomerName
from Sales.Invoices si
where si.CustomerID  between 2 and 6
) as st
PIVOT 
(
count (CustomerName) 
for CustomerName
in ([Tailspin Toys (Sylvanite, MT)],[Tailspin Toys (Peeples Valley, AZ)],[Tailspin Toys (Medicine Lodge, KS)],[Tailspin Toys (Gasport, NY)],[Tailspin Toys (Jessie, ND)])
) as pt
order by year(InvoiceMonth), month(InvoiceMonth)


go
/*
2. Для всех клиентов с именем, в котором есть "Tailspin Toys"
вывести все адреса, которые есть в таблице, в одной колонке.

Пример результата:
----------------------------+--------------------
CustomerName                | AddressLine
----------------------------+--------------------
Tailspin Toys (Head Office) | Shop 38
Tailspin Toys (Head Office) | 1877 Mittal Road
Tailspin Toys (Head Office) | PO Box 8975
Tailspin Toys (Head Office) | Ribeiroville
----------------------------+--------------------
*/

Select 
CustomerName
,AddressLine
from(
select CustomerName
,DeliveryAddressLine1
,DeliveryAddressLine2
,PostalAddressLine1
,PostalAddressLine2 
from Sales.Customers
where CustomerName Like '%Tailspin Toys%'	
) as Customers
UNPIVOT (AddressLine for Name in (DeliveryAddressLine1, DeliveryAddressLine2, PostalAddressLine1, PostalAddressLine2)) as t

go

/*
3. В таблице стран (Application.Countries) есть поля с цифровым кодом страны и с буквенным.
Сделайте выборку ИД страны, названия и ее кода так, 
чтобы в поле с кодом был либо цифровой либо буквенный код.

Пример результата:
--------------------------------
CountryId | CountryName | Code
----------+-------------+-------
1         | Afghanistan | AFG
1         | Afghanistan | 4
3         | Albania     | ALB
3         | Albania     | 8
----------+-------------+-------
*/

Select 
CountryID
,CountryName
,Code
from
(
select 
CountryID
,CountryName
,CAST(IsoAlpha3Code AS NVARCHAR) as Alpha3Code
,CAST(IsoNumericCode AS NVARCHAR) as NumericCode
from Application.Countries
) as Country
	UNPIVOT (Code for Name in (Alpha3Code, NumericCode)) as t

go
/*
4. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
*/

With SEO
as (
select
si.CustomerID as [ид клиета]
 ,sc.CustomerName as [название клиета]
 ,sil.StockItemID as [ид товара]
 ,si.InvoiceDate as [дата покупки]
 ,sil.UnitPrice as [цена]
 ,ROW_NUMBER() OVER(PARTITION BY si.CustomerID order by sil.UnitPrice desc) as [Num]
from Sales.Invoices as si
join Sales.InvoiceLines as sil on sil.InvoiceID=si.InvoiceID
join Sales.Customers sc on si.CustomerID = sc.CustomerID
Group by sil.StockItemID, si.CustomerID, sc.CustomerName, si.InvoiceDate, sil.UnitPrice
)
Select 
 SEO.[ид клиета]
 ,SEO.[название клиета]
 ,SEO.[ид товара]
 ,SEO.[дата покупки]
 ,SEO.[цена]
from SEO
where SEO.[Num] <= 2

go

Select
 sc.CustomerID as [ид клиета]
 ,sc.CustomerName as [название клиета]
 ,t.StockItemID as [ид товара]
 ,t.InvoiceDate as [дата покупки]
 ,t.UnitPrice as [цена]
from Sales.Customers as sc
CROSS APPLY(
select top 2 
si.CustomerID 
,(
select sc.CustomerName 
from Sales.Customers as sc 
where sc.CustomerID = si.CustomerID
) as CustomerName
,sil.StockItemID
,sil.UnitPrice
,si.InvoiceDate
from Sales.Invoices si
join Sales.InvoiceLines sil on si.invoiceId = sil.InvoiceID
where si.CustomerID = sc.CustomerID
Order by sil.UnitPrice desc 
) as t
