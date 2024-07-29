--CREATE DATABASE Training;
--GO


-- Поставщики\Заказчики
CREATE TABLE [Customer] (
  [CustomerId] bigint UNIQUE NOT NULL, /*Искуственный индекс*/
  [CustomerName] nvarchar(250) NOT NULL,/*Название*/
  [CustomerText] nvarchar(250) NOT NULL,/*Комментарий*/
  [CustomerINN] int NOT NULL,/*ИНН*/
  [CustomerKPP] int NOT NULL,/*КПП*/
  [CustomerBIK] int NOT NULL,/*БИК*/
  [CustomerBank] nvarchar(250) NOT NULL,/*Наименование банка*/
  [CustomerAcc] int NOT NULL,/*Счёт*/
  [CustomerKcc] int NOT NULL,/*Кор.счёт*/
  [CustomerPhone] int NOT NULL,/*Телефон*/
  [CustomerAddress] nvarchar(250) NOT NULL,/*Адресс*/
  PRIMARY KEY (
        [CustomerId]
    )
)

GO

/*Товар\Продукт*/
CREATE TABLE [Products] (
  [Productsid] bigint UNIQUE NOT NULL,/*Искуственный индекс*/
  [ProductsName] nvarchar(250) NOT NULL,/*Название*/
  [ProductsText] nvarchar(250),/*Комментарий*/
  [ProductsArticle] int,/*Артикул*/
  [ProductsLink] nvarchar(250),/*Ссылка*/
  [ProductsBarCode] nvarchar(250),/*Баркод*/
  [CustomerId] bigint NOT NULL, /*Заказчик*/
  [ProductsTypeid] bigint,/*Тип продукта, для рассчета упоковки и работ*/
  [ProductsUnit] int,/*Актуальное количество товара на складе*/
  PRIMARY KEY (
        [Productsid]
    )
)
GO

/*Тип Продукта*/
CREATE TABLE [ProductsType] (
  [ProductsTypeid] bigint UNIQUE NOT NULL,/*Искуственный индекс*/
  [ProductsTypeName] nvarchar(250) NOT NULL,/*Название*/
  [ProductsText] nvarchar(250),/*Комментарий*/
  PRIMARY KEY (
        [ProductsTypeid]
    )
)
GO

/*Тип работ*/
CREATE TABLE [ProductsWork] (
  [ProductsWorkid] bigint UNIQUE NOT NULL,/*Искуственный индекс*/
  [ProductsWorkName] nvarchar(250) NOT NULL,/*Название*/
  [ProductsWorkText] nvarchar(250),/*Комментарий*/
  [ProductsType] bigint,/*Тип продукта, для рассчета упоковки и работ*/
  [Sum] numeric(10,2),/*Цена работ*/
  PRIMARY KEY (
        [ProductsWorkid]
    )
)
GO

/*Сотрудник*/
CREATE TABLE [Worker] (
  [Workerid] bigint UNIQUE NOT NULL,/*Искуственный индекс*/
  [WorkerFIO] nvarchar(250) NOT NULL,/*ФИО*/
  [WorkerDoc] nvarchar(250),/*Документ удостоверяющий личность*/
  [WorkerType] nvarchar(250),/*Самозанятый\Штатный сотрудик и т.п.*/
  [WorkerAddress] nvarchar(250),/*Прописка\Адрес регистрации*/
  [Workerhone] int,/*Контактный телефон*/
  [WorkerPosition] nvarchar(250),/*Должность*/
  PRIMARY KEY (
        [Workerid]
    )
)
GO

/*Поставка товара*/
CREATE TABLE [Order] (
  [OrderId] bigint UNIQUE NOT NULL,/*Искуственный индекс*/
  [OrderBarCode] nvarchar(250),/*Баркод*/
  [OrderText] nvarchar(250),/*Комментарий*/
  [Productsid] bigint,/*Ид Продукта*/
  [DeliveryId] bigint,/*Ид поставки*/
  [StoreId] bigint,/*Магазин*/
  [OrderDate] datetime,/*Дата*/
  [Statusid] bigint,/*Статус*/
  [Workerid] bigint,/*Сотрудник*/
  [Size] int,/*Количество*/
  PRIMARY KEY (
        [OrderId]
    )
)
GO


/*Общая поставка со всеми товарами*/
CREATE TABLE [OrderBox] (
  [OrderBoxId] bigint NOT NULL,/*Искуственный индекс*/
  [OrderBoxBarCode] nvarchar(250),/*Баркод*/
  [OrderBoxText] nvarchar(250),/*Комментарий*/
  [Orderid] bigint,/*Ид Продукта*/
  [StoreId] bigint,/*Магазин*/
  [OrderBoxDate] datetime,/*Дата*/
  [Statusid] bigint,/*Статус*/
  [Workerid] bigint,/*Сотрудник*/
  [Size] int,/*Количество*/
  PRIMARY KEY (
        [OrderBoxId]
    )
)
GO

/*Приход*/
CREATE TABLE [Delivery] (
  [DeliveryId] bigint UNIQUE NOT NULL,/*Искуственный индекс*/
  [Productsid] bigint,/*Продукт*/
  [ProductsText] nvarchar(250),/*Комментарий*/
  [DeliverySize] int,/*Количество едениц*/
  [DeliveryDate] datetime,/*Дата*/
  PRIMARY KEY (
        [DeliveryId]
    )
)
GO


/*Магазин*/
CREATE TABLE [Store] (
  [StoreId] bigint UNIQUE NOT NULL,/*Искуственный индекс*/
  [StoreName] nvarchar(250),/*Название*/
  [StoreText] nvarchar(250),/*Комментарий*/
  [StoreAddress] nvarchar(250),/*Адресс доставки*/
  PRIMARY KEY (
        [StoreId]
    )
)
GO

ALTER TABLE [Order] ADD FOREIGN KEY ([Productsid]) REFERENCES [Products] ([Productsid])
GO

ALTER TABLE [Order] ADD FOREIGN KEY ([Workerid]) REFERENCES [Worker] ([Workerid])
GO

ALTER TABLE [Order] ADD FOREIGN KEY ([DeliveryId]) REFERENCES [Delivery] ([DeliveryId])
GO

ALTER TABLE [Order] ADD FOREIGN KEY ([StoreId]) REFERENCES [Store] ([StoreId])
GO

ALTER TABLE [Delivery] ADD FOREIGN KEY ([Productsid]) REFERENCES [Products] ([Productsid])
GO

ALTER TABLE [OrderBox] ADD FOREIGN KEY ([Orderid]) REFERENCES [Order] ([Orderid])
GO


--Искуственые индексы. Планируется использование только для связи таблиц.
create index idx_Delivery on [Delivery] ([DeliveryId]);
create index idx_Worker on [Worker] ([WorkerId]);
create index idx_Customer on [Customer] ([CustomerId]);
create index idx_Store on [Store] ([StoreId]);
create index idx_Products on [Products] ([ProductsId]);
create index idx_Order on [Order] ([OrderId]);
create index idx_ProductsType on [ProductsType] ([ProductsTypeId]);
create index idx_ProductsWork on [ProductsWork] ([ProductsWorkId]);