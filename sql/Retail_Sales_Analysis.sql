--Project: Retail Sales Analytics System Business Problem

--A retail company wants answers to: 10 Questions

--CEO wants the highest-value customers.
--Monthly Revenue Trend
--Month-over-Month Growth
--Rolling 3-Month Average
--Customer Churn Rate
--Prodcts Revenue Contribution %
--Revenue Contribution %
--Peak Sales Hour Analysis and Running Sales by Hour
--Customer Lifetime Value (CLV)
--Best Product for Month

--Retail Analytics Sales Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    JoinDate DATE
)
INSERT INTO Customers
(CustomerID, CustomerName, City, JoinDate)
VALUES
(1,'Amit','Mumbai','2024-01-10'),
(2,'Rahul','Pune','2024-01-15'),
(3,'Priya','Delhi','2024-02-05'),
(4,'Sneha','Mumbai','2024-02-20'),
(5,'Vikas','Bangalore','2024-03-01'),
(6,'Neha','Hyderabad','2024-03-15'),
(7,'Rohan','Chennai','2024-04-01'),
(8,'Pooja','Mumbai','2024-04-12'),
(9,'Kiran','Pune','2024-05-01'),
(10,'Anjali','Delhi','2024-05-20')
-- Proucts Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    UnitPrice DECIMAL(10,2)
)

INSERT INTO Products
(ProductID, ProductName, Category, UnitPrice)
VALUES
(101,'Laptop','Electronics',50000),
(102,'Mobile','Electronics',30000),
(103,'Printer','Electronics',10000),
(104,'Monitor','Electronics',15000),
(105,'Keyboard','Accessories',2000),
(106,'Mouse','Accessories',1000);

--Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    OrderDate DATETIME,
    Quantity INT,
    SalesAmount DECIMAL(10,2)
)
INSERT INTO Customers
(CustomerID, CustomerName, City, JoinDate)
VALUES
(1,'Amit','Mumbai','2024-01-10'),
(2,'Rahul','Pune','2024-01-15'),
(3,'Priya','Delhi','2024-02-05'),
(4,'Sneha','Mumbai','2024-02-20'),
(5,'Vikas','Bangalore','2024-03-01'),
(6,'Neha','Hyderabad','2024-03-15'),
(7,'Rohan','Chennai','2024-04-01'),
(8,'Pooja','Mumbai','2024-04-12'),
(9,'Kiran','Pune','2024-05-01'),
(10,'Anjali','Delhi','2024-05-20')

INSERT INTO Orders
(OrderID, CustomerID, ProductID, OrderDate, Quantity, SalesAmount)
VALUES

(1,1,101,'2025-01-05 10:15:00',1,50000),
(2,2,102,'2025-01-07 11:30:00',1,30000),
(3,3,103,'2025-01-10 14:45:00',2,20000),
(4,4,104,'2025-01-12 16:00:00',1,15000),
(5,5,105,'2025-01-15 09:20:00',3,6000),

(6,1,106,'2025-02-02 10:10:00',2,2000),
(7,2,101,'2025-02-05 13:30:00',1,50000),
(8,3,102,'2025-02-08 15:45:00',1,30000),
(9,4,104,'2025-02-10 17:10:00',2,30000),
(10,5,105,'2025-02-15 11:00:00',5,10000),

(11,6,101,'2025-03-01 09:00:00',1,50000),
(12,7,102,'2025-03-03 12:30:00',1,30000),
(13,8,103,'2025-03-06 14:20:00',2,20000),
(14,9,104,'2025-03-08 18:00:00',1,15000),
(15,10,106,'2025-03-10 10:00:00',4,4000),

(16,1,101,'2025-04-02 11:00:00',1,50000),
(17,2,103,'2025-04-05 13:15:00',1,10000),
(18,3,104,'2025-04-08 15:40:00',1,15000),
(19,4,105,'2025-04-10 09:30:00',2,4000),
(20,5,106,'2025-04-12 16:10:00',5,5000),

