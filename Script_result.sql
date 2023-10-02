-- 1 Формируем список клиентов с наибольшей суммой заказов,
select c.LastName, c.FirstName, sum(o.TotalAmount) as CustomerSum 
from Orders o 
  inner join Customers c on  c.CustomerID = o.CustomerID
group by c.LastName, c.FirstName 
order by 
  CustomerSum desc
limit 3  
    

-- 2. Формируем для каждого клиента из пункта 1 выводим список его 
-- заказов (номер заказа и общая сумма) в порядке убывания общей суммы заказов.
-- ограничиваем количество 3 лидерами
with Liders as (
  select o.CustomerID, 
    sum(o.TotalAmount) as CustomerSum
  from Orders o 
  group by o.CustomerID
  order by CustomerSum desc
  limit 3
)
-- Показываем заказы только для лидеров
select c.LastName, c.FirstName, o.OrderID as OrderNo, o.TotalAmount,
  sum(o.TotalAmount) over (partition by o.CustomerID) as TotalSum
from Orders o 
  inner join Customers c on  c.CustomerID = o.CustomerID 
where c.CustomerId in (select CustomerID from Liders)
order by 
  TotalSum desc, o.CustomerID, TotalAmount desc  

  
-- 3. Выводим только тех клиентов, у которых общая сумма заказов превышает среднюю общую сумму
--    заказов всех клиентов.
with CustomerAmounts as (
  select o.CustomerID, sum(o.TotalAmount) as CustomerTotalSum
  from Orders o 
  group by o.CustomerID
)

select c.LastName, c.FirstName, a.CustomerTotalSum
from CustomerAmounts a
  inner join Customers c on c.CustomerID=a.CustomerID
where a.CustomerTotalSum > (select avg(CustomerTotalSum) from CustomerAmounts)
order by a.CustomerTotalSum desc

  