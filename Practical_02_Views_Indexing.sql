-- ============================================================
-- EXPERIMENT NO. 2
-- Aim: Views and Indexing
-- ============================================================

USE CollegeDB;

-- ============================================================
-- VIEWS
-- ============================================================

-- 1. Create a view to show student enrollment details
CREATE VIEW StudentCourseView AS
SELECT
    s.StudentID,
    s.Name        AS StudentName,
    c.CourseName,
    c.Credits,
    e.EnrollmentDate
FROM Student s
JOIN Enrollment e ON s.StudentID = e.StudentID
JOIN Course c     ON e.CourseID  = c.CourseID;

-- Query the view
SELECT * FROM StudentCourseView;

-- 2. Create a view to show instructor and their courses
CREATE VIEW InstructorCourseView AS
SELECT
    i.InstructorID,
    i.Name       AS InstructorName,
    i.Department,
    c.CourseName,
    c.Credits
FROM Instructor i
JOIN Course c ON i.InstructorID = c.InstructorID;

-- Query the view
SELECT * FROM InstructorCourseView;

-- 3. Create a view to show only student names and emails
CREATE VIEW StudentContactView AS
SELECT Name, Email FROM Student;

SELECT * FROM StudentContactView;

-- ============================================================
-- UPDATE VIEW using CREATE OR REPLACE
-- ============================================================

-- Replace the StudentContactView to also include City
CREATE OR REPLACE VIEW StudentContactView AS
SELECT Name, Email, City FROM Student;

SELECT * FROM StudentContactView;

-- ============================================================
-- DROP VIEW
-- ============================================================

-- DROP VIEW StudentContactView;    -- Uncomment to test

-- ============================================================
-- INDEXES
-- ============================================================

-- 1. Simple Index on Student Name
CREATE INDEX idx_student_name ON Student(Name);

-- 2. Unique Index on Student Email
CREATE UNIQUE INDEX idx_student_email ON Student(Email);

-- 3. Index on Enrollment Date
CREATE INDEX idx_enrollment_date ON Enrollment(EnrollmentDate);

-- 4. Descending Index on Course Credits
CREATE INDEX idx_course_credits_desc ON Course(Credits DESC);

-- ============================================================
-- ALTER TABLE to add INDEX
-- ============================================================

ALTER TABLE Course ADD INDEX idx_course_name (CourseName);

-- ============================================================
-- DROP INDEX
-- ============================================================

ALTER TABLE Student DROP INDEX idx_student_name;

-- ============================================================
-- AUTO_INCREMENT / SEQUENCE
-- ============================================================

-- Table with auto_increment starting at 1 (default)
CREATE TABLE IF NOT EXISTS demo_seq (
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

-- Table with auto_increment starting at 10
CREATE TABLE IF NOT EXISTS demo_seq2 (
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
) AUTO_INCREMENT = 10;

-- Insert using auto_increment (no need to specify id)
INSERT INTO demo_seq (name) VALUES ('Alice'), ('Bob'), ('Charlie');

-- Insert with NULL for auto_increment column
INSERT INTO demo_seq2 VALUES (NULL, 'David');
INSERT INTO demo_seq2 (name) VALUES ('Eve');

SELECT * FROM demo_seq;
SELECT * FROM demo_seq2;

-- ============================================================
-- MEASURE QUERY PERFORMANCE
-- ============================================================

-- Check query execution plan (uses index or not)
EXPLAIN SELECT * FROM Student WHERE Name = 'Rahul Sharma';
EXPLAIN SELECT * FROM Student WHERE Email = 'rahul@example.com';
