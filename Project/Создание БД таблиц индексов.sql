--CREATE DATABASE Training;
--GO


-- ����������\���������
CREATE TABLE [Customer] (
  [CustomerId] bigint UNIQUE NOT NULL, /*������������ ������*/
  [CustomerName] nvarchar(250) NOT NULL,/*��������*/
  [CustomerText] nvarchar(250) NOT NULL,/*�����������*/
  [CustomerINN] int NOT NULL,/*���*/
  [CustomerKPP] int NOT NULL,/*���*/
  [CustomerBIK] int NOT NULL,/*���*/
  [CustomerBank] nvarchar(250) NOT NULL,/*������������ �����*/
  [CustomerAcc] int NOT NULL,/*����*/
  [CustomerKcc] int NOT NULL,/*���.����*/
  [CustomerPhone] int NOT NULL,/*�������*/
  [CustomerAddress] nvarchar(250) NOT NULL,/*������*/
  PRIMARY KEY (
        [CustomerId]
    )
)

GO

/*�����\�������*/
CREATE TABLE [Products] (
  [Productsid] bigint UNIQUE NOT NULL,/*������������ ������*/
  [ProductsName] nvarchar(250) NOT NULL,/*��������*/
  [ProductsText] nvarchar(250),/*�����������*/
  [ProductsArticle] int,/*�������*/
  [ProductsLink] nvarchar(250),/*������*/
  [ProductsBarCode] nvarchar(250),/*������*/
  [CustomerId] bigint NOT NULL, /*��������*/
  [ProductsTypeid] bigint,/*��� ��������, ��� �������� �������� � �����*/
  [ProductsUnit] int,/*���������� ���������� ������ �� ������*/
  PRIMARY KEY (
        [Productsid]
    )
)
GO

/*��� ��������*/
CREATE TABLE [ProductsType] (
  [ProductsTypeid] bigint UNIQUE NOT NULL,/*������������ ������*/
  [ProductsTypeName] nvarchar(250) NOT NULL,/*��������*/
  [ProductsText] nvarchar(250),/*�����������*/
  PRIMARY KEY (
        [ProductsTypeid]
    )
)
GO

/*��� �����*/
CREATE TABLE [ProductsWork] (
  [ProductsWorkid] bigint UNIQUE NOT NULL,/*������������ ������*/
  [ProductsWorkName] nvarchar(250) NOT NULL,/*��������*/
  [ProductsWorkText] nvarchar(250),/*�����������*/
  [ProductsType] bigint,/*��� ��������, ��� �������� �������� � �����*/
  [Sum] numeric(10,2),/*���� �����*/
  PRIMARY KEY (
        [ProductsWorkid]
    )
)
GO

/*���������*/
CREATE TABLE [Worker] (
  [Workerid] bigint UNIQUE NOT NULL,/*������������ ������*/
  [WorkerFIO] nvarchar(250) NOT NULL,/*���*/
  [WorkerDoc] nvarchar(250),/*�������� �������������� ��������*/
  [WorkerType] nvarchar(250),/*�����������\������� �������� � �.�.*/
  [WorkerAddress] nvarchar(250),/*��������\����� �����������*/
  [Workerhone] int,/*���������� �������*/
  [WorkerPosition] nvarchar(250),/*���������*/
  PRIMARY KEY (
        [Workerid]
    )
)
GO

/*�������� ������*/
CREATE TABLE [Order] (
  [OrderId] bigint UNIQUE NOT NULL,/*������������ ������*/
  [OrderBarCode] nvarchar(250),/*������*/
  [OrderText] nvarchar(250),/*�����������*/
  [Productsid] bigint,/*�� ��������*/
  [DeliveryId] bigint,/*�� ��������*/
  [StoreId] bigint,/*�������*/
  [OrderDate] datetime,/*����*/
  [Statusid] bigint,/*������*/
  [Workerid] bigint,/*���������*/
  [Size] int,/*����������*/
  PRIMARY KEY (
        [OrderId]
    )
)
GO


/*����� �������� �� ����� ��������*/
CREATE TABLE [OrderBox] (
  [OrderBoxId] bigint NOT NULL,/*������������ ������*/
  [OrderBoxBarCode] nvarchar(250),/*������*/
  [OrderBoxText] nvarchar(250),/*�����������*/
  [Orderid] bigint,/*�� ��������*/
  [StoreId] bigint,/*�������*/
  [OrderBoxDate] datetime,/*����*/
  [Statusid] bigint,/*������*/
  [Workerid] bigint,/*���������*/
  [Size] int,/*����������*/
  PRIMARY KEY (
        [OrderBoxId]
    )
)
GO

/*������*/
CREATE TABLE [Delivery] (
  [DeliveryId] bigint UNIQUE NOT NULL,/*������������ ������*/
  [Productsid] bigint,/*�������*/
  [ProductsText] nvarchar(250),/*�����������*/
  [DeliverySize] int,/*���������� ������*/
  [DeliveryDate] datetime,/*����*/
  PRIMARY KEY (
        [DeliveryId]
    )
)
GO


/*�������*/
CREATE TABLE [Store] (
  [StoreId] bigint UNIQUE NOT NULL,/*������������ ������*/
  [StoreName] nvarchar(250),/*��������*/
  [StoreText] nvarchar(250),/*�����������*/
  [StoreAddress] nvarchar(250),/*������ ��������*/
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


--����������� �������. ����������� ������������� ������ ��� ����� ������.
create index idx_Delivery on [Delivery] ([DeliveryId]);
create index idx_Worker on [Worker] ([WorkerId]);
create index idx_Customer on [Customer] ([CustomerId]);
create index idx_Store on [Store] ([StoreId]);
create index idx_Products on [Products] ([ProductsId]);
create index idx_Order on [Order] ([OrderId]);
create index idx_ProductsType on [ProductsType] ([ProductsTypeId]);
create index idx_ProductsWork on [ProductsWork] ([ProductsWorkId]);