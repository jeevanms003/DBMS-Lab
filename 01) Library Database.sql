-- ===========================================================
-- LIBRARY DATABASE SCHEMA CREATION
-- ===========================================================

-- 1️⃣ Create Database
CREATE DATABASE library;
USE library;

-- 2️⃣ Create Tables

-- Publisher Table
CREATE TABLE publisher (
    name VARCHAR(20) PRIMARY KEY,
    address VARCHAR(50),
    phone VARCHAR(10)
);

-- Book Table
CREATE TABLE book (
    book_id INT PRIMARY KEY,
    title VARCHAR(50),
    publisher_name VARCHAR(20),
    pub_year YEAR,
    FOREIGN KEY (publisher_name) REFERENCES publisher(name) ON DELETE CASCADE
);

-- Book Authors Table
CREATE TABLE book_authors (
    book_id INT PRIMARY KEY,
    author_name VARCHAR(50),
    FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE CASCADE
);

-- Library Branch Table
CREATE TABLE library_branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(30),
    address VARCHAR(50)
);

-- Book Copies Table
CREATE TABLE book_copies (
    book_id INT,
    branch_id INT,
    no_of_copies INT,
    FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE CASCADE,
    FOREIGN KEY (branch_id) REFERENCES library_branch(branch_id) ON DELETE CASCADE
);

-- Book Lending Table
CREATE TABLE book_lending (
    book_id INT,
    branch_id INT,
    card_no INT,
    date_out DATE,
    due_date DATE,
    FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE CASCADE,
    FOREIGN KEY (branch_id) REFERENCES library_branch(branch_id) ON DELETE CASCADE
);

-- ===========================================================
-- VALUE INSERTION
-- ===========================================================

-- Insert into Publisher
INSERT INTO publisher (name, address, phone) VALUES
('Pearson', 'Bengaluru', '9876543210'),
('OReilly', 'Hyderabad', '8765432109'),
('Wiley', 'Mysuru', '7654321098');

SELECT * FROM publisher;

-- Insert into Book
INSERT INTO book (book_id, title, publisher_name, pub_year) VALUES
(101, 'C Programming', 'Pearson', 2010),
(102, 'Python Basics', 'OReilly', 2018),
(103, 'AI Foundations', 'Wiley', 2021),
(104, 'Data Science 101', 'Pearson', 2022);

SELECT * FROM book;

-- Insert into Book Authors
INSERT INTO book_authors (book_id, author_name) VALUES
(101, 'Dennis Ritchie'),
(102, 'Mark Lutz'),
(103, 'Andrew Ng'),
(104, 'Jake VanderPlas');

SELECT * FROM book_authors;

-- Insert into Library Branch
INSERT INTO library_branch (branch_id, branch_name, address) VALUES
(1, 'Central Library', 'Mysuru'),
(2, 'City Library', 'Bengaluru'),
(3, 'Tech Library', 'Hyderabad'),
(4, 'Community Library', 'Mangalore');

SELECT * FROM library_branch;

-- Insert into Book Copies
INSERT INTO book_copies (book_id, branch_id, no_of_copies) VALUES
(101, 1, 8),
(101, 2, 12),
(102, 2, 10),
(103, 3, 6),
(104, 4, 9),
(104, 1, 5);

SELECT * FROM book_copies;

-- Insert into Book Lending
INSERT INTO book_lending (book_id, branch_id, card_no, date_out, due_date) VALUES
(101, 1, 2001, '2020-02-10', '2020-03-10'),
(102, 2, 2001, '2020-06-15', '2020-07-15'),
(103, 3, 2001, '2021-05-12', '2021-06-12'),
(104, 4, 2001, '2022-02-01', '2022-03-01'),
(101, 2, 2002, '2021-01-05', '2021-02-05');

SELECT * FROM book_lending;

-- ===========================================================
-- QUERIES
-- ===========================================================

-- 🔹 Query 1:
-- Retrieve the details of all books – ID, Title, Publisher, Author, Branch, Copies
SELECT 
    b.book_id, 
    b.title, 
    b.publisher_name, 
    ba.author_name, 
    bc.branch_id, 
    bc.no_of_copies 
FROM book b 
NATURAL JOIN book_authors ba 
NATURAL JOIN book_copies bc;

-- 🔹 Query 2:
-- Get borrowers who borrowed more than 3 books between Jan 2020 and Jun 2022
SELECT 
    card_no 
FROM book_lending 
WHERE date_out BETWEEN '2020-01-01' AND '2022-07-31' 
GROUP BY card_no 
HAVING COUNT(*) > 3;

-- 🔹 Query 3:
-- Delete a book and update publisher details
DELETE FROM book WHERE book_id = 101;

UPDATE book 
SET publisher_name = 'Wiley' 
WHERE book_id = 102;

-- 🔹 Query 4:
-- Create a view of books based on year of publication
CREATE VIEW publication_year AS
SELECT 
    book_id, 
    title, 
    publisher_name, 
    pub_year
FROM book
ORDER BY pub_year;

-- Display the View
SELECT * FROM publication_year;

-- Display books published in 2021
SELECT * FROM publication_year WHERE pub_year = '2021';

-- 🔹 Query 5:
-- Create a view for all books and their available copies in library branches
CREATE VIEW available_books AS
SELECT 
    b.book_id, 
    b.title, 
    l.branch_id, 
    bc.no_of_copies
FROM book b 
NATURAL JOIN book_copies bc 
NATURAL JOIN library_branch l;

-- Display the available books view
SELECT * FROM available_books;

-- ===========================================================
-- END OF SCRIPT
-- ===========================================================