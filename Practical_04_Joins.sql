-- ============================================================
-- EXPERIMENT NO. 4
-- Aim: Multi-Table Joins
-- Customer Order Management System
-- ============================================================

USE CollegeDB;

-- ============================================================
-- CREATE TABLES (as per manual example)
-- ============================================================

CREATE TABLE IF NOT EXISTS Persons (
    P_Id        INT PRIMARY KEY,
    LastName    VARCHAR(50),
    FirstName   VARCHAR(50),
    Address     VARCHAR(100),
    City        VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Orders (
    O_Id        INT PRIMARY KEY,
    OrderNo     INT,
    P_Id        INT
);

-- ============================================================
-- INSERT DATA
-- ============================================================

INSERT INTO Persons VALUES
(1, 'Hansen',    'Ola',   'Timoteivn 10', 'Sandnes'),
(2, 'Svendson',  'Tove',  'Borgvn 23',   'Sandnes'),
(3, 'Pettersen', 'Kari',  'Storgt 20',   'Stavanger');

INSERT INTO Orders VALUES
(1, 77895, 3),
(2, 44678, 3),
(3, 22456, 1),
(4, 24562, 1),
(5, 34764, 15);  -- P_Id 15 does not exist in Persons (for OUTER JOIN demo)

-- ============================================================
-- Customer-Order tables (real-world scenario)
-- ============================================================

CREATE TABLE IF NOT EXISTS Customers (
    CustomerID   INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100),
    Email        VARCHAR(100),
    City         VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS CustomerOrders (
    OrderID      INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID   INT,
    Product      VARCHAR(100),
    Amount       DECIMAL(10,2),
    OrderDate    DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Customers (CustomerName, Email, City) VALUES
('Rahul Sharma',  'rahul@example.com', 'Pune'),
('Sneha Patil',   'sneha@example.com', 'Mumbai'),
('Amit Verma',    'amit@example.com',  'Nashik'),
('Priya Joshi',   'priya@example.com', 'Nagpur');  -- No orders placed

INSERT INTO CustomerOrders (CustomerID, Product, Amount, OrderDate) VALUES
(1, 'Laptop',   55000.00, '2024-03-01'),
(1, 'Mouse',     500.00,  '2024-03-05'),
(2, 'Keyboard',  1200.00, '2024-03-02'),
(3, 'Monitor',  12000.00, '2024-03-03');

-- ============================================================
-- INNER JOIN
-- Retrieve all customers WHO HAVE placed orders
-- ============================================================

SELECT
    c.CustomerName,
    c.City,
    co.Product,
    co.Amount,
    co.OrderDate
FROM Customers c
INNER JOIN CustomerOrders co ON c.CustomerID = co.CustomerID;

-- Manual example: List persons with orders
SELECT Persons.LastName, Persons.FirstName, Orders.OrderNo
FROM Persons
INNER JOIN Orders ON Persons.P_Id = Orders.P_Id;

-- ============================================================
-- LEFT JOIN
-- Retrieve ALL customers, including those with NO orders
-- ============================================================

SELECT
    c.CustomerName,
    c.City,
    co.Product,
    co.Amount
FROM Customers c
LEFT JOIN CustomerOrders co ON c.CustomerID = co.CustomerID;

-- Manual example
SELECT Persons.LastName, Persons.FirstName, Orders.OrderNo
FROM Persons
LEFT JOIN Orders ON Persons.P_Id = Orders.P_Id;

-- ============================================================
-- RIGHT JOIN
-- Retrieve ALL orders, including those with no matching customer
-- ============================================================

SELECT
    c.CustomerName,
    co.Product,
    co.Amount,
    co.OrderDate
FROM Customers c
RIGHT JOIN CustomerOrders co ON c.CustomerID = co.CustomerID;

-- Manual example
SELECT Persons.LastName, Persons.FirstName, Orders.OrderNo
FROM Persons
RIGHT JOIN Orders ON Persons.P_Id = Orders.P_Id;

-- ============================================================
-- FULL OUTER JOIN
-- MySQL does not support FULL JOIN directly; simulate with UNION
-- ============================================================

SELECT
    c.CustomerName,
    co.Product,
    co.Amount
FROM Customers c
LEFT JOIN CustomerOrders co ON c.CustomerID = co.CustomerID

UNION

SELECT
    c.CustomerName,
    co.Product,
    co.Amount
FROM Customers c
RIGHT JOIN CustomerOrders co ON c.CustomerID = co.CustomerID;

-- Manual example (FULL JOIN via UNION)
SELECT Persons.LastName, Persons.FirstName, Orders.OrderNo
FROM Persons
LEFT JOIN Orders ON Persons.P_Id = Orders.P_Id

UNION

SELECT Persons.LastName, Persons.FirstName, Orders.OrderNo
FROM Persons
RIGHT JOIN Orders ON Persons.P_Id = Orders.P_Id;

-- ============================================================
-- ADDITIONAL: JOIN across Student-Course-Enrollment
-- ============================================================

-- All students and their enrolled courses (INNER JOIN)
SELECT
    s.Name        AS Student,
    c.CourseName,
    i.Name        AS Instructor,
    e.EnrollmentDate
FROM Student s
INNER JOIN Enrollment e  ON s.StudentID  = e.StudentID
INNER JOIN Course c      ON e.CourseID   = c.CourseID
INNER JOIN Instructor i  ON c.InstructorID = i.InstructorID
ORDER BY s.Name;
