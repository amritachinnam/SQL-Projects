/* AMRITA CHINNAM
    02133164 */
    
/*List all the tables from the database.*/
SELECT * FROM database_records.Customers_Online;
SELECT * FROM database_records.Orders_Online;
SELECT * FROM database_records.Products_Online;
SELECT * FROM database_records.OrdersAndProducts;
SELECT * FROM database_records.Payments;
SELECT * FROM database_records.EMI;

/* List all the customers from the country 'USA'*/
SELECT * FROM Customers_Online WHERE Country = 'USA';
/* There are two customers from the country USA.*/

/* Which customers have placed their orders in January 2023?*/
SELECT C.*, OO.OrderID, OO.OrderPlaced_Date
FROM Customers_Online AS C
JOIN Orders_Online AS OO ON C.CustomerID = OO.CustomerID
WHERE OO.OrderPlaced_Date BETWEEN '2023-01-01' AND '2023-01-31';
/* There were two orders that were placed in January 2023 by females.*/

/*What is the total amount spend by each customer? */
SELECT C.CustomerID, C.First_Name, C.Last_Name, FORMAT(SUM(OO.Amount),2) AS TotalAmount_in_USD
FROM Customers_Online AS C
JOIN Orders_Online AS OO ON C.CustomerID = OO.CustomerID
GROUP BY C.CustomerID, C.First_Name, C.Last_Name
ORDER BY TotalAmount_in_USD DESC;
/*This shows a list of goods sold to each customer. The highest totalamount from a customer is 4,495.00 USD while the lowest totalamount from a customer is 1,096 USD.*/

/*What is the most sold product? */
SELECT P.ProductID, P.Product_Description, SUM(OP.Quantity) AS TotalQuantity, Category, Price FROM Products_Online AS P, OrdersAndProducts AS OP 
WHERE P.ProductID = OP.ProductID GROUP BY ProductID ORDER BY TotalQuantity DESC;
/*The highest sold product is the iPhone 15 256GB while the lowest sold products are MacBook Pro 14 Inch, Waterproof Case for Airpods, Apple Pencil 2nd generation, and Apple Watch Sport Band. 
It is also observed that the iPhones are sold high in quantity while accessories are sold less in quantity than the rest. */

/*What is the list of all orders and their details? */
SELECT O.OrderID, O.OrderPlaced_Date, CONCAT(C.First_Name, ' ', C.Last_Name) AS CustomerName, P.Product_Description, OP.Quantity, O.Amount
FROM Orders_Online AS O
JOIN Customers_Online AS C ON O.CustomerID = C.CustomerID
JOIN OrdersAndProducts AS OP ON O.OrderID = OP.OrderID
JOIN Products_Online AS P ON OP.ProductID = P.ProductID
ORDER BY OrderPlaced_Date ASC;
/*This shows a list of all the orders placed by customers for specific products along with thier quantity and total amount.*/

/* What is the most chosen payment option? */
SELECT P.Payment_Option, COUNT(*) AS OptionCount, SUM(OO.Amount) AS TotalAmount
FROM Payments AS P JOIN Orders_Online AS OO ON P.OrderID = OO.OrderID
GROUP BY P.Payment_Option ORDER BY OptionCount DESC;
/*The most chosen payment option by customers is credit card with the highest total amount.*/

/* What is the most chosen payment method? */
SELECT P.Payment_Method, COUNT(*) AS OptionCount, SUM(OO.Amount) AS TotalAmount
FROM Payments AS P JOIN Orders_Online AS OO ON P.OrderID = OO.OrderID
GROUP BY P.Payment_Method ORDER BY OptionCount DESC;
/*The most chosen payment method by customers is an EMI with the highest total amount.*/

/*What is the chosen payment method for which category of products? */
SELECT
PO.Category, P.Payment_Method, GROUP_CONCAT(PO.ProductId) AS ProductIds, GROUP_CONCAT(OO.OrderId) AS OrderIds
FROM Payments AS P
JOIN Orders_Online AS OO ON P.OrderID = OO.OrderID
JOIN OrdersAndProducts AS OP ON OO.OrderID = OP.OrderID
JOIN Products_Online AS PO ON OP.ProductID = PO.ProductID
GROUP BY PO.Category, P.Payment_Method
ORDER BY PO.Category, P.Payment_Method;
/*The most chosen payment method by customers is an EMI for mostly all categories of products except Laptops.
We observe that EMI is an option chosen widely across all categories.*/

/*What is the distribution of products categories based on gender?*/
SELECT C.Gender, PO.Category, COUNT(*) AS ProductCount
FROM Customers_Online AS C
JOIN Orders_Online AS OO ON C.CustomerID = OO.CustomerID
JOIN OrdersAndProducts AS OP ON OO.OrderID = OP.OrderID
JOIN Products_Online AS PO ON OP.ProductID = PO.ProductID
GROUP BY C.Gender, PO.Category
ORDER BY Gender, ProductCount DESC;
/* Wide variety of categories have been chosen by women more than men. The most focused category of products for men are the accessories while,
the most focused category of products for women are iPhones. The least focused category of products across are the watches and laptops.*/

