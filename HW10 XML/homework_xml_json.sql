/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "08 - Выборки из XML и JSON полей".

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

USE WideWorldImporters;

/*
Примечания к заданиям 1, 2:
* Если с выгрузкой в файл будут проблемы, то можно сделать просто SELECT c результатом в виде XML. 
* Если у вас в проекте предусмотрен экспорт/импорт в XML, то можете взять свой XML и свои таблицы.
* Если с этим XML вам будет скучно, то можете взять любые открытые данные и импортировать их в таблицы (например, с https://data.gov.ru).
* Пример экспорта/импорта в файл https://docs.microsoft.com/en-us/sql/relational-databases/import-export/examples-of-bulk-import-and-export-of-xml-documents-sql-server
*/


/*
1. В личном кабинете есть файл StockItems.xml.
Это данные из таблицы Warehouse.StockItems.
Преобразовать эти данные в плоскую таблицу с полями, аналогичными Warehouse.StockItems.
Поля: StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice 

Загрузить эти данные в таблицу Warehouse.StockItems: 
существующие записи в таблице обновить, отсутствующие добавить (сопоставлять записи по полю StockItemName). 

Сделать два варианта: с помощью OPENXML и через XQuery.
*/

DECLARE @xmlDocument XML;


SELECT @xmlDocument = BulkColumn
FROM OPENROWSET
(BULK 'C:\Users\user\Desktop\SQL\test\HW10 XML\StockItems.xml', 
 SINGLE_CLOB)
AS data;

SELECT @xmlDocument AS [@xmlDocument];

DECLARE @docHandle INT;
EXEC sp_xml_preparedocument @docHandle OUTPUT, @xmlDocument;

SELECT @docHandle AS docHandle;

SELECT *
FROM OPENXML(@docHandle, N'/StockItems/Item')
WITH ( 
[Name] NVARCHAR(100) '@Name', 
[SupplierID] int '(SupplierID)[1]', 
[UnitPackageID] int '(Package/UnitPackageID)[1]', 
[OuterPackageID] int '(Package/OuterPackageID)[1]', 
[QuantityPerOuter] int '(Package/QuantityPerOuter)[1]', 
[TypicalWeightPerUnit] decimal(18,2) '(Package/TypicalWeightPerUnit)[1]', 
[LeadTimeDays] int '(LeadTimeDays)[1]', 
[IsChillerStock] bit '(IsChillerStock)[1]', 
[TaxRate] decimal(18,3) '(TaxRate)[1]', 
[UnitPrice] decimal(18,2) '(UnitPrice)[1]'
);

DROP TABLE IF EXISTS #StockItems;

CREATE TABLE #StockItems(
[Name] NVARCHAR(100), 
[SupplierID] int, 
[UnitPackageID] int, 
[OuterPackageID] int, 
[QuantityPerOuter] int, 
[TypicalWeightPerUnit] decimal(18,2), 
[LeadTimeDays] int, 
[IsChillerStock] bit, 
[TaxRate] decimal(18,3), 
[UnitPrice] decimal(18,2)
);

INSERT INTO #StockItems
SELECT *
FROM OPENXML(@docHandle, N'/StockItems/Item')
WITH ( 
[Name] NVARCHAR(100) '@Name', 
[SupplierID] int '(SupplierID)[1]', 
[UnitPackageID] int '(Package/UnitPackageID)[1]', 
[OuterPackageID] int '(Package/OuterPackageID)[1]', 
[QuantityPerOuter] int '(Package/QuantityPerOuter)[1]', 
[TypicalWeightPerUnit] decimal(18,2) '(Package/TypicalWeightPerUnit)[1]', 
[LeadTimeDays] int '(LeadTimeDays)[1]', 
[IsChillerStock] bit '(IsChillerStock)[1]', 
[TaxRate] decimal(18,3) '(TaxRate)[1]', 
[UnitPrice] decimal(18,2) '(UnitPrice)[1]'
	);


EXEC sp_xml_removedocument @docHandle;

SELECT * FROM #StockItems;

DROP TABLE IF EXISTS #StockItems;
GO

DECLARE @xmlDocument XML;

SELECT @xmlDocument = BulkColumn
FROM OPENROWSET
(BULK 'C:\Users\user\Desktop\SQL\test\HW10 XML\StockItems.xml', 
 SINGLE_CLOB)
AS data;

SELECT @xmlDocument AS [@xmlDocument];

DECLARE @docHandle INT;
EXEC sp_xml_preparedocument @docHandle OUTPUT, @xmlDocument;

SELECT @docHandle AS docHandle;

DROP TABLE IF EXISTS #StockItems;

CREATE TABLE #StockItems(
    StockItemName NVARCHAR(100), 
    SupplierID INT, 
    UnitPackageID INT, 
    OuterPackageID INT, 
    QuantityPerOuter INT, 
    TypicalWeightPerUnit DECIMAL(18,2), 
    LeadTimeDays INT, 
    IsChillerStock BIT, 
    TaxRate DECIMAL(18,3), 
    UnitPrice DECIMAL(18,2)
);

