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
(8,'заказчик8','text8',81,82,83,'bank8',84,85,86,'adress8')
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
(1,'продукт1','text1п',101,'link1',102,1,1,100),
(2,'продукт2','text2п',201,'link2',202,1,1,100),
(3,'продукт3','text3п',301,'link3',302,1,2,100),
(4,'продукт4','text4п',401,'link4',402,2,1,100),
(5,'продукт5','text5п',501,'link5',502,2,1,100),
(6,'продукт6','text6п',601,'link6',602,2,1,1),
(7,'продукт7','text7п',701,'link7',102,2,3,100)
GO

/*Тип Продукта*/
INSERT INTO [ProductsType] (
  [ProductsTypeid],
  [ProductsTypeName],
  [ProductsText]
)
VALUES 
(1,'pr1','text11'),
(2,'pr2','text22'),
(3,'pr3','text33')
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
(1,'pwn1','pwt1',1,10),
(2,'pwn2','pwt2',1,10),
(3,'pwn3','pwt3',1,1),
(4,'pwn4','pwt4',2,5),
(5,'pwn5','pwt5',2,5),
(6,'pwn6','pwt6',3,20)
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
(1,'fio1','pas1',1,'adrw1',null,'w1'),
(2,'fio2','pas2',2,'adrw2',null,'w2')
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
(1,1001,'ot1',1,1,1,'01.07.2024',1,1,17),
(2,2001,'ot2',1,1,1,'02.07.2024',1,1,27),
(3,3001,'ot3',1,1,1,'03.07.2024',1,1,37),
(4,4001,'ot4',2,1,1,'04.07.2024',2,1,47),
(5,5001,'ot5',5,1,1,'05.07.2024',2,1,57),
(6,6001,'ot6',2,1,1,'06.07.2024',1,1,67)
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
(1, 10001,'OrderBoxText1', 1, 1, '20.07.2024',1,1,17),
(1, 10001,'OrderBoxText1', 2, 1, '20.07.2024',1,1,27),
(1, 10001,'OrderBoxText1', 3, 1, '20.07.2024',1,1,37),
(1, 10001,'OrderBoxText1', 6, 1, '20.07.2024',1,1,67),
(2, 20001,'OrderBoxText2', 4, 1, '20.07.2024',1,1,47),
(2, 20001,'OrderBoxText2', 4, 1, '20.07.2024',1,1,47)
GO

/*Приход*/
--INSERT INTO [Delivery] (
--  [DeliveryId],
--  [Productsid],
--  [ProductsText],
--  [DeliverySize],
--  [DeliveryDate]
--    )
--VALUES 
--()
--GO


/*Магазин*/
INSERT INTO [Store] (
  [StoreId],
  [StoreName],
  [StoreText],
  [StoreAddress]
    )
VALUES 
(1,'s1','ts1','sadr1'),
(2,'s2','ts2','sadr2'),
(3,'s3','ts3','sadr3'),
(4,'s4','ts4','sadr4'),
(5,'s5','ts5','sadr5')
GO