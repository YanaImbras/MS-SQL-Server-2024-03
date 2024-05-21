-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/phq9to
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE `Supplier` (
    `SupplierId` int  NOT NULL ,
    `SupplierName` varchar(max)  NOT NULL ,
    `SupplierINN` int  NOT NULL ,
    `SupplierKPP` int  NOT NULL ,
    `SupplierBIK` int  NOT NULL ,
    `SupplierBank` varchar(max)  NOT NULL ,
    `SupplierPhone` int  NOT NULL ,
    `SupplierAddress` varchar(max)  NOT NULL ,
    PRIMARY KEY (
        `SupplierId`
    )
);

CREATE TABLE `Customer` (
    `CustomerId` int  NOT NULL ,
    `Customer` varchar(max)  NOT NULL ,
    `CustomerINN` int  NOT NULL ,
    `CustomerKPP` int  NOT NULL ,
    `CustomerBIK` int  NOT NULL ,
    `CustomerBank` varchar(max)  NOT NULL ,
    `CustomerPhone` int  NOT NULL ,
    `CustomerAddress` varchar(max)  NOT NULL ,
    PRIMARY KEY (
        `CustomerId`
    )
);

CREATE TABLE `Store` (
    `StoreId` int  NOT NULL ,
    `StoreName` varchar(max)  NOT NULL ,
    `StoreINN` int  NOT NULL ,
    `StoreKPP` int  NOT NULL ,
    `StoreBIK` int  NOT NULL ,
    `StoreBank` varchar(max)  NOT NULL ,
    `StorePhone` int  NOT NULL ,
    `StoreAddress` varchar(max)  NOT NULL ,
    PRIMARY KEY (
        `StoreId`
    )
);

CREATE TABLE `Products` (
    `Productsid` int  NOT NULL ,
    `ProductsName` varchar(max)  NOT NULL ,
    `ProductsColor` varchar(max)  NOT NULL ,
    `ProductsLink` varchar(max)  NOT NULL ,
    `ProductsBarCode` varchar(max)  NOT NULL ,
    `ProductsType` int  NOT NULL ,
    `Servicesid` int  NOT NULL ,
    `ProductsUnit` varchar(max)  NOT NULL ,
    `ProductsSize` int  NOT NULL 
);

CREATE TABLE `Operation_status` (
    `Statusid` int  NOT NULL ,
    `StatusName` varchar(max)  NOT NULL 
);

CREATE TABLE `Worker` (
    `Workerid` int  NOT NULL ,
    `WorkerFIO` varchar(max)  NOT NULL ,
    `WorkerPosition` varchar(max)  NOT NULL 
);

CREATE TABLE `TypeProduct` (
    `TypeProductid` int  NOT NULL ,
    `TypeProductName` varchar(max)  NOT NULL ,
    `TypeProductPrice` int  NOT NULL 
);

CREATE TABLE `Services` (
    `Servicesid` int  NOT NULL ,
    `ServicesName` varchar(max)  NOT NULL ,
    `ServicesPrise` int  NOT NULL 
);

CREATE TABLE `Consumables` (
    `ConsumablesId` int  NOT NULL ,
    `ConsumablesName` varchar(max)  NOT NULL ,
    `ConsumablesUnit` varchar(max)  NOT NULL ,
    `ConsumablesPrise` int  NOT NULL 
);

CREATE TABLE `Order` (
    `OrderId` int  NOT NULL ,
    `Productsid` int  NOT NULL ,
    `CustomerId` int  NOT NULL ,
    `SupplierId` int  NOT NULL ,
    `StoreId` int  NOT NULL ,
    `OrderData` Date  NOT NULL ,
    `Statusid` int  NOT NULL ,
    `ConsumablesId` int  NOT NULL ,
    `Workerid` int  NOT NULL ,
    `OrderSum` int  NOT NULL 
);

ALTER TABLE `Supplier` ADD CONSTRAINT `fk_Supplier_SupplierId` FOREIGN KEY(`SupplierId`)
REFERENCES `Order` (`SupplierId`);

ALTER TABLE `Customer` ADD CONSTRAINT `fk_Customer_CustomerId` FOREIGN KEY(`CustomerId`)
REFERENCES `Order` (`CustomerId`);

ALTER TABLE `Store` ADD CONSTRAINT `fk_Store_StoreId` FOREIGN KEY(`StoreId`)
REFERENCES `Order` (`StoreId`);

ALTER TABLE `Products` ADD CONSTRAINT `fk_Products_Productsid` FOREIGN KEY(`Productsid`)
REFERENCES `Order` (`Productsid`);

ALTER TABLE `Operation_status` ADD CONSTRAINT `fk_Operation_status_Statusid` FOREIGN KEY(`Statusid`)
REFERENCES `Order` (`Statusid`);

ALTER TABLE `Worker` ADD CONSTRAINT `fk_Worker_Workerid` FOREIGN KEY(`Workerid`)
REFERENCES `Order` (`Workerid`);

ALTER TABLE `TypeProduct` ADD CONSTRAINT `fk_TypeProduct_TypeProductid` FOREIGN KEY(`TypeProductid`)
REFERENCES `Products` (`ProductsType`);

ALTER TABLE `Services` ADD CONSTRAINT `fk_Services_Servicesid` FOREIGN KEY(`Servicesid`)
REFERENCES `Products` (`Servicesid`);

ALTER TABLE `Consumables` ADD CONSTRAINT `fk_Consumables_ConsumablesId` FOREIGN KEY(`ConsumablesId`)
REFERENCES `Order` (`ConsumablesId`);

