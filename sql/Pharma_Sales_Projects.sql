--Pharma Sales Analytics Database
-- Total Revenue
-- Top Customers
--Revenue by Region

--Customer Table
CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    CustomerType VARCHAR(50),
    City VARCHAR(50),
    JoinDate DATE
)

INSERT INTO Customers VALUES
(101,'Apollo Pharmacy','Retailer','Mumbai','2024-01-01'),
(102,'MedPlus','Retailer','Pune','2024-01-05'),
(103,'NetMeds','Online','Mumbai','2024-01-10'),
(104,'PharmEasy','Online','Mumbai','2024-01-15'),
(105,'Fortis Hospital','Hospital','Delhi','2024-01-20')

--Product Table
CREATE TABLE Products
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    UnitPrice DECIMAL(10,2)
)

INSERT INTO Products VALUES
(1001,'Paracetamol','Pain Relief',25),
(1002,'Metformin','Diabetes',90),
(1003,'Vitamin D3','Supplements',150),
(1004,'Amlodipine','Cardiac',110),
(1005,'Omeprazole','Gastro',80)

--Region Table
CREATE TABLE Regions
(
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(50)
)

INSERT INTO Regions VALUES
(1,'West'),
(2,'South'),
(3,'North'),
(4,'East')

--Sales Representative Table
CREATE TABLE SalesRep
(
    RepID INT PRIMARY KEY,
    RepName VARCHAR(100),
    RegionID INT
)

INSERT INTO SalesRep VALUES
(1,'Rahul',1),
(2,'Amit',2),
(3,'Priya',3),
(4,'Sneha',4)

--Sales Table
CREATE TABLE Sales
(
    SalesID INT PRIMARY KEY,
    OrderDate DATETIME,
    CustomerID INT,
    ProductID INT,
    RegionID INT,
    RepID INT,
    Quantity INT,
    DiscountPct DECIMAL(5,2),

    FOREIGN KEY(CustomerID)
    REFERENCES Customers(CustomerID),

    FOREIGN KEY(ProductID)
    REFERENCES Products(ProductID),

    FOREIGN KEY(RegionID)
    REFERENCES Regions(RegionID),

    FOREIGN KEY(RepID)
    REFERENCES SalesRep(RepID)
)

INSERT INTO Sales VALUES
(1,'2025-01-01',101,1001,1,1,50,5),
(2,'2025-01-02',102,1002,2,2,40,2),
(3,'2025-01-03',103,1003,3,3,25,3),
(4,'2025-01-04',104,1004,4,4,35,5),
(5,'2025-01-05',105,1005,1,1,60,4),
(6,'2025-01-06',101,1002,1,1,30,2),
(7,'2025-01-07',102,1003,2,2,20,5),
(8,'2025-01-08',103,1004,3,3,45,3),
(9,'2025-01-09',104,1005,4,4,70,4),
(10,'2025-01-10',105,1001,1,1,100,5)

--Check all table
Select * from Customers
Select * from Products
Select * from Regions
Select * from SalesRep
Select * from Sales

-- Total Revenue
SELECT 
SUM(s.Quantity * p.UnitPrice * (1-s.DiscountPct/100)) Revenue 
from Sales s inner join Products p
ON s.ProductID=p.ProductID

--Top Customers
SELECT
c.CustomerName,
SUM(
s.Quantity *
p.UnitPrice
) Revenue
FROM Sales s
INNER JOIN Customers c
ON s.CustomerID=c.CustomerID

INNER JOIN Products p
ON s.ProductID=p.ProductID

GROUP BY c.CustomerName
ORDER BY Revenue DESC

--Revenue by Region
SELECT
r.RegionName,
SUM(
s.Quantity *
p.UnitPrice
) Revenue
FROM Sales s

INNER JOIN Regions r
ON s.RegionID=r.RegionID

INNER JOIN Products p
ON s.ProductID=p.ProductID

GROUP BY r.RegionName
ORDER BY Revenue desc

--Top Sales Representative
SELECT
sr.RepName,
SUM(
s.Quantity *
p.UnitPrice
) Revenue
FROM Sales s

INNER JOIN SalesRep sr
ON s.RepID=sr.RepID

INNER JOIN Products p
ON s.ProductID=p.ProductID

GROUP BY sr.RepName
ORDER BY Revenue DESC

--Product Performance
SELECT
p.ProductName,
SUM(s.Quantity) QtySold
FROM Sales s

INNER JOIN Products p
ON s.ProductID=p.ProductID

GROUP BY p.ProductName
ORDER BY QtySold DESC

--Monthly Revenue Trend
SELECT
YEAR(OrderDate) Yr,
MONTH(OrderDate) Mn,

SUM(
s.Quantity *
p.UnitPrice
)
Revenue

FROM Sales s

INNER JOIN Products p
ON s.ProductID=p.ProductID

GROUP BY
YEAR(OrderDate),
MONTH(OrderDate)

ORDER BY Yr,Mn

--Running Revenue
SELECT
s.OrderDate,

SUM(
s.Quantity *
p.UnitPrice
)

AS RunningRevenue

FROM Sales s

INNER JOIN Products p
ON s.ProductID=p.ProductID
GROUP BY s.OrderDate

--Rank Products
SELECT
p.ProductName,

SUM(
s.Quantity *
p.UnitPrice
)
Revenue,

RANK()
OVER(
ORDER BY
SUM(
s.Quantity *
p.UnitPrice
) DESC
)
AS ProductRank

FROM Sales s

INNER JOIN Products p
ON s.ProductID=p.ProductID

GROUP BY p.ProductName

--Customer Churn
SELECT
c.CustomerName,
MAX(s.OrderDate)
AS LastPurchase

FROM Sales s

INNER JOIN Customers c
ON s.CustomerID=c.CustomerID

GROUP BY c.CustomerName

HAVING
MAX(s.OrderDate)
<
DATEADD(
DAY,-60,
GETDATE()
)

--Category Contribution %
SELECT
p.Category,

SUM(
s.Quantity *
p.UnitPrice
)
Revenue,

SUM(
s.Quantity *
p.UnitPrice
)*100.0

/

SUM(
SUM(
s.Quantity *
p.UnitPrice
))

OVER(ORDER BY p.Category)
AS ContributionPct

FROM Sales s

INNER JOIN Products p
ON s.ProductID=p.ProductID

GROUP BY p.Category

--
SELECT
p.Category,

SUM(
s.Quantity *
p.UnitPrice
)
Revenue,

SUM(
s.Quantity *
p.UnitPrice
)*100.0

/

SUM(
SUM(
s.Quantity *
p.UnitPrice
)
)

OVER()

AS ContributionPct

FROM Sales s

INNER JOIN Products p
ON s.ProductID=p.ProductID

GROUP BY p.Category;

--Best Product in Each Region
WITH CTE AS
(
SELECT
r.RegionName,
p.ProductName,
SUM(
s.Quantity
) Qty,
ROW_NUMBER()
OVER(
PARTITION BY r.RegionName
ORDER BY SUM(s.Quantity) DESC
)RN
FROM Sales s
INNER JOIN Products p
ON s.ProductID=p.ProductID
INNER JOIN Regions r
ON s.RegionID=r.RegionID
GROUP BY
r.RegionName,
p.ProductName
)

SELECT *
FROM CTE
WHERE RN IN(1,2)