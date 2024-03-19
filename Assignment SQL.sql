USE CLASSICMODELS;
-- DAY 3
/* Q. 1)Show customer number, customer name, state and credit limit from customers table for below conditions. 
Sort the results by highest to lowest values of creditLimit.	
State should not contain null values
credit limit should be between 50000 and 100000 */

DESC CUSTOMERS;
SELECT * FROM CUSTOMERS;

SELECT customerNumber, customerName, state, creditLimit
FROM customers
WHERE state IS NOT NULL
AND creditLimit BETWEEN 50000 AND 100000
ORDER BY creditLimit DESC;
------------------------------------------------------------------------------------------------------------------------------
-- DAY 3
/* Q. 2)	Show the unique productline values containing the word cars at the end from products table.*/

SELECT * FROM PRODUCTS;
SELECT DISTINCT productline
FROM products
WHERE productline LIKE '%cars';
-------------------------------------------------------------------------------------------------------------------

-- DAY 4
/* 1)	Show the orderNumber, status and comments from orders table for shipped status only. 
If some comments are having null values then show them as “-“. */

SELECT * FROM ORDERS;

SELECT ORDERNUMBER, STATUS, COALESCE(COMMENTS, '_') AS COMMENTS FROM ORDERS;
-- OR --
SELECT ORDERNUMBER, STATUS, 
       CASE
           WHEN COMMENTS IS NULL THEN "_"
           ELSE COMMENTS
       END AS COMMENTS
FROM ORDERS;
-------------------------------------------------------------------------------------------------------------------------
-- DAY 4
/* 2)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
If job title is one among the below conditions, then job title abbreviation column should show below forms.
●	President then “P”
●	Sales Manager / Sale Manager then “SM”
●	Sales Rep then “SR”
●	Containing VP word then “VP” */

SELECT * FROM EMPLOYEES;
SELECT employeeNumber, firstName, jobTitle,
CASE
WHEN JOBTITLE='PRESIDENT' THEN 'P'
WHEN JOBTITLE LIKE 'SALES MANAGER %' OR JOBTITLE LIKE 'SALE MANAGER %' THEN 'SM'
WHEN JOBTITLE='SALES REP' THEN 'SR'
WHEN JOBTITLE LIKE '%VP%' THEN 'VP'
ELSE null
END AS JOBTITLE_ABBREVATION
FROM EMPLOYEES;
--------------------------------------------------------------------------------------------------------------------------

-- DAY 5
/* Q.payments1)	For every year, find the minimum amount value from payments table.*/

SELECT YEAR(paymentdate) AS year, MIN(amount) AS min_amount
FROM payments
GROUP BY YEAR(paymentdate);
-------------------------------------------------------------------------------------------------------------------------
-- DAY 5
/* Q.2)	For every year and every quarter, find the unique customers and total orders from orders table. 
Make sure to show the quarter as Q1,Q2 etc.*/
select * from orders;
SELECT 
    year,
    quarter,
    COUNT(DISTINCT customerNumber) AS uniquecustomer,
    COUNT(orderNumber) AS total_orders
FROM (SELECT YEAR(orderdate) AS year,
        CONCAT('Q', QUARTER(orderdate)) AS quarter, ordernumber,customernumber
    FROM 
        orders) AS subquery
GROUP BY year,quarter;

-- OR

SELECT 
    year,
    quarter,
    COUNT(DISTINCT customerNumber) AS uniquecustomer,
    COUNT(orderNumber) AS total_orders
FROM (SELECT YEAR(orderdate) AS year,
      QUARTER(orderdate) AS quarter, ordernumber,customernumber
    FROM 
        orders) AS subquery
GROUP BY year,quarter;
--------------------------------------------------------------------------------------------------------------------
-- DAY 5
/*3)	Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) 
with filter on total amount as 500000 to 1000000. Sort the output by total amount in descending mode. [ Refer. Payments Table]*/
SELECT * FROM PAYMENTS;
SELECT 
    DATE_FORMAT(paymentdate, '%b') AS month, -- %b - function to extract and format the month name from a date value
    concat(FORMAT(SUM(amount) / 1000, 0), 'K') AS formatted_amount
FROM 
		payments
GROUP BY 
    month
