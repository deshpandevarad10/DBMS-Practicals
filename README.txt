============================================================
  DBMS PRACTICAL MANUAL – CODE FILES
============================================================

This folder contains SQL and MongoDB code for all 9 practicals
from the DBMS Manual. Each file is self-contained and ready
to copy-paste or run directly.

------------------------------------------------------------
FILE LIST
------------------------------------------------------------

Practical_01_DDL_DML.sql
  → Experiment 1: Database creation, DDL (CREATE, ALTER, DROP,
    TRUNCATE) and DML (SELECT, INSERT, UPDATE, DELETE) queries.
  → Run in: MySQL

Practical_02_Views_Indexing.sql
  → Experiment 2: Creating, replacing, and dropping Views.
    Creating simple, unique, and descending Indexes.
    AUTO_INCREMENT sequences.
  → Run in: MySQL

Practical_03_Filters_Sorting_Subqueries.sql
  → Experiment 3: WHERE, ORDER BY, GROUP BY, HAVING, LIMIT,
    DISTINCT clauses. Single-row, multi-row, correlated
    subqueries. ALL, ANY, IN, EXISTS operators.
  → Run in: MySQL

Practical_04_Joins.sql
  → Experiment 4: INNER JOIN, LEFT JOIN, RIGHT JOIN,
    FULL OUTER JOIN (via UNION). Persons/Orders and
    Customer/Orders examples.
  → Run in: MySQL

Practical_05_Procedures_Functions.sql
  → Experiment 5: Stored Procedures (AddSale, IncreaseSalary)
    and Functions (GetTotalSales, GetBonus, GetProductSalesTotal).
  → Run in: MySQL

Practical_06_Triggers_Cursors.sql
  → Experiment 6: BEFORE INSERT, AFTER INSERT, AFTER UPDATE,
    AFTER DELETE triggers on Employees table with audit log.
    Explicit cursor to process IT department salary increment.
  → Run in: MySQL

Practical_07_MongoDB_CRUD_Aggregation.js
  → Experiment 7: MongoDB CRUD operations (insertOne,
    insertMany, find, update, remove). Indexing.
    Aggregation pipelines.
  → Run in: MongoDB Shell (mongosh) or Compass

Practical_08_MongoDB_SocialMedia.js
  → Experiment 8: Social media dataset import, filter queries,
    top trending hashtag aggregation, indexing, CRUD.
  → Run in: MongoDB Shell (mongosh) or Compass

Practical_09_Backup_Recovery.sql
  → Experiment 9: Create student_db, insert data, full backup
    with mysqldump, simulate data loss, restore. All terminal
    commands are included as comments.
  → Run in: MySQL + System Terminal

------------------------------------------------------------
HOW TO RUN SQL FILES IN MYSQL
------------------------------------------------------------

Option 1 – MySQL Command Line:
  mysql -u root -p < Practical_01_DDL_DML.sql

Option 2 – MySQL Workbench:
  File → Open SQL Script → Select file → Run (Ctrl+Shift+Enter)

Option 3 – Copy-paste into MySQL prompt:
  Open MySQL, paste code block-by-block.

------------------------------------------------------------
HOW TO RUN .js FILES IN MONGODB
------------------------------------------------------------

Option 1 – mongosh (terminal):
  mongosh < Practical_07_MongoDB_CRUD_Aggregation.js

Option 2 – MongoDB Compass:
  Open Compass → Connect → Click mongosh at bottom
  → Copy-paste commands one section at a time.

------------------------------------------------------------
NOTE
------------------------------------------------------------
• Run Practical 1 first — it creates CollegeDB and all
  base tables used by Practicals 2–6.
• Practicals 7 & 8 use a separate MongoDB database.
• Practical 9 uses student_db (separate from CollegeDB).
============================================================
