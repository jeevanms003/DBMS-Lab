/* ============================================================
   LIBRARY DATABASE - COMPLETE SQL (CORRECTED SCHEMA)
   Includes:
   - No Borrower table
   - No Date_In column
   - Exact exam schema
   ============================================================ */

/* ============================
   1. CREATE TABLES
   ============================ */

-- BOOK TABLE
CREATE TABLE BOOK (
    Book_id INT PRIMARY KEY,
    Title VARCHAR(100),
    Publisher_Name VARCHAR(100),
    Pub_Year INT
);

-- BOOK AUTHORS TABLE
CREATE TABLE BOOK_AUTHORS (
    Book_id INT,
    Author_Name VARCHAR(100),
    FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id)
);

-- PUBLISHER TABLE
CREATE TABLE PUBLISHER (
    Name VARCHAR(100) PRIMARY KEY,
    Address VARCHAR(200),
    Phone VARCHAR(20)
);

-- LIBRARY BRANCH TABLE
CREATE TABLE LIBRARY_BRANCH (
    Branch_id INT PRIMARY KEY,
    Branch_Name VARCHAR(100),
    Address VARCHAR(200)
);

-- BOOK COPIES TABLE
CREATE TABLE BOOK_COPIES (
    Book_id INT,
    Branch_id INT,
    No_of_Copies INT,
    FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id),
    FOREIGN KEY (Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id)
);

-- BOOK LENDING TABLE (CORRECTED: NO DATE_IN)
CREATE TABLE BOOK_LENDING (
    Book_id INT,
    Branch_id INT,
    Card_No INT,
    Date_Out DATE,
    Due_Date DATE,
    FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id),
    FOREIGN KEY (Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id)
);

/* ============================
   2. INSERT SAMPLE VALUES
   ============================ */

-- PUBLISHERS
INSERT INTO PUBLISHER VALUES ('Penguin', 'Mumbai', '9988776655');
INSERT INTO PUBLISHER VALUES ('OUP', 'Delhi', '8877665544');

-- BOOKS
INSERT INTO BOOK VALUES (101, 'Database Systems', 'Penguin', 2018);
INSERT INTO BOOK VALUES (102, 'Operating Systems', 'OUP', 2020);
INSERT INTO BOOK VALUES (103, 'Computer Networks', 'Penguin', 2019);

-- BOOK AUTHORS
INSERT INTO BOOK_AUTHORS VALUES (101, 'Korth');
INSERT INTO BOOK_AUTHORS VALUES (102, 'Galvin');
INSERT INTO BOOK_AUTHORS VALUES (103, 'Tanenbaum');

-- LIBRARY BRANCHES
INSERT INTO LIBRARY_BRANCH VALUES (1, 'Central Library', 'MG Road');
INSERT INTO LIBRARY_BRANCH VALUES (2, 'City Library', 'Park Street');

-- BOOK COPIES
INSERT INTO BOOK_COPIES VALUES (101, 1, 5);
INSERT INTO BOOK_COPIES VALUES (102, 1, 2);
INSERT INTO BOOK_COPIES VALUES (103, 1, 4);
INSERT INTO BOOK_COPIES VALUES (101, 2, 3);
INSERT INTO BOOK_COPIES VALUES (102, 2, 2);

-- BOOK LENDING RECORDS (NO DATE_IN)
INSERT INTO BOOK_LENDING VALUES (101, 1, 10, '2020-02-10', '2020-02-20');
INSERT INTO BOOK_LENDING VALUES (102, 1, 10, '2021-05-11', '2021-05-21');
INSERT INTO BOOK_LENDING VALUES (103, 2, 10, '2022-01-12', '2022-01-22');
INSERT INTO BOOK_LENDING VALUES (101, 2, 10, '2021-08-13', '2021-08-23');
INSERT INTO BOOK_LENDING VALUES (101, 1, 11, '2020-06-10', '2020-06-20');

/* ============================================================
   3. SQL QUERIES FOR QUESTIONS
   ============================================================ */

---------------------------------------------------------------
-- Q1: Retrieve all book details
---------------------------------------------------------------

SELECT 
    B.Book_id,
    B.Title,
    B.Publisher_Name,
    BA.Author_Name,
    LB.Branch_Name,
    BC.No_of_Copies
FROM BOOK B
LEFT JOIN BOOK_AUTHORS BA ON B.Book_id = BA.Book_id
LEFT JOIN BOOK_COPIES BC ON B.Book_id = BC.Book_id
LEFT JOIN LIBRARY_BRANCH LB ON BC.Branch_id = LB.Branch_id;

---------------------------------------------------------------
-- Q2: Borrowers (Card_No only) who borrowed > 3 books 
--     between Jan 2020 and Jun 2022
---------------------------------------------------------------

SELECT 
    Card_No,
    COUNT(Book_id) AS Total_Books
FROM BOOK_LENDING
WHERE Date_Out BETWEEN '2020-01-01' AND '2022-06-30'
GROUP BY Card_No
HAVING COUNT(Book_id) > 3;

---------------------------------------------------------------
-- Q3: Delete a book & update other tables
---------------------------------------------------------------

-- Delete a book
DELETE FROM BOOK WHERE Book_id = 103;

-- Update number of copies
UPDATE BOOK_COPIES
SET No_of_Copies = No_of_Copies - 1
WHERE Book_id = 101 AND Branch_id = 1;

-- Update due dates (no Date_In column)
UPDATE BOOK_LENDING
SET Due_Date = DATE_ADD(Due_Date, INTERVAL 5 DAY)
WHERE Book_id = 101;

---------------------------------------------------------------
-- Q4: Create view based on year of publication
---------------------------------------------------------------

CREATE VIEW BOOK_YEAR_VIEW AS
SELECT Book_id, Title, Pub_Year
FROM BOOK
WHERE Pub_Year > 2018;

SELECT * FROM BOOK_YEAR_VIEW;

---------------------------------------------------------------
-- Q5: Create view showing books and available copies
---------------------------------------------------------------

CREATE VIEW AVAILABLE_BOOKS AS
SELECT 
    B.Book_id,
    B.Title,
    SUM(BC.No_of_Copies) AS Total_Copies
FROM BOOK B
JOIN BOOK_COPIES BC ON B.Book_id = BC.Book_id
GROUP BY B.Book_id, B.Title;

SELECT * FROM AVAILABLE_BOOKS;

---------------------------------------------------------------
-- Q6: Demonstrate view usage
---------------------------------------------------------------

SELECT Title
FROM BOOK_YEAR_VIEW
WHERE Pub_Year = 2019;

/* ============================
   END OF FINAL SQL FILE
   ============================ */

