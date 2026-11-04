-- ============================================================
-- EXPERIMENT NO. 1
-- Aim: Introduction to Database Creation
-- DDL and DML Queries
-- ============================================================

-- Create and select the database
CREATE DATABASE IF NOT EXISTS CollegeDB;
USE CollegeDB;

-- ============================================================
-- DDL: CREATE TABLES
-- ============================================================

CREATE TABLE Student (
    StudentID   INT PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(100) NOT NULL,
    Email       VARCHAR(100) UNIQUE,
    Age         INT,
    Address     VARCHAR(255)
);

CREATE TABLE Instructor (
    InstructorID    INT PRIMARY KEY AUTO_INCREMENT,
    Name            VARCHAR(100) NOT NULL,
    Email           VARCHAR(100) UNIQUE,
    Department      VARCHAR(100)
);

CREATE TABLE Course (
    CourseID        INT PRIMARY KEY AUTO_INCREMENT,
    CourseName      VARCHAR(100) NOT NULL,
    Credits         INT,
    InstructorID    INT,
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)
);

CREATE TABLE Enrollment (
    EnrollmentID    INT PRIMARY KEY AUTO_INCREMENT,
    StudentID       INT,
    CourseID        INT,
    EnrollmentDate  DATE,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID)  REFERENCES Course(CourseID)
);

-- ============================================================
-- DML: INSERT DATA
-- ============================================================

INSERT INTO Student (Name, Email, Age, Address) VALUES
('Rahul Sharma',  'rahul@example.com',  20, 'Nashik'),
('Sneha Patil',   'sneha@example.com',  22, 'Pune'),
('Amit Kumar',    'amit@example.com',   21, 'Mumbai'),
('Priya Desai',   'priya@example.com',  23, 'Nagpur'),
('Ravi Joshi',    'ravi@example.com',   20, 'Nashik');

INSERT INTO Instructor (Name, Email, Department) VALUES
('Dr. Meera Singh',   'meera@college.com',  'Computer Science'),
('Prof. Anil Verma',  'anil@college.com',   'Mathematics'),
('Dr. Sunita Rao',    'sunita@college.com', 'AI & Data Science');

INSERT INTO Course (CourseName, Credits, InstructorID) VALUES
('Database Management Systems', 4, 1),
('Machine Learning',            3, 3),
('Discrete Mathematics',        3, 2),
('Data Structures',             4, 1);

INSERT INTO Enrollment (StudentID, CourseID, EnrollmentDate) VALUES
(1, 1, '2024-07-01'),
(1, 2, '2024-07-01'),
(2, 1, '2024-07-02'),
(3, 3, '2024-07-02'),
(4, 2, '2024-07-03'),
(5, 4, '2024-07-03'),
(2, 4, '2024-07-04');

-- ============================================================
-- DML: SELECT
-- ============================================================

-- Select all students
SELECT * FROM Student;

-- Select specific columns
SELECT Name, Email FROM Student;

-- ============================================================
-- DML: UPDATE
-- ============================================================

-- Update age of a student
UPDATE Student SET Age = 24 WHERE StudentID = 2;

-- Update address
UPDATE Student SET Address = 'Aurangabad' WHERE Name = 'Amit Kumar';

-- ============================================================
-- DML: DELETE
-- ============================================================

-- Delete a specific enrollment
DELETE FROM Enrollment WHERE EnrollmentID = 7;

-- ============================================================
-- DDL: ALTER TABLE
-- ============================================================

-- Add a new column
ALTER TABLE Student ADD COLUMN PhoneNumber VARCHAR(15);

-- Drop a column
ALTER TABLE Student DROP COLUMN PhoneNumber;

-- Rename a column (MySQL 8+)
ALTER TABLE Student RENAME COLUMN Address TO City;

-- ============================================================
-- DDL: DESCRIBE TABLE
-- ============================================================

DESCRIBE Student;
DESCRIBE Course;

-- ============================================================
-- DDL: TRUNCATE (removes all rows, keeps structure)
-- ============================================================

-- TRUNCATE TABLE Enrollment;   -- Uncomment to test

-- ============================================================
-- DDL: DROP TABLE (removes table permanently)
-- ============================================================

-- DROP TABLE Enrollment;       -- Uncomment to test
-- DROP DATABASE CollegeDB;     -- Uncomment to test

-- ============================================================
-- SHOW DATABASES AND TABLES
-- ============================================================

SHOW DATABASES;
SHOW TABLES;
