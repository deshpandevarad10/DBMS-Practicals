-- ============================================================
-- EXPERIMENT NO. 6
-- Aim: Triggers and Cursors
-- Employee Management System
-- ============================================================

USE CollegeDB;

-- ============================================================
-- CREATE TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS Employees (
    EmpID       INT PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(100),
    Department  VARCHAR(50),
    Salary      DECIMAL(10,2),
    JoinDate    DATE
);

CREATE TABLE IF NOT EXISTS Employee_Audit (
    AuditID     INT PRIMARY KEY AUTO_INCREMENT,
    EmpID       INT,
    Action      VARCHAR(10),   -- INSERT / UPDATE / DELETE
    OldSalary   DECIMAL(10,2),
    NewSalary   DECIMAL(10,2),
    ActionTime  DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample employees
INSERT INTO Employees (Name, Department, Salary, JoinDate) VALUES
('Rahul Sharma',  'IT',      60000, '2022-01-10'),
('Sneha Patil',   'HR',      45000, '2021-06-15'),
('Amit Kumar',    'IT',      70000, '2020-03-20'),
('Priya Desai',   'Finance', 55000, '2023-07-01'),
('Ravi Joshi',    'IT',      65000, '2019-11-05'),
('Meena Nair',    'HR',      48000, '2022-08-12');

-- ============================================================
-- TRIGGER 1: BEFORE INSERT – Validate salary
-- ============================================================

DELIMITER //

CREATE TRIGGER before_emp_insert
BEFORE INSERT ON Employees
FOR EACH ROW
BEGIN
    IF NEW.Salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative.';
    END IF;
END //

DELIMITER ;

-- ============================================================
-- TRIGGER 2: AFTER INSERT – Log new employee
-- ============================================================

DELIMITER //

CREATE TRIGGER after_emp_insert
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO Employee_Audit (EmpID, Action, OldSalary, NewSalary)
    VALUES (NEW.EmpID, 'INSERT', NULL, NEW.Salary);
END //

DELIMITER ;

-- ============================================================
-- TRIGGER 3: AFTER UPDATE – Log salary change
-- ============================================================

DELIMITER //

CREATE TRIGGER after_emp_update
AFTER UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF OLD.Salary <> NEW.Salary THEN
        INSERT INTO Employee_Audit (EmpID, Action, OldSalary, NewSalary)
        VALUES (NEW.EmpID, 'UPDATE', OLD.Salary, NEW.Salary);
    END IF;
END //

DELIMITER ;

-- ============================================================
-- TRIGGER 4: AFTER DELETE – Log deleted employee
-- ============================================================

DELIMITER //

CREATE TRIGGER after_emp_delete
AFTER DELETE ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO Employee_Audit (EmpID, Action, OldSalary, NewSalary)
    VALUES (OLD.EmpID, 'DELETE', OLD.Salary, NULL);
END //

DELIMITER ;

-- ============================================================
-- TEST TRIGGERS
-- ============================================================

-- Test INSERT trigger (logs to audit)
INSERT INTO Employees (Name, Department, Salary, JoinDate)
VALUES ('Aisha Khan', 'IT', 72000, '2024-01-15');

-- Test UPDATE trigger (logs salary change)
UPDATE Employees SET Salary = 75000 WHERE Name = 'Aisha Khan';

-- Test DELETE trigger (logs deletion)
DELETE FROM Employees WHERE Name = 'Aisha Khan';

-- View audit log
SELECT * FROM Employee_Audit;

-- ============================================================
-- CURSOR: Give 10% salary increment to all IT department employees
-- ============================================================

DELIMITER //

CREATE PROCEDURE IncreaseSalaryIT()
BEGIN
    DECLARE done       INT DEFAULT 0;
    DECLARE v_EmpID    INT;
    DECLARE v_Salary   DECIMAL(10,2);

    -- Declare explicit cursor
    DECLARE cur_it CURSOR FOR
        SELECT EmpID, Salary FROM Employees WHERE Department = 'IT';

    -- Declare continue handler for end of records
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open cursor
    OPEN cur_it;

    read_loop: LOOP
        -- Fetch one row at a time
        FETCH cur_it INTO v_EmpID, v_Salary;

        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        -- Update salary with 10% increment
        UPDATE Employees
        SET Salary = v_Salary * 1.10
        WHERE EmpID = v_EmpID;

    END LOOP;

    -- Close cursor
    CLOSE cur_it;

    SELECT 'IT department salaries updated by 10%' AS Message;
END //

DELIMITER ;

-- Execute cursor procedure
CALL IncreaseSalaryIT();

-- View updated salaries
SELECT EmpID, Name, Department, Salary FROM Employees ORDER BY Department;

-- ============================================================
-- CURSOR 2: Print employee names and salaries (display only)
-- ============================================================

DELIMITER //

CREATE PROCEDURE DisplayEmployees()
BEGIN
    DECLARE done      INT DEFAULT 0;
    DECLARE v_Name    VARCHAR(100);
    DECLARE v_Salary  DECIMAL(10,2);
    DECLARE v_Dept    VARCHAR(50);

    DECLARE cur_emp CURSOR FOR
        SELECT Name, Department, Salary FROM Employees ORDER BY Department;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Temp table to collect results
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResult (
        Name       VARCHAR(100),
        Department VARCHAR(50),
        Salary     DECIMAL(10,2)
    );

    OPEN cur_emp;

    emp_loop: LOOP
        FETCH cur_emp INTO v_Name, v_Dept, v_Salary;
        IF done = 1 THEN LEAVE emp_loop; END IF;
        INSERT INTO TempResult VALUES (v_Name, v_Dept, v_Salary);
    END LOOP;

    CLOSE cur_emp;

    SELECT * FROM TempResult;
    DROP TEMPORARY TABLE TempResult;
END //

DELIMITER ;

-- Execute
CALL DisplayEmployees();

-- ============================================================
-- SHOW TRIGGERS
-- ============================================================

SHOW TRIGGERS FROM CollegeDB;
