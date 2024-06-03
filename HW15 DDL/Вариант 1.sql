--CREATE DATABASE Training;
--GO

CREATE TABLE [Supplier] (
    [SupplierId] int  NOT NULL ,
    [SupplierName] varchar(250)  NOT NULL ,
    [SupplierINN] int  NOT NULL ,
    [SupplierKPP] int  NOT NULL ,
    [SupplierBIK] int  NOT NULL ,
    [SupplierBank] varchar(250)  NOT NULL ,
    [SupplierAcc] int  NOT NULL ,
    [SupplierKcc] int  NOT NULL ,
    [SupplierPhone] int  NOT NULL ,
    [SupplierAddress] varchar(max)  NOT NULL ,
    PRIMARY KEY (
        [SupplierId]
    )
);

CREATE TABLE [Customer] (
    [CustomerId] int  NOT NULL ,
    [Customer] varchar(250)  NOT NULL ,
    [CustomerINN] int  NOT NULL ,
    [CustomerKPP] int  NOT NULL ,
    [CustomerBIK] int  NOT NULL ,
    [CustomerBank] varchar(250)  NOT NULL ,
    [CustomerAcc] int  NOT NULL ,
    [CustomerKcc] int  NOT NULL ,
    [CustomerPhone] int  NOT NULL ,
    [CustomerAddress] varchar(250)  NOT NULL ,
    PRIMARY KEY (
        [CustomerId]
    )
);

CREATE TABLE [Store] (
    [StoreId] int  NOT NULL ,
    [StoreName] varchar(250)  NOT NULL ,
    [StoreINN] int  NOT NULL ,
    [StoreKPP] int  NOT NULL ,
    [StoreBIK] int  NOT NULL ,
    [StoreBank] varchar(250)  NOT NULL ,
    [StoreAcc] int  NOT NULL ,
    [StoreKcc] int  NOT NULL ,
    [StorePhone] int  NOT NULL ,
    [StoreAddress] varchar(250)  NOT NULL ,
    PRIMARY KEY (
        [StoreId]
    )
);

CREATE TABLE [Products] (
    [Productsid] int  NOT NULL ,
    [ProductsName] varchar(250)  NOT NULL ,
    [ProductsArticle] int  NOT NULL ,
    [ProductsLink] varchar(250)  NOT NULL ,
    [ProductsBarCode] varchar(250)  NOT NULL ,
    [TypeProductid] int  NOT NULL ,
    [CustomerId] int  NOT NULL ,
    [SupplierId] int  NOT NULL ,
    [ProductsUnit] varchar(250)  NOT NULL ,
    [TypeDelivery] varchar(20)  NOT NULL ,
    [DeliveryId] int  NOT NULL ,
    PRIMARY KEY (
        [Productsid]
    )
);

CREATE TABLE [Operation_status] (
    [Statusid] int  NOT NULL ,
    [StatusName] varchar(250)  NOT NULL ,
    PRIMARY KEY (
        [Statusid]
    )
);

CREATE TABLE [Worker] (
    [Workerid] int  NOT NULL ,
    [WorkerFIO] varchar(250)  NOT NULL ,
    [WorkerDoc] varchar(250)  NOT NULL ,
    [WorkerAdd] varchar(250)  NOT NULL ,
    [Workerhone] int  NOT NULL ,
    [WorkerPosition] varchar(250)  NOT NULL ,
    PRIMARY KEY (
        [Workerid]
    )
);

CREATE TABLE [TypeProduct] (
    [TypeProductid] int  NOT NULL ,
    [TypeProductName] varchar(250)  NOT NULL ,
    [TypeProductPrice] int  NOT NULL ,
    PRIMARY KEY (
        [TypeProductid]
    )
);

CREATE TABLE [Order] (
    [OrderId] int  NOT NULL ,
    [OrderBarCode] varchar(250)  NOT NULL ,
    [Productsid] int  NOT NULL ,
    [DeliveryId] int  NOT NULL ,
    [CustomerId] int  NOT NULL ,
    [SupplierId] int  NOT NULL ,
    [StoreId] int  NOT NULL ,
    [OrderDate] Date  NOT NULL ,
    [DeliveryDate] Date  NOT NULL ,
    [Statusid] int  NOT NULL ,
    [Workerid] int  NOT NULL ,
    [Quantity] int  NOT NULL ,
    PRIMARY KEY (
        [OrderId]
    )
);

CREATE TABLE [Delivery] (
    [DeliveryId] int  NOT NULL ,
    [Productsid] int  NOT NULL ,
    [DeliverySize] int  NOT NULL ,
    [DeliveryDate] Date  NOT NULL ,
    PRIMARY KEY (
        [DeliveryId]
    )
);

ALTER TABLE [Order] ADD CONSTRAINT fk_Supplier_SupplierId FOREIGN KEY([SupplierId])
REFERENCES [Supplier] ([SupplierId]);

ALTER TABLE [Order] ADD CONSTRAINT fk_Customer_CustomerId FOREIGN KEY([CustomerId])
REFERENCES [Customer] ([CustomerId]);

ALTER TABLE [Order] ADD CONSTRAINT fk_Store_StoreId FOREIGN KEY([StoreId])
REFERENCES [Store] ([StoreId]);

ALTER TABLE [Order] ADD CONSTRAINT fk_Products_Productsid FOREIGN KEY([Productsid])
REFERENCES [Products] ([Productsid]);

ALTER TABLE [Products] ADD CONSTRAINT fk_Products_CustomerId FOREIGN KEY([CustomerId])
REFERENCES [Customer] ([CustomerId]);

ALTER TABLE [Products] ADD CONSTRAINT fk_Products_SupplierId FOREIGN KEY([SupplierId])
REFERENCES [Supplier] ([SupplierId]);

ALTER TABLE [Order] ADD CONSTRAINT fk_Operation_status_Statusid FOREIGN KEY([Statusid])
REFERENCES [Operation_status] ([Statusid]);

ALTER TABLE [Order] ADD CONSTRAINT fk_Worker_Workerid FOREIGN KEY([Workerid])
REFERENCES [Worker] ([Workerid]);

ALTER TABLE [Products] ADD CONSTRAINT fk_TypeProduct_TypeProductid FOREIGN KEY([TypeProductid])
REFERENCES [TypeProduct] ([TypeProductid]);

ALTER TABLE [Order] ADD CONSTRAINT fk_Delivery_DeliveryId FOREIGN KEY([DeliveryId])
REFERENCES [Delivery] ([DeliveryId]);

create index idx_Delivery on [Delivery] ([DeliveryId]);
create index idx_Supplier on [Supplier] ([SupplierId]);
create index idx_Customer on [Customer] ([CustomerId]);
create index idx_Store on [Store] ([StoreId]);
create index idx_Products on [Products] ([ProductsId]);
create index idx_Order on [Order] ([OrderId]);
