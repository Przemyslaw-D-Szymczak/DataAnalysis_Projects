#### Database and table creation ####

CREATE DATABASE water_corp_sales;
USE water_corp_sales;

CREATE TABLE SalesRepresentative
	(
		SalesRepresentativeID INT,
        SalesRepresentativeFirstName VARCHAR(10),
        SalesRepresentativeLastName VARCHAR(10),
        Department VARCHAR(10),
		PRIMARY KEY(SalesRepresentativeID)
    );

CREATE TABLE Customer
	(
		CustomerID INT,
        CustomerName VARCHAR(15),
        CustomerAdress VARCHAR(20),
        CustomerRegion VARCHAR(10),
		PRIMARY KEY(CustomerID)
    );

CREATE TABLE Category
	(
		CategoryID INT,
        Category VARCHAR(15),
		Subcategory VARCHAR(15),
		PRIMARY KEY(CategoryID)
    );
    
CREATE TABLE Product
	(
		ProductID INT,
		ProductName VARCHAR(20),
		CategoryID INT,
		Cost FLOAT,
        PRIMARY KEY(ProductID),
		FOREIGN KEY(CategoryID) REFERENCES Category(CategoryID)
    );

CREATE TABLE Purchase 
	(
		Invoice VARCHAR(20),
		InvoiceType VARCHAR(10),
		Date DATE,
		SalesRepresentativeID INT,
		CustomerID INT,
		ProductID INT,
		Quantity INT,
		Price FLOAT,
		FOREIGN KEY(SalesRepresentativeID) REFERENCES SalesRepresentative(SalesRepresentativeID),
        FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID),
        FOREIGN KEY(ProductID) REFERENCES Product(ProductID)
    );
 
#### data loading into tables ####

LOAD DATA INFILE "C:/Users/User/Desktop/DrinksCorp_SalesData/SalesRepresentative.csv" INTO TABLE SalesRepresentative
FIELDS TERMINATED BY ";"
IGNORE 1 ROWS;

LOAD DATA INFILE "C:/Users/User/Desktop/DrinksCorp_SalesData/Customer.csv" INTO TABLE Customer
FIELDS TERMINATED BY ";"
IGNORE 1 ROWS;

LOAD DATA INFILE "C:/Users/User/Desktop/DrinksCorp_SalesData/Category.csv" INTO TABLE Category
FIELDS TERMINATED BY ";"
IGNORE 1 ROWS;

LOAD DATA INFILE "C:/Users/User/Desktop/DrinksCorp_SalesData/Product.csv" INTO TABLE Product
FIELDS TERMINATED BY ";"
IGNORE 1 ROWS;

LOAD DATA INFILE "C:/Users/User/Desktop/DrinksCorp_SalesData/Purchase.csv" INTO TABLE Purchase
FIELDS TERMINATED BY ";"
IGNORE 1 ROWS;


#### example queries ####

-- Database example statistics:
SELECT 
	COUNT(DISTINCT(Invoice)) AS Invoice_count, 
	(SELECT COUNT(DISTINCT(Invoice)) FROM Purchase 
		WHERE InvoiceType="Return") AS Return_count,
    ROUND(AVG(Price),2) AS Mean_price,
    MAX(Quantity) AS Max_Quantity,
    ROUND(MIN(Quantity*Price),2) AS Max_Return_Value,
    ROUND(MAX(Quantity*Price),2) AS Highest_Revenue,
    (SELECT SalesRepresentativeID FROM Purchase 
		WHERE Quantity*Price = (SELECT MAX(Quantity*Price) FROM Purchase)) AS SalesRep_w_Highest_Revenue
FROM Purchase;


