/* COMPANY DATABASE SYSTEM 
   Includes: Table Creation, Data Insertion, and Queries 1-5
*/

-------------------------------------------------------
-- 1. SCHEMA CREATION (DDL)
-------------------------------------------------------

CREATE TABLE DEPARTMENT (
    DNo INT PRIMARY KEY,
    DName VARCHAR(50),
    MgrSSN CHAR(9),
    MgrStartDate DATE
);

CREATE TABLE EMPLOYEE (
    SSN CHAR(9) PRIMARY KEY,
    Name VARCHAR(50),
    Address VARCHAR(100),
    Sex CHAR(1),
    Salary DECIMAL(10, 2),
    SuperSSN CHAR(9),
    DNo INT,
    FOREIGN KEY (SuperSSN) REFERENCES EMPLOYEE(SSN),
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo)
);

-- Adding Foreign Key to Department after Employee table exists
ALTER TABLE DEPARTMENT ADD FOREIGN KEY (MgrSSN) REFERENCES EMPLOYEE(SSN);

CREATE TABLE DLOCATION (
    DNo INT,
    DLoc VARCHAR(50),
    PRIMARY KEY (DNo, DLoc),
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo) ON DELETE CASCADE
);

CREATE TABLE PROJECT (
    PNo INT PRIMARY KEY,
    PName VARCHAR(50),
    PLocation VARCHAR(50),
    DNo INT,
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo) ON DELETE CASCADE
);

CREATE TABLE WORKS_ON (
    SSN CHAR(9),
    PNo INT,
    Hours DECIMAL(5, 1),
    PRIMARY KEY (SSN, PNo),
    FOREIGN KEY (SSN) REFERENCES EMPLOYEE(SSN) ON DELETE CASCADE,
    FOREIGN KEY (PNo) REFERENCES PROJECT(PNo) ON DELETE CASCADE
);

-------------------------------------------------------
-- 2. DATA INSERTION (Sample Records)
-------------------------------------------------------

INSERT INTO DEPARTMENT (DNo, DName, MgrStartDate) VALUES (1, 'Accounts', '2020-01-01');
INSERT INTO DEPARTMENT (DNo, DName, MgrStartDate) VALUES (2, 'IT', '2021-05-15');

INSERT INTO EMPLOYEE VALUES ('S01', 'Robert Scott', 'London', 'M', 700000, NULL, 1);
INSERT INTO EMPLOYEE VALUES ('S02', 'Alice Smith', 'Paris', 'F', 650000, 'S01', 1);
INSERT INTO EMPLOYEE VALUES ('S03', 'John Doe', 'London', 'M', 500000, 'S01', 2);

UPDATE DEPARTMENT SET MgrSSN = 'S01' WHERE DNo = 1;
UPDATE DEPARTMENT SET MgrSSN = 'S03' WHERE DNo = 2;

INSERT INTO PROJECT VALUES (101, 'IoT', 'London', 2);
INSERT INTO PROJECT VALUES (102, 'Audit', 'Paris', 1);

INSERT INTO WORKS_ON VALUES ('S01', 102, 20.0);
INSERT INTO WORKS_ON VALUES ('S03', 101, 40.0);

-------------------------------------------------------
-- 3. SQL QUERIES
-------------------------------------------------------

-- Q1: Projects involving 'Scott' as worker or manager of controlling dept
SELECT DISTINCT P.PNo
FROM PROJECT P
JOIN DEPARTMENT D ON P.DNo = D.DNo
JOIN EMPLOYEE E ON D.MgrSSN = E.SSN
WHERE E.Name LIKE '%Scott'
UNION
SELECT DISTINCT W.PNo
FROM WORKS_ON W
JOIN EMPLOYEE E ON W.SSN = E.SSN
WHERE E.Name LIKE '%Scott';

-- Q2: Show salaries with 10% raise for those on 'IoT' project
SELECT E.Name, E.Salary * 1.10 AS Increased_Salary
FROM EMPLOYEE E
JOIN WORKS_ON W ON E.SSN = W.SSN
JOIN PROJECT P ON W.PNo = P.PNo
WHERE P.PName = 'IoT';

-- Q3: Stats for 'Accounts' department
SELECT SUM(Salary) AS Sum_Salary, MAX(Salary) AS Max_Salary, 
       MIN(Salary) AS Min_Salary, AVG(Salary) AS Avg_Salary
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DNo = D.DNo
WHERE D.DName = 'Accounts';

-- Q4: Employees working on ALL projects controlled by their department
-- Logic: Retrieve Emp where NOT EXISTS a project in their dept they DON'T work on
SELECT E.Name
FROM EMPLOYEE E
WHERE NOT EXISTS (
    (SELECT PNo FROM PROJECT WHERE DNo = E.DNo)
    EXCEPT
    (SELECT PNo FROM WORKS_ON WHERE SSN = E.SSN)
);

-- Q5: Depts with > 5 employees, count those making > 6,00,000
SELECT DNo, COUNT(SSN) AS High_Earners_Count
FROM EMPLOYEE
WHERE Salary > 600000 AND DNo IN (
    SELECT DNo 
    FROM EMPLOYEE 
    GROUP BY DNo 
    HAVING COUNT(SSN) > 5
)
GROUP BY DNo;
