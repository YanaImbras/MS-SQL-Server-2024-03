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
    [ProductsType] int  NOT NULL ,
    [CustomerId] int  NOT NULL ,
    [SupplierId] int  NOT NULL ,
    [ProductsUnit] varchar(250)  NOT NULL ,
    [TypeDelivery] varchar(20)  NOT NULL ,
    [DeliveryId] int  NOT NULL ,
    PRIMARY KEY (
        [Productsid]
    ),
    FOREIGN KEY ([CustomerId]) REFERENCES [Customer]([CustomerId]),
    FOREIGN KEY ([SupplierId]) REFERENCES [Supplier]([SupplierId])
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

CREATE TABLE [Delivery] (
    [DeliveryId] int  NOT NULL ,
    [Productsid] int  NOT NULL ,
    [DeliverySize] int  NOT NULL ,
    [DeliveryDate] Date  NOT NULL ,
    PRIMARY KEY (
        [DeliveryId]
    ),
	FOREIGN KEY ([ProductsId]) REFERENCES [Products]([ProductsId])
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
    ),
	FOREIGN KEY ([ProductsId]) REFERENCES [Products]([ProductsId]),
    FOREIGN KEY ([DeliveryId]) REFERENCES [Delivery]([DeliveryId]),
    FOREIGN KEY ([CustomerId]) REFERENCES [Customer]([CustomerId]),
    FOREIGN KEY ([SupplierId]) REFERENCES [Supplier]([SupplierId]),
    FOREIGN KEY ([StoreId]) REFERENCES [Store]([StoreId]),
    FOREIGN KEY ([StatusId]) REFERENCES [Operation_status]([StatusId]),
    FOREIGN KEY ([WorkerId]) REFERENCES [Worker]([WorkerId])
);

create index idx_Delivery on [Delivery] ([DeliveryId]);
create index idx_Supplier on [Supplier] ([SupplierId]);
create index idx_Customer on [Customer] ([CustomerId]);
create index idx_Store on [Store] ([StoreId]);
create index idx_Products on [Products] ([ProductsId]);
create index idx_Order on [Order] ([OrderId]);