INSERT INTO #StockItems
SELECT 
    Item.value('@Name', 'NVARCHAR(100)') AS StockItemName,
    Item.value('(SupplierID)[1]', 'INT') AS SupplierID,
    Item.value('(Package/UnitPackageID)[1]', 'INT') AS UnitPackageID,
    Item.value('(Package/OuterPackageID)[1]', 'INT') AS OuterPackageID,
    Item.value('(Package/QuantityPerOuter)[1]', 'INT') AS QuantityPerOuter,
    Item.value('(Package/TypicalWeightPerUnit)[1]', 'DECIMAL(18,2)') AS TypicalWeightPerUnit,
    Item.value('(LeadTimeDays)[1]', 'INT') AS LeadTimeDays,
    Item.value('(IsChillerStock)[1]', 'BIT') AS IsChillerStock,
    Item.value('(TaxRate)[1]', 'DECIMAL(18,3)') AS TaxRate,
    Item.value('(UnitPrice)[1]', 'DECIMAL(18,2)') AS UnitPrice
FROM @xmlDocument.nodes('/StockItems/Item') AS XmlData(Item);

EXEC sp_xml_removedocument @docHandle;

SELECT * FROM #StockItems;

DROP TABLE IF EXISTS #StockItems;
GO


DECLARE @x XML;
SET @x = ( 
  SELECT * FROM OPENROWSET
  (BULK 'C:\Users\user\Desktop\SQL\test\HW10 XML\StockItems.xml',
   SINGLE_CLOB) AS d);


SELECT 
   @x.value('(StockItems/Item/@Name)[1]', 'NVARCHAR(100)') AS StockItemName,
   @x.value('(StockItems/Item/SupplierID)[1]', 'INT') AS SupplierID,
   @x.value('(StockItems/Item/Package/UnitPackageID)[1]', 'INT') AS UnitPackageID,
   @x.value('(StockItems/Item/Package/OuterPackageID)[1]', 'INT') AS OuterPackageID,
   @x.value('(StockItems/Item/Package/QuantityPerOuter)[1]', 'INT') AS QuantityPerOuter,
   @x.value('(StockItems/Item/Package/TypicalWeightPerUnit)[1]', 'DECIMAL(18,2)') AS TypicalWeightPerUnit,
   @x.value('(StockItems/Item/LeadTimeDays)[1]', 'INT') AS LeadTimeDays,
   @x.value('(StockItems/Item/IsChillerStock)[1]', 'BIT') AS IsChillerStock,
   @x.value('(StockItems/Item/TaxRate)[1]', 'DECIMAL(18,3)') AS TaxRate,
   @x.value('(StockItems/Item/UnitPrice)[1]', 'DECIMAL(18,2)') AS UnitPrice
GO 


/*
2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml
*/

SELECT 
    StockItemName, 
	SupplierID, 
	UnitPackageID, 
	OuterPackageID, 
	QuantityPerOuter, 
	TypicalWeightPerUnit, 
	LeadTimeDays, 
	IsChillerStock, 
	TaxRate,
	UnitPrice 
FROM Warehouse.StockItems
FOR XML RAW('Item'), ROOT('StockItems'), ELEMENTS;

/*
3. В таблице Warehouse.StockItems в колонке CustomFields есть данные в JSON.
Написать SELECT для вывода:
- StockItemID
- StockItemName
- CountryOfManufacture (из CustomFields)
- FirstTag (из поля CustomFields, первое значение из массива Tags)
*/

SELECT 
StockItemID
,StockItemName
,JSON_VALUE(CustomFields, '$.CountryOfManufacture') as CountryOfManufacture
,JSON_VALUE(CustomFields, '$.Tags[0]') as FirstTag 
FROM Warehouse.StockItems 

/*
4. Найти в StockItems строки, где есть тэг "Vintage".
Вывести: 
- StockItemID
- StockItemName
- (опционально) все теги (из CustomFields) через запятую в одном поле

Тэги искать в поле CustomFields, а не в Tags.
Запрос написать через функции работы с JSON.
Для поиска использовать равенство, использовать LIKE запрещено.

Должно быть в таком виде:
... where ... = 'Vintage'

Так принято не будет:
... where ... Tags like '%Vintage%'
... where ... CustomFields like '%Vintage%' 
*/

SELECT 
StockItemID
,StockItemName
,CustomFields
,CF.value
FROM Warehouse.StockItems 
CROSS APPLY OPENJSON(CustomFields, '$.Tags') CF
WHERE CF.value = 'Vintage'

-- CROSS APPLY OPENJSON(CustomFields) разложил значение по тегам, но массив из тега Tags пишет как одно значение в []скобках
-- Пример: ["Radio Control","Realistic Sound"] или ["Vintage","So Realistic"]
-- Не понимаю как с этим быть
-- Далее поиск только через like смогла сделать

SELECT 
StockItemID
,StockItemName
,CustomFields
,CF.value
FROM Warehouse.StockItems 
CROSS APPLY OPENJSON(CustomFields) CF
WHERE CF.value like '%Vintage%'