HAVING 
    SUM(amount) BETWEEN 500000 AND 1000000
ORDER BY 
    SUM(amount) DESC;
---------------------------------------------------------------------------------------------------------------------------------
-- DAY 6
/* 1)	Create a journey table with following fields and constraints.

●	Bus_ID (No null values)
●	Bus_Name (No null values)
●	Source_Station (No null values)
●	Destination (No null values)
●	Email (must not contain any duplicates) */

CREATE TABLE journey (
    Bus_ID INT NOT NULL PRIMARY KEY,
    Bus_Name VARCHAR(50) NOT NULL,
    Source_Station VARCHAR(50) NOT NULL,
    Destination VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NOT NULL UNIQUE);
SELECT * FROM JOURNEY;
DESC JOURNEY;
-------------------------------------------------------------------------------------------------------------------------------------------
/* 2)	Create vendor table with following fields and constraints.
●	Vendor_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Email (must not contain any duplicates)
●	Country (If no data is available then it should be shown as “N/A”) */

CREATE TABLE vendor (
    Vendor_ID INT NOT NULL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Country VARCHAR(50) DEFAULT 'N/A');
SELECT * FROM VENDOR;
DESC VENDOR;
----------------------------------------------------------------------------------------------------------------------------------
/*   3)	Create movies table with following fields and constraints.
●	Movie_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Release_Year (If no data is available then it should be shown as “-”)
●	Cast (No null values)
●	Gender (Either Male/Female)
●	No_of_shows (Must be a positive number) */

CREATE TABLE movies (
    Movie_ID INT NOT NULL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Release_Year VARCHAR(20) DEFAULT '-',
    Cast VARCHAR(50) NOT NULL,
    Gender ENUM('Male', 'Female'),-- ENUM --ENUMERATED TYPE-Gender column can only have one of the two values: 'Male' or 'Female'.
    No_of_shows INT CHECK (No_of_shows > 0));
SELECT * FROM MOVIES;
DESC MOVIES;
--------------------------------------------------------------------------------------------------------------------------------
  /* 4)	Create the following tables. Use auto increment wherever applicable
a. Product
✔	product_id - primary key
✔	product_name - cannot be null and only unique values are allowed
✔	description
✔	supplier_id - foreign key of supplier table*/

CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id));  ----- 2ND STEP
SELECT * FROM PRODUCT;
DESC PRODUCT;

/*b. Suppliers
✔	supplier_id - primary key
✔	supplier_name
✔	location*/

CREATE TABLE Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(255),
    location VARCHAR(255)); ---- 1ST STEP
SELECT * FROM SUPPLIERS;
DESC SUPPLIERS;

/*c. Stock
✔	id - primary key
✔	product_id - foreign key of product table
✔	balance_stock*/

CREATE TABLE Stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    balance_stock INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id));
SELECT * FROM STOCK;
DESC STOCK;
-----------------------------------------------------------------------------------------------------------------------------------
-- DAY 7
/*1)	Show employee number, Sales Person (combination of first and last names of employees), unique customers for each employee number 
and sort the data by highest to lowest unique customers.
Tables: Employees, Customers */
DESC EMPLOYEES;
DESC CUSTOMERS;
SELECT * FROM EMPLOYEES;
SELECT * FROM CUSTOMERS;

SELECT      
    e.employeeNumber AS employee_number,     
    CONCAT(e.firstName, ' ', e.lastName) AS Sales_Person,     
    COUNT(DISTINCT c.customerNumber) AS unique_customers 
FROM      
    Employees e 
LEFT JOIN      
    Customers c ON e.employeeNumber = c.salesRepEmployeeNumber 
GROUP BY      
    e.employeeNumber, Sales_Person 
ORDER BY      
    unique_customers DESC;
-------------------------------------------------------------------------------------------------------------------------------------------
/*2)	Show total quantities, total quantities in stock, left over quantities for each product and each customer. 
Sort the data by customer number.
Tables: Customers, Orders, Orderdetails, Products*/

SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;
SELECT * FROM ORDERDETAILS;
SELECT * FROM PRODUCTS;

