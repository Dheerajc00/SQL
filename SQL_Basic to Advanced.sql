USE CLASSICMODELS;
-- DAY 3
/* Q. 1)Show customer number, customer name, state and credit limit from customers table for below conditions. 
Sort the results by highest to lowest values of creditLimit.	
State should not contain null values
credit limit should be between 50000 and 100000 */

select customerNumber,customerName,state,creditLimit from customers 
where state is not null and creditLimit between 50000 and 100000 
order by creditLimit desc;
------------------------------------------------------------------------------------------------------------------------------
-- DAY 3
/* Q. 2)	Show the unique productline values containing the word cars at the end from products table.*/

select distinct(productline) from productlines where productLine like "%cars";
-------------------------------------------------------------------------------------------------------------------

-- DAY 4
/* 1)	Show the orderNumber, status and comments from orders table for shipped status only. 
If some comments are having null values then show them as “-“. */

select ordernumber,status,ifnull(comments,"-") as "comments" from orders where status="shipped";
-------------------------------------------------------------------------------------------------------------------------
-- DAY 4
/* 2)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
If job title is one among the below conditions, then job title abbreviation column should show below forms.
●	President then “P”
●	Sales Manager / Sale Manager then “SM”
●	Sales Rep then “SR”
●	Containing VP word then “VP” */

select employeenumber, firstname,jobtitle,
case 
when jobtitle ="President" then "P"
when jobtitle like "Sales Manager%" or jobtitle like "Sale Manager%" then "SM"
when jobtitle like "Sales Rep" then "SP"
when jobtitle like "%VP%" then "VP"
end jobtitleabbreviation  from employees
order by jobtitle;
--------------------------------------------------------------------------------------------------------------------------

-- DAY 5
/* Q.payments1)	For every year, find the minimum amount value from payments table.*/

select year(paymentdate) as "Year",min(amount) as "MinAmount" from payments group by year(paymentdate) order by year(paymentdate);
-------------------------------------------------------------------------------------------------------------------------
-- DAY 5
/* Q.2)	For every year and every quarter, find the unique customers and total orders from orders table. 
Make sure to show the quarter as Q1,Q2 etc.*/

select year(orderdate) as "Year",concat("Q",quarter(orderdate)) as "Quarter", 
count(distinct customernumber) as "Uniquecustomers",count(*) as "totalOrders" from orders
group by year(orderdate),concat("Q",quarter(orderdate));
--------------------------------------------------------------------------------------------------------------------
-- DAY 5
/*3)	Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) 
with filter on total amount as 500000 to 1000000. Sort the output by total amount in descending mode. [ Refer. Payments Table]*/
SELECT DATE_FORMAT(paymentDate, '%b') AS "Month",CONCAT(FORMAT(SUM(amount) / 1000, 0), 'K') AS "Amount"
FROM payments
GROUP BY DATE_FORMAT(paymentDate, '%b')
HAVING SUM(amount) BETWEEN 500000 AND 1000000
ORDER BY SUM(amount) DESC;
---------------------------------------------------------------------------------------------------------------------------------
-- DAY 6
/* 1)	Create a journey table with following fields and constraints.

●	Bus_ID (No null values)
●	Bus_Name (No null values)
●	Source_Station (No null values)
●	Destination (No null values)
●	Email (must not contain any duplicates) */

create table journey (
Bus_ID int Not null,
Bus_Name varchar(50) Not null,
Source_Station varchar(50) Not null,
Destination varchar(50) Not null,
Email varchar(100) unique
);
-------------------------------------------------------------------------------------------------------------------------------------------
/* 2)	Create vendor table with following fields and constraints.
●	Vendor_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Email (must not contain any duplicates)
●	Country (If no data is available then it should be shown as “N/A”) */

create table vendor(
Vendor_ID int unique not null,
Name varchar(100) Not null,
Email varchar(100) unique,
Country varchar(100) default "N/A"
);
----------------------------------------------------------------------------------------------------------------------------------
/*   3)	Create movies table with following fields and constraints.
●	Movie_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Release_Year (If no data is available then it should be shown as “-”)
●	Cast (No null values)
●	Gender (Either Male/Female)
●	No_of_shows (Must be a positive number) */

