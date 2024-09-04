/*
Выбираем в своем проекте таблицу-кандидат для секционирования и добавляем партиционирование. 
Если в проекте нет такой таблицы, то делаем анализ базы данных из первого модуля, 
выбираем таблицу и делаем ее секционирование, 
с переносом данных по секциям (партициям) - исходя из того, что таблица большая, пишем скрипты миграции в секционированную таблицу.
*/



create partition function pf_Year(datetime2) as range right 
	for values ('20240101','20250101','20260101','20270101') -- границы

create partition scheme ps_Year as partition pf_Year
to ([primary], Year1, Year2, Year3, Year4)


go


CREATE TABLE [Order] (
  [OrderId] bigint NOT NULL,/*Искуственный индекс*/
  [OrderBarCode] nvarchar(250),/*Баркод*/
  [OrderText] nvarchar(250),/*Комментарий*/
  [Productsid] bigint,/*Ид Продукта*/
  [DeliveryId] bigint,/*Ид поставки*/
  [StoreId] bigint,/*Магазин*/
  [OrderDate] datetime2 NOT NULL,/*Дата*/
  [Statusid] bigint,/*Статус*/
  [Workerid] bigint,/*Сотрудник*/
  [Size] int,/*Количество*/
  
) ON [ps_Year] (OrderDate)

GO

ALTER TABLE [Order] 
	ADD CONSTRAINT PK_Years PRIMARY KEY CLUSTERED  (OrderDate, OrderId)
	ON [ps_Year] (OrderDate)
go

--вариант 2

CREATE TABLE [Order] (
  [OrderId] bigint NOT NULL,/*Искуственный индекс*/
  [OrderBarCode] nvarchar(250),/*Баркод*/
  [OrderText] nvarchar(250),/*Комментарий*/
  [Productsid] bigint,/*Ид Продукта*/
  [DeliveryId] bigint,/*Ид поставки*/
  [StoreId] bigint,/*Магазин*/
  [OrderDate] datetime2 NOT NULL,/*Дата*/
  [Statusid] bigint,/*Статус*/
  [Workerid] bigint,/*Сотрудник*/
  [Size] int,/*Количество*/
  PRIMARY KEY (
        [OrderId],[OrderDate]
    ) ON [ps_Year]([OrderDate])
)
GO
/*
Кандидат таблица dbo.Order
По причине - в ней будут храниться данные по отгрузкам, которые будет необходимо учитывать в годовых отчётах.
Ключ секционирования - dbo.Order.OrderDate
*/