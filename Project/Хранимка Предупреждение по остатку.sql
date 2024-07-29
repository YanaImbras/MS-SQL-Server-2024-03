
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Description:	Предупреждение по остатку
-- =============================================
ALTER PROCEDURE [dbo].[Report_UnitInfo] 
@Customer nvarchar(250)
AS
BEGIN

create table #UnitMailInfo
(
[Постащик] nvarchar(250)
,[Информация по поставщику] nvarchar(250)
,[Продукт] nvarchar(250)
,[Информация по продукту] nvarchar(250)
,[Кол-во на складе] int
)

insert into #UnitMailInfo
(
[Постащик]
,[Информация по поставщику]
,[Продукт]
,[Информация по продукту]
,[Кол-во на складе]
)
select
c.CustomerName as [Постащик]
,c.CustomerText as [Информация по поставщику]
,p.ProductsName as [Продукт]
,p.ProductsText as [Информация по продукту]
,p.ProductsUnit as [Кол-во на складе]
from dbo.Customer as c
join dbo.Products as p on p.CustomerId=c.CustomerId
where c.CustomerName = @Customer
and p.ProductsUnit <=5

drop table #UnitMailInfo

END

GO
