  -- Рассчитываем суммы заказов по клиентам
  with CustomerSums AS (
	select CustomerID, SUM(TotalAmount) as CustomerTotalSum
	from Orders
	group by CustomerID
  ),
  -- Отбираем клиентов с суммой заказов выше среднего 
  Liders AS (
    select c.CustomerID, c.LastName, c.FirstName, s.CustomerTotalSum
	from CustomerSums s
	  left inner join Customers c  on s.CustomerID = c.CustomerID
	where s.CustomerTotalSum > (select avg(CustomerTotalSum) from CustomerSums)
  )
  
-- 
select l.LastName, l.FirstName, o.OrderID, o.TotalAmount, l.CustomerTotalSum
from Orders o 
  left inner join Liders l on  l.CustomerID = o.CustomerID
order by 
  l.CustomerTotalSum desc, l.CustomerID, o.TotalAmount desc

  