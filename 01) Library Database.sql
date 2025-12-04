-- Create the database and use it
CREATE DATABASE IF NOT EXISTS library;
USE library;

-- ------------------------------
-- DDL: CREATE TABLES (Primary Keys fixed for data integrity)
-- ------------------------------

-- PUBLISHER Table
CREATE TABLE PUBLISHER (
    Name VARCHAR(50) PRIMARY KEY,
    Address VARCHAR(100),
    Phone VARCHAR(15)
);

-- BOOK Table
CREATE TABLE BOOK (
    Book_id INT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Publisher_Name VARCHAR(50),
    Pub_Year YEAR,
    FOREIGN KEY (Publisher_Name) REFERENCES PUBLISHER(Name) ON DELETE CASCADE
);

-- BOOK_AUTHORS Table: Composite PK (Book_id, Author_Name)
CREATE TABLE BOOK_AUTHORS (
    Book_id INT,
    Author_Name VARCHAR(50),
    PRIMARY KEY (Book_id, Author_Name),
    FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE
);

-- LIBRARY_BRANCH Table
CREATE TABLE LIBRARY_BRANCH (
    Branch_id INT PRIMARY KEY,
    Branch_Name VARCHAR(50),
    Address VARCHAR(100)
);

-- BOOK_COPIES Table: Composite PK (Book_id, Branch_id)
CREATE TABLE BOOK_COPIES (
    Book_id INT,
    Branch_id INT,
    No_of_Copies INT,
    PRIMARY KEY (Book_id, Branch_id),
    FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE,
    FOREIGN KEY (Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id) ON DELETE CASCADE
);

-- BOOK_LENDING Table: Composite PK (Book_id, Branch_id, Card_No, Date_Out)
CREATE TABLE BOOK_LENDING (
    Book_id INT,
    Branch_id INT,
    Card_No INT,
    Date_Out DATE,
    Due_Date DATE,
    PRIMARY KEY (Book_id, Branch_id, Card_No, Date_Out),
    FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE,
    FOREIGN KEY (Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id) ON DELETE CASCADE
);

-- ------------------------------
-- DML: VALUE INSERTION
-- ------------------------------

INSERT INTO PUBLISHER (Name, Address, Phone) VALUES
    ('Wiley', 'BENGALURU', '9879879879'),
    ('Pearson', 'BENGALURU', '8798798791'),
    ('McGraw', 'MYSURU', '7897897892');

INSERT INTO BOOK (Book_id, Title, Publisher_Name, Pub_Year) VALUES
    (1, 'Data Structures', 'Wiley', 1998),
    (2, 'Algorithm Design', 'Wiley', 2000),
    (3, 'Database Systems', 'Pearson', 2005),
    (4, 'Software Engineering', 'McGraw', 2005),
    (5, 'Art of Programming', 'Pearson', 2021);

INSERT INTO BOOK_AUTHORS (Book_id, Author_Name) VALUES
    (1, 'AB Suman'),
    (1, 'XY Patel'),
    (2, 'CD Kumar'),
    (3, 'EF Singh'),
    (4, 'GH John'),
    (5, 'Donald Knuth');

INSERT INTO LIBRARY_BRANCH (Branch_id, Branch_Name, Address) VALUES
    (11, 'Central Library', 'MYSURU Main'),
    (22, 'South Branch', 'MYSURU South'),
    (33, 'Tech Branch', 'BENGALURU Tech Park'),
    (44, 'West Branch', 'MANGALURU Port');

INSERT INTO BOOK_COPIES (Book_id, Branch_id, No_of_Copies) VALUES
    (1, 11, 10),
    (1, 22, 20),
    (2, 22, 30),
    (3, 33, 40),
    (4, 44, 25),
    (4, 33, 15),
    (5, 33, 5);

INSERT INTO BOOK_LENDING (Book_id, Branch_id, Card_No, Date_Out, Due_Date) VALUES
    (1, 11, 1010, '2020-01-02', '2020-02-01'), -- Card 1010 loans: #1
    (2, 22, 1010, '2020-03-01', '2020-04-01'), -- #2
    (3, 33, 1010, '2021-02-02', '2021-03-02'), -- #3
    (4, 44, 1010, '2022-01-02', '2022-02-01'), -- #4 (Meets criteria > 3)
    (5, 33, 1010, '2022-05-15', '2022-06-15'), -- #5
    (1, 22, 1012, '2020-01-02', '2020-02-01'),
    (2, 22, 1013, '2021-05-01', '2021-06-01'),
    (3, 33, 1013, '2021-05-10', '2021-06-10'),
    (4, 44, 1013, '2021-05-20', '2021-06-20');


-- ------------------------------
-- QUERIES
-- ------------------------------

-- 1. Retrieve the details of all books in the library – id, title, name of publisher, authors,
-- number of copies in each branch, etc.
-- Using NATURAL JOINs as requested for simplicity, and including LIBRARY_BRANCH for full details.
SELECT
    B.book_id,
    B.title,
    B.publisher_name,
    BA.author_name,
    L.branch_id,
    L.Branch_Name,
    BC.No_of_Copies
FROM BOOK B
NATURAL JOIN BOOK_AUTHORS BA
NATURAL JOIN BOOK_COPIES BC
NATURAL JOIN LIBRARY_BRANCH L;

-- 2. Get the particular borrowers who have borrowed more than 3 books from Jan 2020 to
-- Jun 2022.
SELECT Card_No
FROM BOOK_LENDING
WHERE Date_Out BETWEEN '2020-01-01' AND '2022-07-31'
GROUP BY Card_No
HAVING COUNT(*) > 3;

-- 3. Delete a book in BOOK table and Update the contents of other tables using DML
-- statements.

-- DML: DELETE statement (Book with ID 1 will be deleted)
DELETE FROM BOOK WHERE Book_id = 1;

-- DML: UPDATE statement (Using 'B' as requested, though 'B' is not a defined publisher name in the inserted data)
UPDATE BOOK
SET Publisher_Name = 'B'
WHERE Book_id = 2;

-- 4. Create the view for BOOK table based on year of publication and demonstrate its
-- working with a simple query.
CREATE OR REPLACE VIEW publication_year AS
    SELECT book_id, title, publisher_name, pub_year
    FROM BOOK
    ORDER BY pub_year;

-- Demonstrate the view (Retrieve all columns from the view)
SELECT * FROM publication_year;

-- Demonstrate the view (Simple query to check books published in 2000)
SELECT * FROM publication_year WHERE pub_year = '2000';

-- 5. Create a view of all books and its number of copies which are currently available in the
-- Library.
-- Reverted to the simple (total copies) view definition using NATURAL JOIN as requested.
CREATE OR REPLACE VIEW available_books AS
    SELECT
        B.book_id,
        B.title,
        L.branch_id,
        BC.no_of_copies
    FROM BOOK B
    NATURAL JOIN BOOK_COPIES BC
    NATURAL JOIN LIBRARY_BRANCH L;

-- 6. Demonstrate the usage of view creation (Querying the view created in step 5).
SELECT * FROM available_books;
