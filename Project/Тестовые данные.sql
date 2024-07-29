-- Поставщики\Заказчики
INSERT INTO [Customer] (
  [CustomerId],
  [CustomerName],
  [CustomerText],
  [CustomerINN],
  [CustomerKPP],
  [CustomerBIK],
  [CustomerBank],
  [CustomerAcc],
  [CustomerKcc],
  [CustomerPhone],
  [CustomerAddress]
)
VALUES 
(1,'заказчик1','text1',11,12,13,'bank1',14,15,16,'adress1'),
(2,'заказчик2','text2',21,22,23,'bank2',24,25,26,'adress2'),
(3,'заказчик3','text3',31,32,33,'bank3',34,35,36,'adress3'),
(4,'заказчик4','text4',41,42,43,'bank4',44,45,46,'adress4'),
(5,'заказчик5','text5',51,52,53,'bank5',54,55,56,'adress5'),
(6,'заказчик6','text6',61,62,63,'bank6',64,65,66,'adress6'),
(7,'заказчик7','text7',71,72,73,'bank7',74,75,76,'adress7'),
(8,'заказчик8','text8',81,82,83,'bank8',84,85,86,'adress8'),
GO

/*Товар\Продукт*/
INSERT INTO [Products] (
  [Productsid],
  [ProductsName],
  [ProductsText],
  [ProductsArticle],
  [ProductsLink],
  [ProductsBarCode],
  [CustomerId],
  [ProductsTypeid],
  [ProductsUnit]
)
VALUES 
()
GO

/*Тип Продукта*/
INSERT INTO [ProductsType] (
  [ProductsTypeid],
  [ProductsTypeName],
  [ProductsText]
)
VALUES 
()
GO

/*Тип работ*/
INSERT INTO [ProductsWork] (
  [ProductsWorkid],
  [ProductsWorkName],
  [ProductsWorkText],
  [ProductsType],
  [Sum]
    )
VALUES 
()
GO

/*Сотрудник*/
INSERT INTO [Worker] (
  [Workerid],
  [WorkerFIO],
  [WorkerDoc],
  [WorkerType],
  [WorkerAddress],
  [Workerhone],
  [WorkerPosition]
    )
VALUES 
()
GO

/*Поставка товара*/
INSERT INTO [Order] (
  [OrderId],
  [OrderBarCode],
  [OrderText],
  [Productsid],
  [DeliveryId],
  [StoreId],
  [OrderDate],
  [Statusid],
  [Workerid],
  [Size]
    )
VALUES 
()
GO


/*Общая поставка со всеми товарами*/
INSERT INTO [OrderBox] (
  [OrderBoxId],
  [OrderBoxBarCode],
  [OrderBoxText],
  [Orderid],
  [StoreId],
  [OrderBoxDate],
  [Statusid],
  [Workerid],
  [Size]
    )
VALUES 
()
GO

/*Приход*/
INSERT INTO [Delivery] (
  [DeliveryId],
  [Productsid],
  [ProductsText],
  [DeliverySize],
  [DeliveryDate]
    )
VALUES 
()
GO


/*Магазин*/
INSERT INTO [Store] (
  [StoreId],
  [StoreName],
  [StoreText],
  [StoreAddress]
    )
VALUES 
()
GO