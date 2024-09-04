SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- ‘ункци€ расчета суммы за услуги за мес€ц
-- =============================================
CREATE FUNCTION dbo.SumMonth (@CustomerId bigint, @OrderDate datetime2)
RETURNS numeric(18,2)
AS
BEGIN
	DECLARE @Result numeric(18,2)
	SELECT @Result=
(
SELECT 
Sum(P.ProductsUnit*PW.[Sum]) as [Sum]
FROM [Order] AS O
Join [Products] AS P ON P.Productsid=O.Productsid
Join [Customer] AS C ON C.CustomerId=P.CustomerId
Join [ProductsType] AS PT ON PT.ProductsTypeid=P.ProductsTypeid
Join [ProductsWork] AS PW ON PW.ProductsType=P.ProductsTypeid
WHERE CustomerId=@CustomerId
and o.OrderDate=@OrderDate
GROUP BY year (o.OrderDate), month (o.OrderDate)
)
	RETURN @Result

END
GO
