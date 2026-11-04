-- ============================================================
-- EXPERIMENT NO. 5
-- Aim: PL/SQL Procedures and Functions
-- Sales Management System
-- ============================================================

USE CollegeDB;

-- ============================================================
-- CREATE SALES TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS Sales (
    SaleID      INT PRIMARY KEY AUTO_INCREMENT,
    Product     VARCHAR(100),
    Quantity    INT,
    UnitPrice   DECIMAL(10,2),
    TotalAmount DECIMAL(10,2),
    SaleDate    DATE
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(100),
    department  VARCHAR(50),
    salary      DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO Sales (Product, Quantity, UnitPrice, TotalAmount, SaleDate) VALUES
('Laptop',   3, 55000, 165000, '2024-03-01'),
('Mouse',   10,   500,   5000, '2024-03-02'),
('Keyboard', 5,  1200,   6000, '2024-03-03'),
('Monitor',  2, 12000,  24000, '2024-03-04'),
('Printer',  1, 15000,  15000, '2024-03-05');

INSERT INTO employees (name, department, salary) VALUES
('Rahul',  'IT',      60000),
('Sneha',  'HR',      45000),
('Amit',   'IT',      70000),
('Priya',  'Finance', 55000),
('Ravi',   'IT',      65000);

-- ============================================================
-- STORED PROCEDURE 1: Add a new sale record
-- ============================================================

DELIMITER //

CREATE PROCEDURE AddSale (
    IN p_Product    VARCHAR(100),
    IN p_Quantity   INT,
    IN p_UnitPrice  DECIMAL(10,2),
    IN p_SaleDate   DATE
)
BEGIN
    DECLARE v_Total DECIMAL(10,2);
    SET v_Total = p_Quantity * p_UnitPrice;

    INSERT INTO Sales (Product, Quantity, UnitPrice, TotalAmount, SaleDate)
    VALUES (p_Product, p_Quantity, p_UnitPrice, v_Total, p_SaleDate);

    SELECT CONCAT('Sale added successfully. Total: ', v_Total) AS Message;
END //

DELIMITER ;

-- Call the procedure
CALL AddSale('Webcam', 4, 2500, '2024-03-06');

-- ============================================================
-- STORED PROCEDURE 2: Increase employee salary
-- ============================================================

DELIMITER //

CREATE PROCEDURE IncreaseSalary (
    IN emp_id   INT,
    IN increment DECIMAL(10,2)
)
BEGIN
    UPDATE employees
    SET salary = salary + increment
    WHERE employee_id = emp_id;

    SELECT CONCAT('Salary updated for employee ID: ', emp_id) AS Message;
END //

DELIMITER ;

-- Call the procedure
CALL IncreaseSalary(1, 5000);

-- ============================================================
-- STORED PROCEDURE 3: Get all sales for a given product
-- ============================================================

DELIMITER //

CREATE PROCEDURE GetSalesByProduct (
    IN p_Product VARCHAR(100)
)
BEGIN
    SELECT * FROM Sales WHERE Product = p_Product;
END //

DELIMITER ;

-- Call the procedure
CALL GetSalesByProduct('Laptop');

-- ============================================================
-- FUNCTION 1: Calculate total sales amount
-- ============================================================

DELIMITER //

CREATE FUNCTION GetTotalSales()
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(15,2);
    SELECT SUM(TotalAmount) INTO total FROM Sales;
    RETURN total;
END //

DELIMITER ;

-- Call the function
SELECT GetTotalSales() AS TotalSalesAmount;

-- ============================================================
-- FUNCTION 2: Calculate employee bonus (10% of salary)
-- ============================================================

DELIMITER //

CREATE FUNCTION GetBonus (emp_salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN emp_salary * 0.10;
END //

DELIMITER ;

-- Call the function
SELECT name, salary, GetBonus(salary) AS Bonus FROM employees;

-- ============================================================
-- FUNCTION 3: Get total sales for a specific product
-- ============================================================

DELIMITER //

CREATE FUNCTION GetProductSalesTotal (p_Product VARCHAR(100))
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE prod_total DECIMAL(15,2);
    SELECT SUM(TotalAmount) INTO prod_total
    FROM Sales WHERE Product = p_Product;
    RETURN IFNULL(prod_total, 0);
END //

DELIMITER ;

-- Call the function
SELECT GetProductSalesTotal('Laptop') AS LaptopSalesTotal;
SELECT GetProductSalesTotal('Mouse')  AS MouseSalesTotal;

-- ============================================================
-- VIEW PROCEDURES AND FUNCTIONS
-- ============================================================

SHOW PROCEDURE STATUS WHERE Db = 'CollegeDB';
SHOW FUNCTION STATUS WHERE Db = 'CollegeDB';