SELECT
    c.customerNumber,
    c.customerName,
    p.productCode,
    p.productName,
    SUM(od.quantityOrdered) AS total_quantities_ordered,
    SUM(p.quantityInStock) AS total_quantities_in_stock,
    SUM(p.quantityInStock) - SUM(od.quantityOrdered) AS leftover_quantities
FROM
    Customers c
INNER JOIN
    Orders o ON c.customerNumber = o.customerNumber
INNER JOIN
    Orderdetails od ON o.orderNumber = od.orderNumber
INNER JOIN
    Products p ON od.productCode = p.productCode
GROUP BY
    c.customerNumber,
    c.customerName,
    p.productCode,
    p.productName
ORDER BY
    c.customerNumber;
-------------------------------------------------------------------------------------------------------------------------------------------
/*3)	Create below tables and fields. (You can add the data as per your wish)
●	Laptop: (Laptop_Name)
●	Colours: (Colour_Name)
Perform cross join between the two tables and find number of rows.*/
-- Create the Laptop table
CREATE TABLE Laptop (
    Laptop_Name VARCHAR(50) PRIMARY KEY);
-- Create the Colours table
CREATE TABLE Colours (
    Colour_Name VARCHAR(50) PRIMARY KEY);

-- Insert sample data into the Laptop table
INSERT INTO Laptop (Laptop_Name) VALUES
    ('LENOVO'),
    ('DELL'),
    ('HP');
SELECT * FROM LAPTOP;

-- Insert sample data into the Colours table
INSERT INTO Colours (Colour_Name) VALUES
    ('Red'),
    ('Blue'),
    ('Green');
SELECT * FROM COLOURS;

-- Perform a cross join between the Laptop and Colours tables
SELECT Laptop.Laptop_Name, Colours.Colour_Name
FROM Laptop
CROSS JOIN Colours;

-- Count rows
SELECT COUNT(*) AS total_rows
FROM Laptop
CROSS JOIN Colours;
-----------------------------------------------------------------------------------------------------------------------------------------------
/* 4)	Create table project with below fields.
●	EmployeeID
●	FullName
●	Gender
●	ManagerID
Add below data into it.
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
Find out the names of employees and their related managers.*/

-- Create the project table
CREATE TABLE project (
    EmployeeID INT,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    ManagerID INT);
-- Insert data into the project table
INSERT INTO project VALUES(1, 'Pranaya', 'Male', 3),
(2, 'Priyanka', 'Female', 1),
(3, 'Preety', 'Female', NULL),
(4, 'Anurag', 'Male', 1),
(5, 'Sambit', 'Male', 1),
(6, 'Rajesh', 'Male', 3),
(7, 'Hina', 'Female', 3);
select * from project;

SELECT 
   m.FullName AS ManagerName,
   e.FullName AS EmployeeName
FROM 
    project AS e
LEFT JOIN 
    project AS m ON e.ManagerID = m.EmployeeID;
--------------------------------------------------------------------------------------------------------------------------------------------
-- DAY 8
/* Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country*/

CREATE TABLE facility (
    Facility_ID INT ,
    Name VARCHAR(50) ,
    State VARCHAR(50),
    Country VARCHAR(50));
    DESC FACILITY;
/* i) Alter the table by adding the primary key and auto increment to Facility_ID column.*/
ALTER TABLE facility
MODIFY COLUMN Facility_ID INT AUTO_INCREMENT PRIMARY KEY;
 DESC FACILITY;
 
 /* ii) Add a new column city after name with data type as varchar which should not accept any null values.*/
ALTER TABLE facility
ADD COLUMN city VARCHAR(50) NOT NULL AFTER Name;
 DESC FACILITY;
------------------------------------------------------------------------------------------------------------------------------------------
-- DAY 9
/* Create table university with below fields.
●	ID
●	Name
Add the below data into it as it is.
INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University"); */
-- Create the university table
CREATE TABLE University (
    ID INT,
    Name VARCHAR(50));
DESC UNIVERSITY;
-- Insert data into the university table
INSERT INTO University (ID, Name)
VALUES 
    (1, '       Pune          University     '), 
    (2, '  Mumbai          University     '),
    (3, '     Delhi   University     '),
    (4, 'Madras University'),
    (5, 'Nagpur University');
SELECT * FROM UNIVERSITY;