Create table movies(
Movie_ID varchar(100) unique not null,
Name varchar(100) not null,
Release_Year varchar(4) default '-',
Cast varchar(100) not null,
Gender varchar(6),
No_of_shows int check(No_of_shows>=0)
);
--------------------------------------------------------------------------------------------------------------------------------
  /* 4)	Create the following tables. Use auto increment wherever applicable
a. Product
✔	product_id - primary key
✔	product_name - cannot be null and only unique values are allowed
✔	description
✔	supplier_id - foreign key of supplier table*/


/*b. Suppliers
✔	supplier_id - primary key
✔	supplier_name
✔	location*/


/*c. Stock
✔	id - primary key
✔	product_id - foreign key of product table
✔	balance_stock*/

create table suppliers(
supplier_id int auto_increment primary key,
supplier_name varchar(100) not null,
location varchar(100)
);
create table Product(
product_id int auto_increment primary key,
product_name varchar(100) unique not null,
description varchar(100),
supplier_id int not null,
foreign key(supplier_id) references suppliers(supplier_id)
);
create table stock(
id int auto_increment primary key,
product_id int not null,
foreign key(product_id) references Product(product_id),
balance_stock int not null
);
-----------------------------------------------------------------------------------------------------------------------------------
-- DAY 7
/*1)	Show employee number, Sales Person (combination of first and last names of employees), unique customers for each employee number 
and sort the data by highest to lowest unique customers.
Tables: Employees, Customers */
select employeenumber,concat(e.firstname," ",e.lastname) as "salesperson",count(distinct(customernumber)) as "Unique_customers"
from employees e inner join customers c
on e.employeeNumber=c.salesRepEmployeeNumber
group by employeeNumber,e.firstname,e.lastname
order by Unique_Customers DESC;
-------------------------------------------------------------------------------------------------------------------------------------------
/*2)	Show total quantities, total quantities in stock, left over quantities for each product and each customer. 
Sort the data by customer number.
Tables: Customers, Orders, Orderdetails, Products*/

select customernumber,customername,productcode,productname,
sum(quantityordered) as "ordered_quantity",sum(quantityinstock) as "Total_inventory",
(sum(quantityinstock)-sum(quantityordered)) as "left_qty"
from customers c join orders o using (customerNumber)
join orderdetails d using (orderNumber)
join products p using (productCode)
group by customerNumber,customerName,productcode,productName
order by customerNumber;
-------------------------------------------------------------------------------------------------------------------------------------------
/*3)	Create below tables and fields. (You can add the data as per your wish)
●	Laptop: (Laptop_Name)
●	Colours: (Colour_Name)
Perform cross join between the two tables and find number of rows.*/
-- Create the Laptop table
create table laptop(laptop_name varchar(10));
insert into laptop values("Dell"),("HP");
create table colors(color_name varchar(10));
insert into colors values("White"),("Silver"),("Black");
select * from laptop cross join colors order by laptop_name;
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
create table project(
EmployeeID int not null,
FullName varchar(50),
Gender varchar(6),
ManagerID int);
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
select m.fullname as "managername",e.fullname as "empname" from project e join project m
on e.managerid=m.employeeid;
--------------------------------------------------------------------------------------------------------------------------------------------
-- DAY 8
/* Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country*/

/* i) Alter the table by adding the primary key and auto increment to Facility_ID column.*/
 
 /* ii) Add a new column city after name with data type as varchar which should not accept any null values.*/
create table facility(
Facility_ID int not null,
Name varchar(100),
State varchar(100),
Country varchar(100)
);
alter table facility modify Facility_id int auto_increment primary key;
alter table facility add City varchar(100) not null after name;
describe facility;
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
/*Remove the spaces from everywhere and update the column like Pune University etc.*/
SET SQL_SAFE_UPDATES=0;
-- Remove extra spaces from the university names
create table university(
ID int not null,
Name varchar(100) not null);
INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
update university
set name=trim(replace(name,"  "," "));
select * from university;
-------------------------------------------------------------------------------------------------------------
-- DAY 10
/* Create the view products status. Show year wise total products sold. 
Also find the percentage of total value for each year.*/

