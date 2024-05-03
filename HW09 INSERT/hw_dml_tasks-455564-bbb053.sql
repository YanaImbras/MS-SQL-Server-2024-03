/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "10 - Операторы изменения данных".

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

DROP TABLE IF EXISTS Sales.Customers_Copy;

SELECT top 10 * INTO Sales.Customers_Copy
FROM Sales.Customers;

SELECT * FROM Sales.Customers_Copy

/*
1. Довставлять в базу пять записей используя insert в таблицу Customers или Suppliers 
*/

DROP TABLE IF EXISTS Sales.Customers_Copy;

SELECT 
	[CustomerID]
	,[CustomerName]
	,[BillToCustomerID]
	,[CustomerCategoryID]
	,[BuyingGroupID]
	,[PrimaryContactPersonID]
	,[AlternateContactPersonID]
	,[DeliveryMethodID]
INTO Sales.Customers_Copy
FROM Sales.Customers
where [CustomerID] = 100;

SELECT * FROM Sales.Customers_Copy

INSERT INTO Sales.Customers_Copy
	(
	[CustomerID]
	,[CustomerName]
	,[BillToCustomerID]
	,[CustomerCategoryID]
	,[BuyingGroupID]
	,[PrimaryContactPersonID]
	,[AlternateContactPersonID]
	,[DeliveryMethodID]
	)
VALUES
(1,'New',1,2,1,324,112,1)
,(2,'New2',1,2,1,324,112,1)
,(3,'New3',1,2,1,324,112,1)
,(4,'New4',1,2,1,324,112,1)
,(5,'New5',1,2,1,324,112,1)

SELECT * FROM Sales.Customers_Copy

INSERT INTO Sales.Customers_Copy
VALUES
(6,'New',1,2,1,324,112,1)
,(7,'New2',1,2,1,324,112,1)
,(8,'New3',1,2,1,324,112,1)
,(9,'New4',1,2,1,324,112,1)
,(10,'New5',1,2,1,324,112,1)

SELECT * FROM Sales.Customers_Copy

/*
2. Удалите одну запись из Customers, которая была вами добавлена
*/

DELETE TOP(1)
FROM Sales.Customers_Copy;

SELECT * FROM Sales.Customers_Copy

DELETE 
FROM Sales.Customers_Copy
where [CustomerID] = 1;

SELECT * FROM Sales.Customers_Copy


/*
3. Изменить одну запись, из добавленных через UPDATE
*/

UPDATE Sales.Customers_Copy
SET [CustomerName] = 'Old10',
	[BillToCustomerID] += [BillToCustomerID],
	[CustomerCategoryID] *= 5
where [CustomerID] = 10;

SELECT * FROM Sales.Customers_Copy

/*
4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
*/

DROP TABLE IF EXISTS Sales.Customers_Copy_New;
DROP TABLE IF EXISTS Sales.Customers_Copy_MERGE;

SELECT top 13
	[CustomerID]
	,[CustomerName]
INTO Sales.Customers_Copy_New
FROM Sales.Customers

SELECT top 3
	[CustomerID]
	,[CustomerName]
INTO Sales.Customers_Copy_MERGE
FROM Sales.Customers_Copy_New

SELECT * FROM Sales.Customers_Copy_New
SELECT * FROM Sales.Customers_Copy_MERGE

MERGE Sales.Customers_Copy_MERGE AS Target
USING Sales.Customers_Copy_New AS Source
    ON (Target.[CustomerID] = Source.[CustomerID])
WHEN MATCHED 
    THEN UPDATE 
        SET [CustomerName] = Source.[CustomerName]
WHEN NOT MATCHED 
    THEN INSERT 
        VALUES (Source.[CustomerID], Source.[CustomerName])
WHEN NOT MATCHED BY SOURCE
    THEN 
        DELETE;

SELECT * FROM Sales.Customers_Copy_New
SELECT * FROM Sales.Customers_Copy_MERGE

DROP TABLE IF EXISTS Sales.Customers_Copy_New;
DROP TABLE IF EXISTS Sales.Customers_Copy_MERGE;


/*
5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bcp in
*/

EXEC sp_configure 'show advanced options', 1;  
GO  

RECONFIGURE;  
GO  

EXEC sp_configure 'xp_cmdshell', 1;  
GO  

RECONFIGURE;  
GO  

SELECT @@SERVERNAME;

DECLARE @out varchar(250);
set @out = 'bcp WideWorldImporters.Sales.Customers_Copy OUT "C:\BCP\HW09.txt" -T -S ' + @@SERVERNAME + ' -c';
PRINT @out;

EXEC master..xp_cmdshell @out

DROP TABLE IF EXISTS WideWorldImporters.Warehouse.Color_Copy;
SELECT * INTO WideWorldImporters.Warehouse.Color_Copy FROM WideWorldImporters.Warehouse.Colors
WHERE 1 = 2; 


DECLARE @in varchar(250);
set @in = 'bcp WideWorldImporters.Sales.Customers_Copy IN "C:\BCP\HW09.txt" -T -S ' + @@SERVERNAME + ' -c';

EXEC master..xp_cmdshell @in;

SELECT * FROM Sales.Customers_Copy