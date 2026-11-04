-- ============================================================
-- EXPERIMENT NO. 3
-- Aim: SQL Queries with Filters, Sorting, and Nested Subqueries
-- ============================================================

USE CollegeDB;

-- ============================================================
-- SAMPLE EMP TABLE (as used in manual examples)
-- ============================================================

CREATE TABLE IF NOT EXISTS emp (
    emp_id  INT PRIMARY KEY,
    Ename   VARCHAR(50),
    City    VARCHAR(50),
    Post    VARCHAR(50),
    salary  INT,
    deptno  INT
);

INSERT INTO emp VALUES
(1,  'John',    'Nashik',     'Clerk',     5000,  10),
(2,  'Seema',   'Aurangabad', 'Developer', 20000, 20),
(3,  'Amita',   'Nagar',      'Manager',   70000, 20),
(4,  'Rakesh',  'Pune',       'Analyst',   50000, 20),
(5,  'Samata',  'Nashik',     'Tester',    35000, 10),
(6,  'Ankita',  'Chandwad',   'Developer', 30000, 30),
(7,  'Bhavika', 'Pune',       'Team-LR',   50000, 30),
(8,  'Deepa',   'Mumbai',     'CEO',       90000, 10),
(9,  'Nitin',   'Nagpur',     'Clerk',     8000,  10),
(10, 'Pooja',   'Pune',       'Analyst',   45000, 20);

-- ============================================================
-- SELECT CLAUSE
-- ============================================================

SELECT emp_id, Ename, salary FROM emp;

-- ============================================================
-- FROM CLAUSE
-- ============================================================

SELECT * FROM emp;

-- ============================================================
-- WHERE CLAUSE – Filtering
-- ============================================================

-- Students above age 20
SELECT * FROM Student WHERE Age > 20;

-- Employees with salary > 30000
SELECT * FROM emp WHERE salary > 30000;

-- Filter by city
SELECT * FROM emp WHERE City = 'Pune';

-- Filter by post
SELECT * FROM emp WHERE Post = 'Developer';

-- ============================================================
-- ORDER BY CLAUSE – Sorting
-- ============================================================

-- Alphabetically by student name (ascending)
SELECT * FROM Student ORDER BY Name ASC;

-- By credits descending
SELECT * FROM Course ORDER BY Credits DESC;

-- Employees sorted by salary descending
SELECT * FROM emp ORDER BY salary DESC;

-- ============================================================
-- GROUP BY CLAUSE – Aggregation
-- ============================================================

-- Student count per course
SELECT
    c.CourseName,
    COUNT(e.StudentID) AS StudentCount
FROM Course c
JOIN Enrollment e ON c.CourseID = e.CourseID
GROUP BY c.CourseName;

-- Average age of students
SELECT AVG(Age) AS AverageAge FROM Student;

-- Count employees per department
SELECT deptno, COUNT(*) AS EmpCount FROM emp GROUP BY deptno;

-- Total salary per department
SELECT deptno, SUM(salary) AS TotalSalary FROM emp GROUP BY deptno;

-- ============================================================
-- HAVING CLAUSE
-- ============================================================

-- Courses with more than 1 student enrolled
SELECT
    c.CourseName,
    COUNT(e.StudentID) AS StudentCount
FROM Course c
JOIN Enrollment e ON c.CourseID = e.CourseID
GROUP BY c.CourseName
HAVING COUNT(e.StudentID) > 1;

-- Departments where total salary > 100000
SELECT deptno, SUM(salary) AS TotalSalary
FROM emp
GROUP BY deptno
HAVING SUM(salary) > 100000;

-- ============================================================
-- LIMIT CLAUSE
-- ============================================================

-- First 3 students
SELECT * FROM Student LIMIT 3;

-- Top 5 highest paid employees
SELECT * FROM emp ORDER BY salary DESC LIMIT 5;

-- ============================================================
-- DISTINCT CLAUSE
-- ============================================================

-- Distinct cities in emp table
SELECT DISTINCT City FROM emp;

-- Distinct posts
SELECT DISTINCT Post FROM emp;

-- ============================================================
-- NESTED SUBQUERIES
-- ============================================================

-- Single Row Subquery:
-- Display employees paid more than Pooja
SELECT * FROM emp
WHERE salary > (SELECT salary FROM emp WHERE Ename = 'Pooja');

-- Subquery to find max salary
SELECT * FROM emp
WHERE salary = (SELECT MAX(salary) FROM emp);

-- Multiple Row Subquery with IN:
-- Employees who are in the same city as developers
SELECT * FROM emp
WHERE City IN (SELECT City FROM emp WHERE Post = 'Developer');

-- Subquery with NOT IN:
-- Employees NOT in the same department as clerks
SELECT * FROM emp
WHERE deptno NOT IN (SELECT deptno FROM emp WHERE Post = 'Clerk');

-- >ALL Subquery:
-- Employees whose salary is higher than ALL developers
SELECT Ename, salary, deptno FROM emp
WHERE salary > ALL (SELECT salary FROM emp WHERE Post = 'Developer');

-- >ANY Subquery:
-- Employees whose salary is more than ANY developer
SELECT Ename, salary, deptno FROM emp
WHERE salary > ANY (SELECT salary FROM emp WHERE Post = 'Developer');

-- Correlated Subquery:
-- Find employees earning more than the average salary of their department
SELECT e1.Ename, e1.salary, e1.deptno
FROM emp e1
WHERE e1.salary > (
    SELECT AVG(e2.salary) FROM emp e2 WHERE e2.deptno = e1.deptno
);

-- EXISTS Subquery:
-- Students who have at least one enrollment
SELECT * FROM Student s
WHERE EXISTS (
    SELECT 1 FROM Enrollment e WHERE e.StudentID = s.StudentID
);
