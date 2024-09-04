Select 
	ord.CustomerID, 
	det.StockItemID, 
	SUM(det.UnitPrice), 
	SUM(det.Quantity), 
	COUNT(ord.OrderID)
FROM Sales.Orders AS ord
	JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
	JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID
	JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID 
	JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID 
WHERE Inv.BillToCustomerID != ord.CustomerID
AND 
	(
		Select 
		SupplierId
		FROM Warehouse.StockItems AS It
		Where It.StockItemID = det.StockItemID
	) = 12
AND 
	(
		SELECT 
		SUM(Total.UnitPrice*Total.Quantity)
		FROM Sales.OrderLines AS Total
		Join Sales.Orders AS ordTotal ON ordTotal.OrderID = Total.OrderID
		WHERE ordTotal.CustomerID = Inv.CustomerID
	) > 250000
AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID

--Оптимизированный текст запроса
SELECT 
	ord.CustomerID, 
	det.StockItemID, 
	SUM(det.UnitPrice), 
	SUM(det.Quantity), 
	COUNT(ord.OrderID)
FROM Sales.Orders AS ord
	JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
	JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID 
									AND Inv.BillToCustomerID != ord.CustomerID --вынесено
	JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
	JOIN Warehouse.StockItems AS It ON It.StockItemID = det.StockItemID 
									AND It.SupplierId = 12 --вынесено из доп.селект
	JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID
WHERE DATEDIFF(DAY, Inv.InvoiceDate, ord.OrderDate) = 0
AND (
        SELECT 
			SUM(Total.UnitPrice*Total.Quantity)
        FROM Sales.OrderLines AS Total
			JOIN Sales.Orders AS ordTotal ON ordTotal.OrderID = Total.OrderID
        WHERE ordTotal.CustomerID = ord.CustomerID
        GROUP BY ordTotal.CustomerID
    ) > 250000
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID
