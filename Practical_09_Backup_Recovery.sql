-- ============================================================
-- EXPERIMENT NO. 9
-- Aim: MySQL Database Backup and Recovery
-- ============================================================

-- ============================================================
-- STEP 1: Create Database
-- ============================================================

CREATE DATABASE IF NOT EXISTS student_db;
USE student_db;

-- ============================================================
-- STEP 2: Create Table
-- ============================================================

CREATE TABLE IF NOT EXISTS students (
    id         INT PRIMARY KEY,
    name       VARCHAR(50),
    department VARCHAR(50),
    marks      INT
);

-- ============================================================
-- STEP 3: Insert Data
-- ============================================================

INSERT INTO students VALUES
(1, 'Rahul', 'AI&DS', 85),
(2, 'Sneha', 'AI&DS', 90),
(3, 'Amit',  'CSE',   78),
(4, 'Priya', 'CSE',   88),
(5, 'Ravi',  'IT',    76);

-- View inserted data
SELECT * FROM students;

-- ============================================================
-- STEP 4: Backup commands (run in system terminal, NOT MySQL)
-- ============================================================

-- Backup single database:
-- mysqldump -u root -p student_db > student_db_backup.sql

-- Backup specific table only:
-- mysqldump -u root -p student_db students > students_backup.sql

-- Backup all databases:
-- mysqldump -u root -p --all-databases > alldb_backup.sql

-- Backup with date in filename (Linux/Mac):
-- mysqldump -u root -p student_db > student_db_$(date +%Y%m%d).sql

-- ============================================================
-- STEP 5: Verify backup file contents
-- The .sql file will contain:
-- ============================================================

-- CREATE DATABASE /*!32312 IF NOT EXISTS*/ `student_db`;
-- USE `student_db`;

-- DROP TABLE IF EXISTS `students`;
-- CREATE TABLE `students` (
--   `id` int NOT NULL,
--   `name` varchar(50) DEFAULT NULL,
--   `department` varchar(50) DEFAULT NULL,
--   `marks` int DEFAULT NULL,
--   PRIMARY KEY (`id`)
-- );

-- INSERT INTO `students` VALUES
-- (1,'Rahul','AI&DS',85),
-- (2,'Sneha','AI&DS',90),
-- (3,'Amit','CSE',78);

-- ============================================================
-- STEP 6: Simulate data loss (Drop the database)
-- ============================================================

-- WARNING: This will delete the database permanently
-- DROP DATABASE student_db;   -- Uncomment to simulate loss

-- ============================================================
-- STEP 7: Restore from backup (run in terminal, NOT MySQL)
-- ============================================================

-- If database already exists:
-- mysql -u root -p student_db < student_db_backup.sql

-- If database was dropped (recreate first):
-- mysql -u root -p -e "CREATE DATABASE student_db;"
-- mysql -u root -p student_db < student_db_backup.sql

-- ============================================================
-- STEP 8: Verify restoration
-- ============================================================

USE student_db;
SELECT * FROM students;

-- ============================================================
-- TYPES OF BACKUP – Additional Commands
-- ============================================================

-- 1. Full backup (all databases)
-- mysqldump -u root -p --all-databases > full_backup.sql

-- 2. Selective/Table-level backup
-- mysqldump -u root -p student_db students > students_only.sql

-- 3. Structure only (no data)
-- mysqldump -u root -p --no-data student_db > schema_only.sql

-- 4. Data only (no structure)
-- mysqldump -u root -p --no-create-info student_db > data_only.sql

-- 5. Compressed backup (Linux)
-- mysqldump -u root -p student_db | gzip > student_db_backup.sql.gz

-- 6. Restore compressed backup
-- gunzip < student_db_backup.sql.gz | mysql -u root -p student_db

-- ============================================================
-- USEFUL MYSQL QUERIES AFTER RESTORE
-- ============================================================

-- Check all databases
SHOW DATABASES;

-- Use restored database
USE student_db;

-- Check tables
SHOW TABLES;

-- Verify row count
SELECT COUNT(*) AS TotalRows FROM students;

-- Check table structure
DESCRIBE students;
