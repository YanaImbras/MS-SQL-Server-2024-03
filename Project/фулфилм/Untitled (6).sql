CREATE TABLE [Customer] (
  [CustomerId] int UNIQUE PRIMARY KEY NOT NULL,
  [CustomerName] varchar(250) NOT NULL,
  [CustomerINN] int NOT NULL,
  [CustomerKPP] int NOT NULL,
  [CustomerBIK] int NOT NULL,
  [CustomerBank] varchar(250) NOT NULL,
  [CustomerAcc] int NOT NULL,
  [CustomerKcc] int NOT NULL,
  [CustomerPhone] int NOT NULL,
  [CustomerAddress] varchar(250) NOT NULL
)
GO

CREATE TABLE [Products] (
  [Productsid] int UNIQUE PRIMARY KEY NOT NULL,
  [ProductsName] varchar(250) NOT NULL,
  [ProductsText] varchar(250),
  [ProductsArticle] int,
  [ProductsLink] varchar(250),
  [ProductsBarCode] varchar(250),
  [ProductsType] int,
  [CustomerId] int,
  [SupplierId] int,
  [ProductsUnit] varchar(250)
)
GO

CREATE TABLE [Worker] (
  [Workerid] int UNIQUE PRIMARY KEY NOT NULL,
  [WorkerFIO] varchar(250) NOT NULL,
  [WorkerDoc] varchar(250),
  [WorkerAdd] varchar(250),
  [Workerhone] int,
  [WorkerPosition] varchar(250)
)
GO

CREATE TABLE [Order] (
  [OrderId] int UNIQUE PRIMARY KEY NOT NULL,
  [OrderBarCode] varchar(250),
  [Productsid] int,
  [StoreId] int,
  [OrderDate] datetime,
  [Statusid] int,
  [Workerid] int,
  [Quantity] int
)
GO

CREATE TABLE [Delivery] (
  [DeliveryId] int UNIQUE PRIMARY KEY NOT NULL,
  [Productsid] int,
  [DeliverySize] int,
  [DeliveryDate] datetime
)
GO

CREATE TABLE [Store] (
  [StoreId] int UNIQUE PRIMARY KEY NOT NULL,
  [StoreName] varchar(250),
  [StoreText] varchar(250),
  [StoreAddress] varchar(250)
)
GO

ALTER TABLE [Order] ADD FOREIGN KEY ([Productsid]) REFERENCES [Products] ([Productsid])
GO

ALTER TABLE [Order] ADD FOREIGN KEY ([Workerid]) REFERENCES [Worker] ([Workerid])
GO

ALTER TABLE [Order] ADD FOREIGN KEY ([StoreId]) REFERENCES [Store] ([StoreId])
GO

ALTER TABLE [Delivery] ADD FOREIGN KEY ([Productsid]) REFERENCES [Products] ([Productsid])
GO

ALTER TABLE [Products] ADD FOREIGN KEY ([CustomerId]) REFERENCES [Customer] ([CustomerId])
GO