(21,6,102,'2025-05-01 10:15:00',1,30000),
(22,7,103,'2025-05-03 14:00:00',3,30000),
(23,8,104,'2025-05-05 12:00:00',1,15000),
(24,9,105,'2025-05-08 17:20:00',2,4000),
(25,10,101,'2025-05-10 09:00:00',1,50000),

(26,1,102,'2025-06-01 11:00:00',1,30000),
(27,2,103,'2025-06-03 13:45:00',2,20000),
(28,3,104,'2025-06-05 15:30:00',1,15000),
(29,4,105,'2025-06-08 10:10:00',4,8000),
(30,5,106,'2025-06-10 18:15:00',3,3000)

Select * from Products

Select * from Customers

Select * from Orders

--CEO wants the Top 5 highest-value customers.
SELECT Top 5
    c.CustomerID,
    c.CustomerName,
    SUM(o.SalesAmount) AS Revenue
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID,
    c.CustomerName
ORDER BY Revenue DESC

--Monthly Revenue Trend
SELECT
    YEAR(OrderDate) YearNo,
    MONTH(OrderDate) MonthNo,
    SUM(SalesAmount) Revenue
FROM Orders
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY YearNo, MonthNo;

--Month-over-Month Growth
WITH MonthlySales AS
(
SELECT
    YEAR(OrderDate) Yr,
    MONTH(OrderDate) Mn,
    SUM(SalesAmount) Revenue
FROM Orders
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
)

SELECT *,
       LAG(Revenue)
       OVER(ORDER BY Yr,Mn) PrevRevenue
FROM MonthlySales;

--Rolling 3-Month Average
SELECT
    YEAR(OrderDate) Yr,
    MONTH(OrderDate) Mn,
    SUM(SalesAmount) Revenue,
    AVG(SUM(SalesAmount))
    OVER(
        ORDER BY YEAR(OrderDate),MONTH(OrderDate)
        ROWS BETWEEN 2 PRECEDING
        AND CURRENT ROW
    ) RollingAvg
FROM Orders
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate);

--6. Customer Churn Rate
SELECT
    CustomerID,
    MAX(OrderDate) LastPurchase
FROM Orders
GROUP BY CustomerID
HAVING MAX(OrderDate)
<
DATEADD(DAY,-60,GETDATE());

--7. Revenue Contribution %
WITH RevenueCTE AS
(
SELECT
    ProductID,
    SUM(SalesAmount) Revenue
FROM Orders
GROUP BY ProductID
)

SELECT *,
Revenue * 100.0 /
SUM(Revenue) OVER()
AS ContributionPercent
FROM RevenueCTE
ORDER BY ContributionPercent DESC;

--8. Peak Sales Hour Analysis and Running Sales by Hour
WITH Hourcte as 
(SELECT
	DATEPART(DAY, OrderDate)Day_,
    DATEPART(HOUR,OrderDate) SalesHour,
    SUM(SalesAmount) Revenue
FROM Orders
GROUP BY DATEPART(HOUR,OrderDate),
DATEPART(DAY, OrderDate))

Select *, sum(Revenue)
	over(order by Day_, SalesHour) as peackhour
	from Hourcte

--9. Customer Lifetime Value (CLV)
SELECT
    CustomerID,
    SUM(SalesAmount) CLV
FROM Orders
GROUP BY CustomerID;

--Bestr Product for Month
WITH ProductSales AS
(
SELECT
    MONTH(OrderDate) Mn,
    ProductID,
    SUM(SalesAmount) Revenue,
    ROW_NUMBER()
    OVER(
        PARTITION BY MONTH(OrderDate)
        ORDER BY SUM(SalesAmount) DESC
    ) rn
FROM Orders
GROUP BY
    MONTH(OrderDate),
    ProductID
)

SELECT *
FROM ProductSales
WHERE rn = 1;