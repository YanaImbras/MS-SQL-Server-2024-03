CREATE TABLE [Customer] (
  [CustomerId] int UNIQUE NOT NULL,
  [CustomerName] varchar(250) NOT NULL,
  [CustomerINN] int NOT NULL,
  [CustomerKPP] int NOT NULL,
  [CustomerBIK] int NOT NULL,
  [CustomerBank] varchar(250) NOT NULL,
  [CustomerAcc] int NOT NULL,
  [CustomerKcc] int NOT NULL,
  [CustomerPhone] int NOT NULL,
  [CustomerAddress] varchar(250) NOT NULL,
  PRIMARY KEY (
        [CustomerId]
    )
)
GO

CREATE TABLE [Products] (
  [Productsid] int UNIQUE NOT NULL,
  [ProductsName] varchar(250) NOT NULL,
  [ProductsText] varchar(250),
  [ProductsArticle] int,
  [ProductsLink] varchar(250),
  [ProductsBarCode] varchar(250),
  [ProductsType] int,
  [CustomerId] int,
  [ProductsUnit] varchar(250),
  PRIMARY KEY (
        [Productsid]
    )
)
GO

CREATE TABLE [Worker] (
  [Workerid] int UNIQUE NOT NULL,
  [WorkerFIO] varchar(250) NOT NULL,
  [WorkerDoc] varchar(250),
  [WorkerAdd] varchar(250),
  [Workerhone] int,
  [WorkerPosition] varchar(250),
  PRIMARY KEY (
        [Workerid]
    )
)
GO

CREATE TABLE [Order] (
  [OrderId] int UNIQUE NOT NULL,
  [OrderBarCode] varchar(250),
  [Productsid] int,
  [DeliveryId] int,
  [CustomerId] int,
  [StoreId] int,
  [OrderDate] datetime,
  [Statusid] int,
  [Workerid] int,
  [Quantity] int,
  PRIMARY KEY (
        [OrderId]
    )
)
GO

CREATE TABLE [Delivery] (
  [DeliveryId] int UNIQUE NOT NULL,
  [Productsid] int,
  [DeliverySize] int,
  [DeliveryDate] datetime,
  [CustomerId] int,
  PRIMARY KEY (
        [DeliveryId]
    )
)
GO

CREATE TABLE [Store] (
  [StoreId] int UNIQUE NOT NULL,
  [StoreName] varchar(250),
  [StoreText] varchar(250),
  [StoreAddress] varchar(250),
  PRIMARY KEY (
        [StoreId]
    )
)
GO

ALTER TABLE [Order] ADD FOREIGN KEY ([Productsid]) REFERENCES [Products] ([Productsid])
GO

ALTER TABLE [Order] ADD FOREIGN KEY ([CustomerId]) REFERENCES [Customer] ([CustomerId])
GO

ALTER TABLE [Order] ADD FOREIGN KEY ([Workerid]) REFERENCES [Worker] ([Workerid])
GO

ALTER TABLE [Order] ADD FOREIGN KEY ([DeliveryId]) REFERENCES [Delivery] ([DeliveryId])
GO

ALTER TABLE [Order] ADD FOREIGN KEY ([StoreId]) REFERENCES [Store] ([StoreId])
GO

ALTER TABLE [Delivery] ADD FOREIGN KEY ([Productsid]) REFERENCES [Products] ([Productsid])
GO

ALTER TABLE [Delivery] ADD FOREIGN KEY ([CustomerId]) REFERENCES [Customer] ([CustomerId])
GO