-- Calculations of Revenue, Cost, Profit and Margin for each invoice as a view:
CREATE VIEW Calculations AS
	SELECT 
		P.Invoice, P.InvoiceType, P.Date, P.SalesRepresentativeID, P.CustomerID, P.ProductID,
        ROUND(P.Price*P.Quantity,2) AS Revenue,
        ROUND(A.Cost*P.Quantity,2) AS Cost,
        ROUND(P.Price*P.Quantity-A.Cost*P.Quantity,2) AS Profit,
        ROUND((P.Price*P.Quantity-A.Cost*P.Quantity)/(P.Price*P.Quantity)*100,2) AS Margin
	FROM Purchase AS P
LEFT JOIN Product AS A ON P.ProductID=A.ProductID;


-- Months of 2023 and 2024 with highest revenue (Greater than 200k)
SELECT 
	YEAR(Date) AS Year, 
    MONTH(Date) AS Month, 
    ROUND(SUM(Revenue),2) AS Revenue,  
    ROUND(SUM(Profit),2) AS Profit
FROM Calculations
WHERE InvoiceType = "Purchase" && (YEAR(Date)=2023 || YEAR(Date)=2024)
GROUP BY Year, Month
HAVING SUM(Revenue) > 200000
ORDER BY Year, Month;


-- Ranking of customers in 2022
SELECT 
	DENSE_RANK() OVER(ORDER BY SUM(O.Revenue) DESC) AS Ranking,
    C.CustomerRegion, 
	C.CustomerName, 
    ROUND(SUM(O.Revenue),2) AS Revenue
FROM Calculations AS O
LEFT JOIN Customer AS C ON O.CustomerID=C.CustomerID
WHERE Year(O.Date)=2022
GROUP BY C.CustomerRegion, C.CustomerName;


-- SalesRepresentatives favourite Customers in 2021
SELECT 
	CONCAT(UPPER(S.Department), "-", LEFT(S.SalesRepresentativeFirstName,1), ".", S.SalesRepresentativeLastName) AS SalesRep_Code,
	C.CustomerName,
    COUNT(DISTINCT(Invoice)) AS Count,
    RANK() OVER(PARTITION BY S.SalesRepresentativeID ORDER BY COUNT(DISTINCT(Invoice)) DESC) AS Ranking
FROM Purchase AS P
LEFT JOIN SalesRepresentative AS S ON P.SalesRepresentativeID=S.SalesRepresentativeID
LEFT JOIN Customer AS C ON P.CustomerID=C.CustomerID
WHERE YEAR(Date)=2021
GROUP BY SalesRep_Code, P.CustomerID
ORDER BY Ranking, SalesRep_Code LIMIT 20;


-- Adding margin targets to category table
CREATE VIEW Category_w_target AS
SELECT 
	*,
    CASE 
		WHEN Category="Water" THEN 7
		WHEN Category="Juice" THEN 9
		WHEN Category="Fizzy Drink" THEN 14
	END AS Margin_target
FROM Category;


-- Results of products in the August of 2021
SELECT 
	P.ProductName AS Product,
    CONCAT(K.Subcategory, "-", K.Category) AS `Subcategory-Cateogry`,
    ROUND(SUM(C.Revenue),2) AS Revenue,
    ROUND(SUM(C.Revenue)/(SELECT SUM(Revenue) 
				FROM Calculations 
				WHERE YEAR(Date)=2021 AND MONTH(Date)=8)*100 ,2) AS Revenue_Proportion,
    ROUND(SUM(C.Profit),2) AS Profit,
    ROUND(SUM(C.Profit)/SUM(C.Revenue)*100, 2) AS Margin,
    CASE 
		WHEN ROUND(SUM(C.Profit)/SUM(C.Revenue)*100, 2)>=K.Margin_target THEN "Yes"
        ELSE "No"
	END AS Targer_Reached
FROM Calculations AS C
LEFT JOIN Product AS P ON C.ProductID=P.ProductID
LEFT JOIN Category_w_target AS K ON P.CategoryID=K.CategoryID
WHERE YEAR(Date)=2021 AND MONTH(Date)=8
GROUP BY P.ProductName
ORDER BY CONCAT(K.Category, "-", K.Subcategory), Profit;
