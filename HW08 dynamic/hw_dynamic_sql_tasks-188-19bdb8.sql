/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "07 - Динамический SQL".

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

Это задание из занятия "Операторы CROSS APPLY, PIVOT, UNPIVOT."
Нужно для него написать динамический PIVOT, отображающий результаты по всем клиентам.
Имя клиента указывать полностью из поля CustomerName.

Требуется написать запрос, который в результате своего выполнения 
формирует сводку по количеству покупок в разрезе клиентов и месяцев.
В строках должны быть месяцы (дата начала месяца), в столбцах - клиенты.

Дата должна иметь формат dd.mm.yyyy, например, 25.12.2019.

Пример, как должны выглядеть результаты:
-------------+--------------------+--------------------+----------------+----------------------
InvoiceMonth | Aakriti Byrraju    | Abel Spirlea       | Abel Tatarescu | ... (другие клиенты)
-------------+--------------------+--------------------+----------------+----------------------
01.01.2013   |      3             |        1           |      4         | ...
01.02.2013   |      7             |        3           |      4         | ...
-------------+--------------------+--------------------+----------------+----------------------
*/

declare @dml as nvarchar(max)
declare @ColumnName as nvarchar(max)

select @ColumnName = isnull(@ColumnName + ',', '') + QUOTENAME(NAMES)
from 
(
	select distinct 
	c.CustomerName as NAMES
	from Sales.Invoices as i
	join Sales.Customers as c on c.CustomerID = i.CustomerID
) as t

select @ColumnName as ColumnName

set @dml = N'Select InvoiceMonth, ' + @ColumnName + ' from 
(
select  
  CONVERT(nvarchar,CAST(DATEADD(month,DATEDIFF(month,0,i.InvoiceDate),0) as date),104) as InvoiceMonth, 
  i.InvoiceID as numberpurchases, 
  c.CustomerName as NAMES 
from Sales.Invoices as i 
join Sales.Customers as c on c.CustomerID = i.CustomerID 
  ) as t 
pivot(count(numberpurchases) for NAMES in (' + @ColumnName + ')) as pvttable 
order by InvoiceMonth;';

select @dml as command;
exec sp_executesql @dml
