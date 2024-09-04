
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Description:	Просмотр товаров по поставщику
-- =============================================
ALTER PROCEDURE [dbo].[Report_AllProductsFromCustomer] 
@Customer nvarchar(250)
AS
BEGIN

select
c.CustomerName as [Постащик]
,c.CustomerText as [Информация по поставщику]
,p.ProductsName as [Продукт]
,p.ProductsText as [Информация по продукту]
,p.ProductsUnit as [Кол-во на складе]
from dbo.Customer as c
join dbo.Products as p on p.CustomerId=c.CustomerId
where c.CustomerName = @Customer
END
GO

