-- ����������\���������
INSERT INTO [Customer] (
  [CustomerId],
  [CustomerName],
  [CustomerType],
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
(1,'��� ����','��������','text1',11,12,13,'bank1',14,15,16,'adress1'),
(2,'�� ������','��������','text2',21,22,23,'bank1',24,25,26,'adress2'),
(3,'�� ����','��������','text3',31,32,33,'bank2',34,35,36,'adress3'),
(4,'�� ������','��������','text4',41,42,43,'bank3',44,45,46,'adress4'),
(5,'��� ����','���������','text1',11,12,13,'bank1',14,15,16,'adress1'),
(6,'��� �����','���������','text6',61,62,63,'bank2',64,65,66,'adress6'),
(7,'�� �������','���������','text7',71,72,73,'bank2',74,75,76,'adress7'),
(8,'�� �����','���������','text8',81,82,83,'bank2',84,85,86,'adress8')
GO

/*�������*/
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

/*�����\�������*/
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
(1,'�������1','text1�',101,'link1',102,1,1,100),
(2,'�������2','text2�',201,'link2',202,1,1,100),
(3,'�������3','text3�',301,'link3',302,1,2,100),
(4,'�������4','text4�',401,'link4',402,2,1,100),
(5,'�������5','text5�',501,'link5',502,2,1,100),
(6,'�������6','text6�',601,'link6',602,2,1,1),
(7,'�������7','text7�',701,'link7',102,2,3,100)
GO

/*��� ��������*/
INSERT INTO [ProductsType] (
  [ProductsTypeid],
  [ProductsTypeName],
  [ProductsText]
)
VALUES 
(1,'�����������','����������� �������'),
(2,'��������','��������� ���������� ���������� ��������'),
(3,'�������','��������� �� ��������� ������������ ���������')
GO

/*��� �����*/
INSERT INTO [ProductsWork] (
  [ProductsWorkid],
  [ProductsWorkName],
  [ProductsWorkText],
  [ProductsType],
  [Sum]
    )
VALUES 
(1,'��������','�������� �� ����',1,10.20),
(2,'�����','����� �� ����������',1,100.00),
(3,'��������','�������� �� ����� ��������',1,1.50),
(4,'�������� �������','�������� � �������',2,10.00),
(5,'�������� ������','�������� � �����\�������',2,5.00),
(6,'�������� ���','�������� � ���-�����',3,10.20)
GO

/*���������*/
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
(1,'������ ���� ��������','������� 1234 567688',1,'��� ������ 5',null,'������'),
(2,'�������� ������� ����������','������� 4231 6874788',2,'��� ����������� 100',null,'��������')
GO

/*������*/
INSERT INTO [Delivery] (
  [DeliveryId],
  [Productsid],
  [ProductsText],
  [DeliverySize],
  [DeliveryDate]
    )
VALUES 
(1, 1, 'text12', 10,'01.07.2024'),
(2, 2, 'text22', 100,'01.07.2024'),
(3, 2, 'text32', 5,'01.07.2024'),
(4, 1, 'text42', 10,'01.07.2024'),
(5, 3, 'text52', 15,'01.07.2024')
GO

/*�������� ������*/
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


/*����� �������� �� ����� ��������*/
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
(2, 10001,'OrderBoxText1', 2, 1, '20.07.2024',1,1,27),
(3, 10001,'OrderBoxText1', 3, 1, '20.07.2024',1,1,37),
(4, 10001,'OrderBoxText1', 2, 1, '20.07.2024',1,1,67),
(5, 20001,'OrderBoxText2', 4, 1, '20.07.2024',1,1,47),
(6, 20001,'OrderBoxText2', 1, 1, '20.07.2024',1,1,47)
GO


