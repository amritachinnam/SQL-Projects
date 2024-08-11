/* AMRITA CHINNAM */

DROP DATABASE IF EXISTS DATABASE_RECORDS;
CREATE DATABASE IF NOT EXISTS DATABASE_RECORDS;
USE DATABASE_RECORDS;

CREATE TABLE Customers_Online (
	CustomerID Int Not Null AUTO_INCREMENT PRIMARY KEY,
	First_Name VarChar(255) Not Null,
	Last_Name VarChar(255) Not Null,
	Gender Char(1) Not Null, 
    Address VarChar(255) Not Null,
    Postal_Code VarChar(50) Not Null,
    Country VarChar(255) Not Null,
    Phone VarChar(12) Not Null,
CONSTRAINT FULLNAME UNIQUE (Last_Name, First_Name)
);


CREATE TABLE Orders_Online(
	OrderID Int Not Null AUTO_INCREMENT PRIMARY KEY,
	OrderPlaced_Date Date Not Null,
    CustomerID Int Not Null,
    Amount DECIMAL(20,2),
CONSTRAINT CustomerIDFK FOREIGN KEY (CustomerID) REFERENCES Customers_Online(CustomerID) ON UPDATE CASCADE
);


CREATE TABLE Products_Online(
	ProductID Int Not Null AUTO_INCREMENT PRIMARY KEY,
	Product_Description VarChar(255) Not Null UNIQUE,
	Stock Int Not Null,
    Category VarChar(255) Not Null ,
    Price Decimal(10,2) Not Null
    );

CREATE TABLE OrdersAndProducts(
	OrderID Int Not Null,
	ProductID Int Not Null,
    Quantity DECIMAL(10) Not Null,
    OPID Int Not Null PRIMARY KEY AUTO_INCREMENT,
    
CONSTRAINT OrderIDFK FOREIGN KEY (OrderID) REFERENCES Orders_Online(OrderID) ON UPDATE CASCADE,
CONSTRAINT ProductIDFK FOREIGN KEY (ProductID) REFERENCES Products_Online(ProductID) ON UPDATE CASCADE
);
CREATE TABLE Payments(
	PaymentID Int Not Null AUTO_INCREMENT PRIMARY KEY,
	Payment_Date DATE Not Null,
	Payment_Method VarChar(255) Not Null,
    Payment_Option VarChar(255) Not Null ,
	OrderID Int Not Null,
CONSTRAINT ORDERIDFK2 FOREIGN KEY (OrderID) REFERENCES Orders_Online(OrderID) ON UPDATE CASCADE
);

CREATE TABLE EMI(
	EMI_Number_ID Int Not Null AUTO_INCREMENT PRIMARY KEY,
	Tenure INT,
	Monthly_Installment_Amount DECIMAL(20,2),
    EMI_Completed Char(1) Not Null DEFAULT 'N',
	PaymentID Int NOT NULL,
CONSTRAINT PaymentsIDFK FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID) ON UPDATE CASCADE
);

DELIMITER //
CREATE TRIGGER Insert_EMI_Record
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
IF NEW.Payment_Method = 'EMI' THEN
	INSERT INTO EMI (Tenure, Monthly_Installment_Amount, EMI_Completed, PaymentID) VALUES(NULL , NULL,'N',New.PaymentID);	
END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Update_Order_Amount
AFTER INSERT ON OrdersAndProducts
FOR EACH ROW
BEGIN
	UPDATE Orders_Online SET Amount = New.Quantity * (SELECT price FROM Products_Online WHERE ProductId = New.ProductId ) 
    WHERE OrderId = New.OrderId;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Update_EMI_Monthly_installment_Amount
BEFORE UPDATE ON EMI
FOR EACH ROW
BEGIN
IF NEW.Tenure IS NOT NULL THEN
	SET NEW.Monthly_Installment_Amount = (SELECT oo.Amount FROM Orders_Online as oo, Payments as p, EMI as e 
    WHERE e.PaymentID = p.PaymentID AND p.OrderID = oo.OrderID AND e.PaymentID = New.PaymentID)/ NEW.Tenure;
END IF;
END;
//
DELIMITER ;

INSERT INTO Customers_Online VALUES (
	1, 'Annie', 'Doe', 'F', '123 Main St', '12345', 'USA', '555-123-5678');
INSERT INTO Customers_Online VALUES (
     2,'Angel', 'Smith', 'F', '456 Main St', '23456', 'Canada','444-123-7655');
