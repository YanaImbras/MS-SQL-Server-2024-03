
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Description:	�������������� �� �������
-- =============================================
ALTER PROCEDURE [dbo].[Report_UnitInfo] 
@Customer nvarchar(250)
AS
BEGIN

create table #UnitMailInfo
(
[��������] nvarchar(250)
,[���������� �� ����������] nvarchar(250)
,[�������] nvarchar(250)
,[���������� �� ��������] nvarchar(250)
,[���-�� �� ������] int
)

insert into #UnitMailInfo
(
[��������]
,[���������� �� ����������]
,[�������]
,[���������� �� ��������]
,[���-�� �� ������]
)
select
c.CustomerName as [��������]
,c.CustomerText as [���������� �� ����������]
,p.ProductsName as [�������]
,p.ProductsText as [���������� �� ��������]
,p.ProductsUnit as [���-�� �� ������]
from dbo.Customer as c
join dbo.Products as p on p.CustomerId=c.CustomerId
where c.CustomerName = @Customer
and p.ProductsUnit <=5

drop table #UnitMailInfo

END

GO
