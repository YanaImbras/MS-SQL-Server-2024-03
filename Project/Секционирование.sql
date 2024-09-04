/*
�������� � ����� ������� �������-�������� ��� ��������������� � ��������� �����������������. 
���� � ������� ��� ����� �������, �� ������ ������ ���� ������ �� ������� ������, 
�������� ������� � ������ �� ���������������, 
� ��������� ������ �� ������� (���������) - ������ �� ����, ��� ������� �������, ����� ������� �������� � ���������������� �������.
*/



create partition function pf_Year(datetime2) as range right 
	for values ('20240101','20250101','20260101','20270101') -- �������

create partition scheme ps_Year as partition pf_Year
to ([primary], Year1, Year2, Year3, Year4)


go


CREATE TABLE [Order] (
  [OrderId] bigint NOT NULL,/*������������ ������*/
  [OrderBarCode] nvarchar(250),/*������*/
  [OrderText] nvarchar(250),/*�����������*/
  [Productsid] bigint,/*�� ��������*/
  [DeliveryId] bigint,/*�� ��������*/
  [StoreId] bigint,/*�������*/
  [OrderDate] datetime2 NOT NULL,/*����*/
  [Statusid] bigint,/*������*/
  [Workerid] bigint,/*���������*/
  [Size] int,/*����������*/
  
) ON [ps_Year] (OrderDate)

GO

ALTER TABLE [Order] 
	ADD CONSTRAINT PK_Years PRIMARY KEY CLUSTERED  (OrderDate, OrderId)
	ON [ps_Year] (OrderDate)
go

--������� 2

CREATE TABLE [Order] (
  [OrderId] bigint NOT NULL,/*������������ ������*/
  [OrderBarCode] nvarchar(250),/*������*/
  [OrderText] nvarchar(250),/*�����������*/
  [Productsid] bigint,/*�� ��������*/
  [DeliveryId] bigint,/*�� ��������*/
  [StoreId] bigint,/*�������*/
  [OrderDate] datetime2 NOT NULL,/*����*/
  [Statusid] bigint,/*������*/
  [Workerid] bigint,/*���������*/
  [Size] int,/*����������*/
  PRIMARY KEY (
        [OrderId],[OrderDate]
    ) ON [ps_Year]([OrderDate])
)
GO
/*
�������� ������� dbo.Order
�� ������� - � ��� ����� ��������� ������ �� ���������, ������� ����� ���������� ��������� � ������� �������.
���� ��������������� - dbo.Order.OrderDate
*/