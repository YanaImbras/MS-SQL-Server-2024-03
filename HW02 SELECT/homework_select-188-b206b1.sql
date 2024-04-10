/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, JOIN".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД WideWorldImporters можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal".
Вывести: ИД товара (StockItemID), наименование товара (StockItemName).
Таблицы: Warehouse.StockItems.
*/

select
	StockItemID
	,StockItemName
from [WideWorldImporters].[Warehouse].[StockItems]
where [StockItemName] like 'Animal%'
	or [StockItemName] like '%urgent%'
order by StockItemID

/*
2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders).
Сделать через JOIN, с подзапросом задание принято не будет.
Вывести: ИД поставщика (SupplierID), наименование поставщика (SupplierName).
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.
По каким колонкам делать JOIN подумайте самостоятельно.
*/

select
	s.SupplierID
	,s.SupplierName
from [Purchasing].[Suppliers] as s
left join  [Purchasing].[PurchaseOrders] as po on s.SupplierID=po.SupplierID
where po.SupplierID is NULL

/*Вариант 2*/

select
	s.SupplierID
	,po.SupplierID
	,s.SupplierName
from [Purchasing].[PurchaseOrders] as po
full join [Purchasing].[Suppliers] as s on s.SupplierID=po.SupplierID
where po.SupplierID is NULL

/*Вариант 3*/

select
	s.SupplierID
	,s.SupplierName
from [Purchasing].[PurchaseOrders] as po
right join [Purchasing].[Suppliers] as s on s.SupplierID=po.SupplierID
where po.SupplierID is NULL

/*
3. Заказы (Orders) с ценой товара (UnitPrice) более 100$ 
либо количеством единиц (Quantity) товара более 20 штук
и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID +
* дату заказа (OrderDate) в формате ДД.ММ.ГГГГ+
* название месяца, в котором был сделан заказ +
* номер квартала, в котором был сделан заказ +
* треть года, к которой относится дата заказа (каждая треть по 4 месяца)+
* имя заказчика (Customer)+
Добавьте вариант этого запроса с постраничной выборкой,
пропустив первую 1000 и отобразив следующие 100 записей.

Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).

Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.
*/

select distinct
	o.OrderID
	,o.OrderDate
	, FORMAT(o.OrderDate, 'MMMM', 'ru-ru') as [Месяц Ru]
	, datepart(quarter, o.OrderDate) as [Квартал]
	, [Треть года] = Case 
	when datepart(month, o.OrderDate) in (1,2,3,4) then 1
	when datepart(month, o.OrderDate) in (5,6,7,8) then 2
	else 3
	end
	, c.CustomerName as [Заказчик]
from Sales.Orders as o
join Sales.OrderLines as ol on o.OrderID=ol.OrderID
join Sales.Customers as c on c.CustomerID=o.CustomerID
where o.PickingCompletedWhen is not NULL
	and (ol.UnitPrice > 100 or ol.Quantity > 20)
order by o.OrderDate, [Квартал], [Треть года]

/*Добавьте вариант этого запроса с постраничной выборкой,
пропустив первую 1000 и отобразив следующие 100 записей.*/

DECLARE @p BIGINT = 100, -- Размер страницы
	@pnum BIGINT = 11;-- Номер страницы

select distinct
	o.OrderID
	,o.OrderDate
	, FORMAT(o.OrderDate, 'MMMM', 'ru-ru') as [Месяц Ru]
	, datepart(quarter, o.OrderDate) as [Квартал]
	, [Треть года] = Case 
	when datepart(month, o.OrderDate) in (1,2,3,4) then 1
	when datepart(month, o.OrderDate) in (5,6,7,8) then 2
	else 3
	end
	, c.CustomerName as [Заказчик]
from Sales.Orders as o
join Sales.OrderLines as ol on o.OrderID=ol.OrderID
join Sales.Customers as c on c.CustomerID=o.CustomerID
where o.PickingCompletedWhen is not NULL
	and (ol.UnitPrice > 100 or ol.Quantity > 20)
order by o.OrderDate, [Квартал], [Треть года] DESC OFFSET(@pnum - 1) * @p ROWS
FETCH NEXT @p ROWS ONLY

/*
4. Заказы поставщикам (Purchasing.Suppliers),+
которые должны быть исполнены (ExpectedDeliveryDate) в январе 2013 года+
с доставкой "Air Freight" или "Refrigerated Air Freight" (DeliveryMethodName)+
и которые исполнены (IsOrderFinalized).+
Вывести:
* способ доставки (DeliveryMethodName)+
* дата доставки (ExpectedDeliveryDate)+
* имя поставщика+
* имя контактного лица принимавшего заказ (ContactPerson)+

Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
*/

select
	adm.DeliveryMethodName as [способ доставки]
	, pp.ExpectedDeliveryDate as [дата доставки]
	, ps.SupplierName as [имя поставщика]
	, ap.SearchName as [имя контактного лица]
from Purchasing.Suppliers as ps
join Purchasing.PurchaseOrders as pp on pp.SupplierID=ps.SupplierID
join Application.DeliveryMethods as adm on adm.DeliveryMethodID=ps.DeliveryMethodID
join Application.People as ap on ap.PersonID=ps.AlternateContactPersonID
where (pp.ExpectedDeliveryDate between '2013-01-01' and '2013-01-31')
	and adm.DeliveryMethodName in ('Air Freight', 'Refrigerated Air Freight')
	and pp.IsOrderFinalized is not NULL

/*
5. Десять последних продаж (по дате продажи) с именем клиента и именем сотрудника,
который оформил заказ (SalespersonPerson).
Сделать без подзапросов.
*/

select top 10
sc.CustomerName
from Sales.Orders as so
join Sales.Customers as sc on sc.CustomerID=so.CustomerID
order by so.OrderDate

/*
6. Все ид и имена клиентов и их контактные телефоны,
которые покупали товар "Chocolate frogs 250g".
Имя товара смотреть в таблице Warehouse.StockItems.
*/

select
ap.PersonID as [ид]
, ap.SearchName as [имена клиентов]
,ap.PhoneNumber as [контактные телефоны]
from Application.People as ap
join Purchasing.Suppliers as ps on ap.PersonID=ps.AlternateContactPersonID
join Warehouse.StockItems as ws on ws.SupplierID=ps.SupplierID
where ws.StockItemName like 'Chocolate frogs 250g'