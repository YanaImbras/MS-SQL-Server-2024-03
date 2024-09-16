/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "12 - Хранимые процедуры, функции, триггеры, курсоры".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

USE WideWorldImporters

/*
Во всех заданиях написать хранимую процедуру / функцию и продемонстрировать ее использование.
*/

/*
1) Написать функцию возвращающую Клиента с наибольшей суммой покупки.
*/
create function Sales.CustomerSumMax()
returns int
as
    begin
        declare @CustomerID int;
        with CMaxSum
            as 
			(
			select 
				sil.InvoiceID, 
				SUM(sil.Quantity * ISNULL(sil.UnitPrice, wsi.UnitPrice)) as MaxSum
            from Sales.InvoiceLines as sil
			join Warehouse.StockItems as wsi on sil.StockItemID = wsi.StockItemID
            group by sil.InvoiceID
			)
            select top 1 
				@CustomerID = sc.CustomerID
            from Sales.Invoices as si
            join CMaxSum as cms on si.InvoiceID = cms.InvoiceID
            join Sales.Customers as sc on si.CustomerID = sc.CustomerID
            order by cms.MaxSum desc;
        return @CustomerID;
    end;
go



/*
2) Написать хранимую процедуру с входящим параметром СustomerID, выводящую сумму покупки по этому клиенту.
Использовать таблицы :
Sales.Customers
Sales.Invoices
Sales.InvoiceLines
*/

create procedure Sales.CustomerSum 
@CustomerID int
as
    begin
    select
        SUM(sil.Quantity * sil.UnitPrice)
    from
        Sales.Customers as sc
        join Sales.Invoices si ON sc.CustomerID = si.CustomerID
        join Sales.InvoiceLines sil ON si.InvoiceID = sil.InvoiceID
    where
        sc.CustomerID = @CustomerID;
    end;
go



/*
3) Создать одинаковую функцию и хранимую процедуру, посмотреть в чем разница в производительности и почему.
*/

напишите здесь свое решение

/*
4) Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла. 
*/

напишите здесь свое решение

/*
5) Опционально. Во всех процедурах укажите какой уровень изоляции транзакций вы бы использовали и почему. 
*/