/*Remove the spaces from everywhere and update the column like Pune University etc.*/
SET SQL_SAFE_UPDATES=0;
-- Remove extra spaces from the university names
UPDATE University
SET Name = TRIM(REPLACE(Name, '   ', ' '));
SELECT * FROM University;
-------------------------------------------------------------------------------------------------------------
-- DAY 10 NEED HELP
/* Create the view products status. Show year wise total products sold. 
Also find the percentage of total value for each year.*/

---------------------------------------------------------------------------------------------------------------
-- DAY 11
/*1)	Create a stored procedure GetCustomerLevel which takes input as customer number and gives the output 
as either Platinum, Gold or Silver as per below criteria.
Table: Customers
●	Platinum: creditLimit > 100000
●	Gold: creditLimit is between 25000 to 100000
●	Silver: creditLimit < 25000*/
select * from customers;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerLevel`(IN customer_number INT)
BEGIN

    DECLARE customer_level VARCHAR(20);

    SELECT 
        CASE 
            WHEN creditLimit > 100000 THEN 'Platinum'
            WHEN creditLimit BETWEEN 25000 AND 100000 THEN 'Gold'
            ELSE 'Silver'
        END INTO customer_level
    FROM 
        Customers 
    WHERE 
        customerNumber = customer_number;

    SELECT customer_level AS Customer_Level;
END //
DELIMITER 
----------------------------------------------------------------------------------------------------------
/*2)Create a stored procedure Get_country_payments which takes in year and country as inputs and 
gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)
Tables: Customers, Payments*/
select * from customers;
select * from payments;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_country_payments`(IN input_year INT, IN input_country VARCHAR(255))
BEGIN
    SELECT 
        YEAR(paymentDate) AS Year,
        Country,
        CONCAT(FORMAT(SUM(amount) / 1000, 0), 'K') AS Total_Amount
    FROM 
        Payments
    JOIN 
        Customers ON Payments.customerNumber = Customers.customerNumber
    WHERE 
        YEAR(paymentDate) = input_year AND Customers.country = input_country
    GROUP BY 
        Year, Country;
END //
DELIMITER 
------------------------------------------------------------------------------------------------------------
-- DAY 12 NEED HELP
/*1)	Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. 
Format the YoY values in no decimals and show in % sign.
Table: Orders*/
----------------------------------------------------------------------------------------------------------------
/*2)	Create the table emp_udf with below fields.
●	Emp_ID
●	Name
●	DOB
Add the data as shown in below query.
INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), 
("Sanjay", "1995-05-21");*/

-- Create the emp_udf table
CREATE TABLE emp_udf (
    Emp_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50),
    DOB DATE);

-- Insert data into emp_udf table
INSERT INTO emp_udf (Name, DOB)
VALUES 
    ("Piyush", "1990-03-30"),
    ("Aman", "1992-08-15"),
    ("Meena", "1998-07-28"),
    ("Ketan", "2000-11-21"),
    ("Sanjay", "1995-05-21");
SELECT * FROM emp_udf;

/*Create a user defined function calculate_age which returns the age in years and months (e.g. 30 years 5 months)
 by accepting DOB column as a parameter.*/