/* Updating EMI table with tenure values */

UPDATE EMI SET Tenure = 24 WHERE EMI_Number_ID = 1;
UPDATE EMI SET Tenure = 36 WHERE EMI_Number_ID = 2;
UPDATE EMI SET Tenure = 24 WHERE EMI_Number_ID = 3;
UPDATE EMI SET Tenure = 36 WHERE EMI_Number_ID = 4;
UPDATE EMI SET Tenure = 24 WHERE EMI_Number_ID = 5;
UPDATE EMI SET Tenure = 24 WHERE EMI_Number_ID = 6;
UPDATE EMI SET Tenure = 2 WHERE EMI_Number_ID = 7;
UPDATE EMI SET Tenure = 2 WHERE EMI_Number_ID = 8;
UPDATE EMI SET Tenure = 36 WHERE EMI_Number_ID = 9;
UPDATE EMI SET Tenure = 3 WHERE EMI_Number_ID = 10;

/*Altering table to add total amount column*/
ALTER TABLE EMI
ADD COLUMN Total_Amount DECIMAL(20,2);
UPDATE EMI
SET Total_Amount = Tenure * Monthly_Installment_Amount;

/*What is the entire list of EMI Payments?*/
SELECT P.Payment_Date, P.Payment_Method, E.Tenure, E.Monthly_Installment_Amount, E.Total_Amount
FROM Payments AS P
JOIN EMI AS E ON P.PaymentID = E.PaymentID
WHERE P.Payment_Method = 'EMI';
/*This is a display of the list of EMI payments.*/

/* Alter EMI table and add tenure completed and tenure remaining column */
ALTER TABLE EMI
ADD COLUMN Tenure_Completed DECIMAL(20,2);
UPDATE EMI
SET Tenure_Completed = 2;

ALTER TABLE EMI
ADD COLUMN Tenure_Remaining DECIMAL(20,2);
UPDATE EMI
SET Tenure_Remaining = Tenure - Tenure_Completed;

/* Updating Tenure remaining in EMI table */
UPDATE EMI
SET EMI_Completed = CASE WHEN Tenure_Remaining = 0 THEN 'Y' ELSE 'N' END;

/* List of all completed EMIs by customers for the products puchased */
SELECT 
    C.CustomerID, C.First_Name, C.Last_Name, E.EMI_Completed, PO.Product_Description
FROM Customers_Online AS C
JOIN Orders_Online AS OO ON C.CustomerID = OO.CustomerID
JOIN Payments AS P ON OO.OrderID = P.OrderID
JOIN EMI AS E ON P.PaymentID = E.PaymentID
JOIN OrdersAndProducts AS OP ON OO.OrderID = OP.OrderID
JOIN Products_Online AS PO ON OP.ProductID = PO.ProductID
WHERE E.EMI_Completed = 'Y';
/* The customer Faisa Ali has completed her EMIs for the product iPhone 15 Pro Silicone Case, and Apple watch sport band. */

/* List of customers with Active EMIs */
SELECT 
    C.CustomerID, C.First_Name, C.Last_Name, PO.Product_Description, E.EMI_Completed, E.Tenure_Remaining, E.Monthly_Installment_Amount, E.Total_Amount
FROM Customers_Online AS C
JOIN Orders_Online AS OO ON C.CustomerID = OO.CustomerID
JOIN Payments AS P ON OO.OrderID = P.OrderID
JOIN EMI AS E ON P.PaymentID = E.PaymentID
JOIN OrdersAndProducts AS OP ON OO.OrderID = OP.OrderID
JOIN Products_Online AS PO ON OP.ProductID = PO.ProductID
WHERE E.EMI_Completed = 'N'
ORDER BY E.Total_Amount DESC
LIMIT 3;
/* The top 3 Active EMIs have 22 months tenure remaining for the products iPhone 15, iPhone 15 Pro, Airpods pro 2nd generation. */

/* Understanding the list of repeat customers and their payment_method chosen */
SELECT C.First_Name, C.Last_Name, P.Payment_Method, OO.Amount, OO.OrderPlaced_Date
FROM Customers_Online AS C
JOIN Orders_Online AS OO ON C.CustomerID = OO.CustomerID
JOIN Payments AS P ON OO.OrderID = P.OrderID
ORDER BY C.First_Name, C.Last_Name, OO.OrderPlaced_Date;

/* We see that eventually the payment method chosen by every repeat customer is a shift to EMI payment method irrespective of the amount on the order.
Hence, the company can make focus on providing more EMI options to every new and existing customers to create better customer satisfaction. */



