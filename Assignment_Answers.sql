use classicmodels;
-- Day3
-- Q1
select customerNumber,customerName,state,creditLimit from customers 
where state is not null and creditLimit between 50000 and 100000 
order by creditLimit desc;

-- Q2
select distinct(productline) from productlines where productLine like "%cars";
-- ------------------------------------------------------------------------------------------------------
-- Day4
-- Q1
select ordernumber,status,ifnull(comments,"-") as "comments" from orders where status="shipped";

-- Q2
select employeenumber, firstname,jobtitle,
case 
when jobtitle ="President" then "P"
when jobtitle like "Sales Manager%" or jobtitle like "Sale Manager%" then "SM"
when jobtitle like "Sales Rep" then "SP"
when jobtitle like "%VP%" then "VP"
end jobtitleabbreviation  from employees
order by jobtitle;
-- ------------------------------------------------------------------------------------------------------
-- Day5
-- Q1
select year(paymentdate) as "Year",min(amount) as "MinAmount" from payments group by year(paymentdate) order by year(paymentdate);

-- Q2
select year(orderdate) as "Year",concat("Q",quarter(orderdate)) as "Quarter", 
count(distinct customernumber) as "Uniquecustomers",count(*) as "totalOrders" from orders
group by year(orderdate),concat("Q",quarter(orderdate));

-- Q3
SELECT DATE_FORMAT(paymentDate, '%b') AS "Month",CONCAT(FORMAT(SUM(amount) / 1000, 0), 'K') AS "Amount"
FROM payments
GROUP BY DATE_FORMAT(paymentDate, '%b')
HAVING SUM(amount) BETWEEN 500000 AND 1000000
ORDER BY SUM(amount) DESC;
-- ------------------------------------------------------------------------------------------------------
-- Day6
-- Q1
create table journey (
Bus_ID int Not null,
Bus_Name varchar(50) Not null,
Source_Station varchar(50) Not null,
Destination varchar(50) Not null,
Email varchar(100) unique
);

-- Q2
create table vendor(
Vendor_ID int unique not null,
Name varchar(100) Not null,
Email varchar(100) unique,
Country varchar(100) default "N/A"
);

-- Q3
Create table movies(
Movie_ID varchar(100) unique not null,
Name varchar(100) not null,
Release_Year varchar(4) default '-',
Cast varchar(100) not null,
Gender varchar(6),
No_of_shows int check(No_of_shows>=0)
);

-- Q4
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
-- ------------------------------------------------------------------------------------------------------
-- day7
-- Q1
select employeenumber,concat(e.firstname," ",e.lastname) as "salesperson",count(distinct(customernumber)) as "Unique_customers"
from employees e inner join customers c
on e.employeeNumber=c.salesRepEmployeeNumber
group by employeeNumber,e.firstname,e.lastname
order by Unique_Customers DESC;

-- Q2
select customernumber,customername,productcode,productname,
sum(quantityordered) as "ordered_quantity",sum(quantityinstock) as "Total_inventory",
(sum(quantityinstock)-sum(quantityordered)) as "left_qty"
from customers c join orders o using (customerNumber)
join orderdetails d using (orderNumber)
join products p using (productCode)
group by customerNumber,customerName,productcode,productName
order by customerNumber;
-- Q3
create table laptop(laptop_name varchar(10));
insert into laptop values("Dell"),("HP");
create table colors(color_name varchar(10));
insert into colors values("White"),("Silver"),("Black");
select * from laptop cross join colors order by laptop_name;
-- Q4
create table project(
EmployeeID int not null,
FullName varchar(50),
Gender varchar(6),
ManagerID int
);
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
select m.fullname as "managername",e.fullname as "empname" from project e join project m
on e.managerid=m.employeeid;
-- ------------------------------------------------------------------------------------------------------
-- Day 8
create table facility(
Facility_ID int not null,
Name varchar(100),
State varchar(100),
Country varchar(100)
);
alter table facility modify Facility_id int auto_increment primary key;
alter table facility add City varchar(100) not null after name;
describe facility;
-- ------------------------------------------------------------------------------------------------------
-- Day 9
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
truncate university;
-- ------------------------------------------------------------------------------------------------------
-- Day 10
CREATE VIEW products_status AS SELECT YEAR(o.orderDate) AS Year,
CONCAT( count(od.priceEach), ' (', ROUND((SUM(od.priceEach * od.quantityOrdered) / (SELECT SUM(od2.priceEach * od2.quantityOrdered)
FROM OrderDetails od2)) * 100), '%)' ) AS Value
FROM Orders o JOIN OrderDetails od ON o.orderNumber = od.orderNumber
GROUP BY Year
ORDER BY Value desc; 
select * from products_status;
-- ------------------------------------------------------------------------------------------------------
-- Day 11
-- Q1
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

-- Q2
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
-- ------------------------------------------------------------------------------------------------------
-- Day12
-- Q1(incomplete)
select * from orders;
select year(orderdate),monthname(orderdate),count(ordernumber),
lag(count(orderdate)) over (order by year(orderdate)) as "%YoY Change" from orders
group by year(orderdate),monthname(orderdate);

-- Q2
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
-- ------------------------------------------------------------------------------------------------------
-- Day 13
-- Q1
SELECT * FROM customers;
SELECT * FROM orders;
SELECT customerNumber, customerName
FROM Customers
WHERE customerNumber NOT IN (
    SELECT DISTINCT customerNumber
    FROM Orders);
    
-- Q2
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

-- Q3
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

-- Q4
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
            
-- Q5
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
-- ------------------------------------------------------------------------------------------------------
-- Day 14
CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    EmailAddress VARCHAR(50));
DESC Emp_EH;

DELIMITER $$
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
    
    SELECT 'Values Inserted Successfully' AS Message;

END$$
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------
-- Day 15
CREATE TABLE Emp_BIT (
    Name VARCHAR(255),
    Occupation VARCHAR(255),
    Working_date DATE,
    Working_hours INT);

INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) VALUES
('Robin', 'Scientist', '2020-10-04', 12),
('Warner', 'Engineer', '2020-10-04', 10),
('Peter', 'Actor', '2020-10-04', 13),
('Marco', 'Doctor', '2020-10-04', 14),
('Brayden', 'Teacher', '2020-10-04', 12),
('Antonio', 'Business', '2020-10-04', 11);
SELECT * FROM Emp_BIT;

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
VALUES ('RANI', 'Hardware Engineer', '2023-02-17', -10);
SELECT * FROM Emp_BIT;
INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) 
VALUES ('RAJ', 'Software Engineer', '2024-02-17', -9);