INSERT INTO Customers_Online VALUES (
	3, 'Bella', 'Johnson', 'F', '124 Oak St','34567','UK','333-123-7856');
INSERT INTO Customers_Online VALUES (
	4, 'Christopher', 'Steve', 'M','256 Pine St','56748','USA','222-657-4728');
INSERT INTO Customers_Online VALUES (
	5, 'Dove', 'Stem', 'M', '458 Elm St', '56899','Canada','666-879-5792' );
INSERT INTO Customers_Online VALUES (
	6, 'Faisa', 'Ali', 'M', '887 Maple St', '47839', 'UK', '999-875-3987');

INSERT INTO Orders_Online (OrderPlaced_Date, CustomerID) VALUES(
'2023-01-01', 1);
INSERT INTO Orders_Online (OrderPlaced_Date, CustomerID) VALUES(
'2023-02-01', 1);
INSERT INTO Orders_Online (OrderPlaced_Date, CustomerID) VALUES(
'2023-04-01', 2);
INSERT INTO Orders_Online (OrderPlaced_Date, CustomerID) VALUES(
'2023-02-01', 2);
INSERT INTO Orders_Online (OrderPlaced_Date, CustomerID) VALUES(
'2023-01-15', 3);
INSERT INTO Orders_Online (OrderPlaced_Date, CustomerID) VALUES(
'2023-11-28', 3);
INSERT INTO Orders_Online (OrderPlaced_Date, CustomerID) VALUES(
'2023-03-21', 4);
INSERT INTO Orders_Online (OrderPlaced_Date, CustomerID) VALUES(
'2023-12-31', 5);
INSERT INTO Orders_Online (OrderPlaced_Date, CustomerID) VALUES(
'2023-11-09', 5);
INSERT INTO Orders_Online (OrderPlaced_Date, CustomerID) VALUES(
'2023-05-11', 6);
INSERT INTO Orders_Online (OrderPlaced_Date, CustomerID) VALUES(
'2023-08-08', 6);
INSERT INTO Orders_Online (OrderPlaced_Date, CustomerID) VALUES(
'2023-08-08', 6);
INSERT INTO Orders_Online (OrderPlaced_Date, CustomerID) VALUES(
'2023-03-01', 2);

INSERT INTO Products_Online (Product_Description, Stock, Category, Price)
VALUES 
    ('iPhone 15 Pro 256GB', 100, 'iPhones', 1499.00),
    ('iPhone 15 256GB', 50, 'iPhones', 899.00),
    ('MacBook Pro 14 Inch', 100, 'Laptops', 1599.00),
    ('Apple Watch Series 9', 20, 'Watches', 499.00),
    ('Airpods Pro 2nd generation', 17, 'Airpods', 249.00),
    ('Waterproof Case for Airpods', 25, 'Accessories', 34.95),
    ('iPad Pro', 100, 'iPad',899.00),
    ('Apple Pencil 2nd generation', 25, 'Accessories', 137.06),
    ('iPhone 15 Pro Silicone Case', 100, 'Accessories', 49),
    ('Apple Watch Sport Band', 25, 'Accessories', 49);
    
INSERT INTO OrdersAndProducts (OrderID, ProductID, Quantity) 
VALUES
(1,1,2),
(2,4,1),
(3,7,2),
(3,2,1),
(4,3,1),
(5,7,2),
(6,2,1),
(7,2,5),
(8,6,1),
(9,5,6),
(10,9,1),
(11,9,1),
(11,10,1),
(12,4,2),
(13,8,1);


INSERT INTO Payments (Payment_Date, Payment_Method, Payment_Option, OrderID)
VALUES 
    ('2023-01-01', 'EMI', 'Credit Card', 1),
    ('2023-02-01', 'EMI', 'Credit Card', 2),
    ('2023-02-01', 'EMI', 'Credit Card', 3),
    ('2023-02-01', 'Full Payment', 'Credit Card', 4),
    ('2023-01-15', 'Full Payment', 'Debit Card', 5),
    ('2023-11-28', 'EMI','Credit Card', 6),
    ('2023-03-21', 'EMI','Credit Card', 7),
    ('2023-12-31', 'Full Payment','Debit Card', 8),
    ('2023-11-09', 'EMI','Credit Card', 9),
    ('2023-05-11', 'EMI','Credit Card', 10),
    ('2023-08-08', 'EMI','Credit Card', 11),
    ('2023-08-08', 'EMI','Credit Card', 12),
    ('2023-03-01', 'EMI','Credit Card', 13);
   
