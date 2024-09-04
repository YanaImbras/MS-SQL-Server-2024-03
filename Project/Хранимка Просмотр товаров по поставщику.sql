
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Description:	�������� ������� �� ����������
-- =============================================
ALTER PROCEDURE [dbo].[Report_AllProductsFromCustomer] 
@Customer nvarchar(250)
AS
BEGIN

select
c.CustomerName as [��������]
,c.CustomerText as [���������� �� ����������]
,p.ProductsName as [�������]
,p.ProductsText as [���������� �� ��������]
,p.ProductsUnit as [���-�� �� ������]
from dbo.Customer as c
join dbo.Products as p on p.CustomerId=c.CustomerId
where c.CustomerName = @Customer
END
GO