CREATE VIEW products_status AS SELECT YEAR(o.orderDate) AS Year,
CONCAT( count(od.priceEach), ' (', ROUND((SUM(od.priceEach * od.quantityOrdered) / (SELECT SUM(od2.priceEach * od2.quantityOrdered)
FROM OrderDetails od2)) * 100), '%)' ) AS Value
FROM Orders o JOIN OrderDetails od ON o.orderNumber = od.orderNumber
GROUP BY Year
ORDER BY Value desc; 
select * from products_status;
---------------------------------------------------------------------------------------------------------------
-- DAY 11
/*1)	Create a stored procedure GetCustomerLevel which takes input as customer number and gives the output 
as either Platinum, Gold or Silver as per below criteria.
Table: Customers
●	Platinum: creditLimit > 100000
●	Gold: creditLimit is between 25000 to 100000
●	Silver: creditLimit < 25000*/
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerLevel`(cnum int)
BEGIN
  DECLARE customer_level VARCHAR(10);
  SELECT 
    CASE 
      WHEN creditLimit > 100000 THEN 'Platinum'
      WHEN creditLimit BETWEEN 25000 AND 100000 THEN 'Gold'
      ELSE 'Silver'
    END AS customer_level
  FROM Customers
  WHERE customernumber = cnum;
END$$
DELIMITER ;
----------------------------------------------------------------------------------------------------------
/*2)Create a stored procedure Get_country_payments which takes in year and country as inputs and 
gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)
Tables: Customers, Payments*/
select * from customers;
select * from payments;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_country_payments`(IN input_year INT,  IN input_country VARCHAR(255))
BEGIN
  DECLARE total_amount DECIMAL(10,2);
  SELECT 
    YEAR(p.paymentdate) AS payment_year,
    c.country,
    CONCAT(FORMAT(SUM(amount)/1000, 0),'K') AS Total_Amount
  FROM Payments p
  JOIN Customers c ON p.customernumber = c.customernumber
  WHERE YEAR(p.paymentdate) = input_year
    AND c.country = input_country
  GROUP BY YEAR(p.paymentdate), c.country
  ORDER BY YEAR(p.paymentdate), c.country;
END$$
DELIMITER ;
------------------------------------------------------------------------------------------------------------
-- DAY 12
/*1)	Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. 
Format the YoY values in no decimals and show in % sign.
Table: Orders*/
(incomplete)
select * from orders;
select year(orderdate),monthname(orderdate),count(ordernumber),
lag(count(orderdate)) over (order by year(orderdate)) as "%YoY Change" from orders
group by year(orderdate),monthname(orderdate);
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
-- Insert data into emp_udf table
/*Create a user defined function calculate_age which returns the age in years and months (e.g. 30 years 5 months)
 by accepting DOB column as a parameter.*/

create table Emp_UDF(Emp_ID int auto_increment primary key,Name varchar(20),DOB date);
INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `Age`(dob date) RETURNS varchar(20) CHARSET latin1
BEGIN
  DECLARE today DATE;
  DECLARE years INT;
  DECLARE months INT;
    SET today = CURDATE();

  SET years = YEAR(today) - YEAR(dob) - ((MONTH(today), DAY(today)) < (MONTH(dob), DAY(dob)));
  SET months = (MONTH(today) - MONTH(dob) + 12) % 12 + IF(DAY(today) >= DAY(dob), 1, 0);

  RETURN CONCAT(years, ' years ', months, ' months');
END$$
DELIMITER ;
select age(dob) from Emp_udf;
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

select * from customers;
select * from Orders;
SELECT c.customernumber,
       c.customername,
       COUNT(o.ordernumber) AS order_count
FROM Customers c
LEFT JOIN Orders o ON c.customernumber = o.customernumber
GROUP BY c.customernumber, c.customername
UNION
SELECT c.customernumber,
       c.customername,
       COUNT(o.ordernumber) AS Total_orders
FROM Orders o
LEFT JOIN Customers c ON c.customernumber = o.customernumber
GROUP BY c.customernumber, c.customername;

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
	MAX(product_count) AS "max(total)",
    MIN(product_count) AS "min(total)"
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
    COUNT(*) AS total
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