DELIMITER//
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_age`(date_of_birth DATE) RETURNS varchar(50) CHARSET latin1
BEGIN
    DECLARE years INT;
    DECLARE months INT;
    DECLARE age_string VARCHAR(50);

    -- Calculate age in years
    SET years = TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE());

    -- Calculate age in months
    SET months = TIMESTAMPDIFF(MONTH, date_of_birth, CURDATE()) - years * 12;

    -- Construct age string
    SET age_string = CONCAT(years, ' years ', months, ' months');

    RETURN age_string;
END// 
DELIMITER 
---------------------------------------------------------------------------------------------------------------
-- Day 13
/*1)	Display the customer numbers and customer names from customers table who have not placed any orders using 
subquery Table: Customers, Orders */
SELECT * FROM customers;
SELECT * FROM orders;
SELECT customerNumber, customerName
FROM Customers
WHERE customerNumber NOT IN (
    SELECT DISTINCT customerNumber
    FROM Orders);
----------------------------------------------------------------------------------------------------------------
/*2)	Write a full outer join between customers and orders using union and get the customer number, 
customer name, count of orders for every customer.Table: Customers, Orders*/
-- FULL OUTER JOIN ERROR CODE 1064
----------------------------------------------------------------------------------------------------------------
/*3)	Show the second highest quantity ordered value for each order number.
Table: Orderdetails */
SELECT
    orderNumber,
    MAX(quantityOrdered) AS second_highest_quantity
FROM
    Orderdetails
WHERE
    quantityOrdered < (
        SELECT
            MAX(quantityOrdered)
        FROM
            Orderdetails od
        WHERE
            od.orderNumber = Orderdetails.orderNumber)
GROUP BY
    orderNumber;
------------------------------------------------------------------------------------------------------------------
/*4)	For each order number count the number of products and then find the min and max of the values among 
count of orders.
Table: Orderdetails*/
SELECT * FROM ORDERDETAILS;
SELECT
    MIN(product_count) AS min_product_count,
    MAX(product_count) AS max_product_count
FROM
    (SELECT
            orderNumber,
            COUNT(productCode) AS product_count
        FROM
            Orderdetails
        GROUP BY
            orderNumber) AS order_counts;
--------------------------------------------------------------------------------------------------------------------
/*5)Find out how many product lines are there for which the buy price value is greater than the average of 
buy price value. Show the output as product line and its count.*/
SELECT * FROM PRODUCTS;
SELECT
    productLine,
    COUNT(*) AS tot_count
FROM
    products
WHERE
    buyPrice > (SELECT AVG(buyPrice)
        FROM products)
GROUP BY
    productLine;
-------------------------------------------------------------------------------------------------------------
-- Day 14
/*Create the table Emp_EH. Below are its fields.
●	EmpID (Primary Key)
●	EmpName
●	EmailAddress*/
CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    EmailAddress VARCHAR(50));
DESC Emp_EH;

/*Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling 
concept. Show the message as “Error occurred” in case of anything wrong.*/

DELIMITER//
CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_Emp_EH`(IN emp_id_val INT,IN emp_name_val VARCHAR(255),
IN email_val VARCHAR(255))
BEGIN
    DECLARE exit handler for sqlexception
    BEGIN
        ROLLBACK; -- Rollback transaction if an error occurs
        SELECT 'Error occurred' AS Message; -- Show error message
    END;
    START TRANSACTION; -- Start transaction
    
    -- Insert values into Emp_EH table
    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (emp_id_val, emp_name_val, email_val);
    COMMIT; -- Commit transaction
    
    SELECT 'Values Inserted Successfully' AS Message; -- Show success message
END//
DELIMITER
----------------------------------------------------------------------------------------------------------------
-- DAY 15
/*Create the table Emp_BIT. Add below fields in it.
●	Name
●	Occupation
●	Working_date
●	Working_hours
Insert the data as shown in below query.
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11); */ 

-- Create the Emp_BIT table
CREATE TABLE Emp_BIT (
    Name VARCHAR(255),
    Occupation VARCHAR(255),
    Working_date DATE,
    Working_hours INT);
DESC Emp_BIT;
-- Insert data into the Emp_BIT table
INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) VALUES
('Robin', 'Scientist', '2020-10-04', 12),
('Warner', 'Engineer', '2020-10-04', 10),
('Peter', 'Actor', '2020-10-04', 13),
('Marco', 'Doctor', '2020-10-04', 14),
('Brayden', 'Teacher', '2020-10-04', 12),
('Antonio', 'Business', '2020-10-04', 11);
SELECT * FROM emp_BIT;


/*Create before insert trigger to make sure any new value of Working_hours, if it is negative, 
then it should be inserted as positive.*/
INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) 
VALUES ('John', 'Engineer', '2024-03-17', -8),
('JohnY', 'Engineer', '2023-03-17', -7);
SELECT * FROM Emp_BIT;
-- BEFORE INSERT TRIGGER
DELIMITER //
CREATE TRIGGER before_insert_Working_hours_positive
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = -NEW.Working_hours;
    END IF;
END//
DELIMITER ;

INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) 
VALUES ('RINI', 'TEACHER', '2023-02-17', -10);
SELECT * FROM Emp_BIT;
INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) 
VALUES ('RON', 'TEACHER', '2024-02-17', -9);