/* ============================================================
   MOVIE DATABASE – COMPLETE SQL SCRIPT
   Contains: Schema + Inserts + All 5 Queries
   ============================================================ */

-- Create & select database
CREATE DATABASE movie;
USE movie;

---------------------------------------------------------------
-- 1. TABLE CREATION
---------------------------------------------------------------

CREATE TABLE actor (
   act_id INT NOT NULL PRIMARY KEY,
   act_name VARCHAR(20),
   act_gender CHAR(1)
);

CREATE TABLE director (
   dir_id INT NOT NULL PRIMARY KEY,
   dir_name VARCHAR(20),
   dir_phone VARCHAR(20)
);

CREATE TABLE movies(
   mov_id INT NOT NULL PRIMARY KEY,
   mov_title VARCHAR(20),
   mov_year YEAR,
   mov_lang VARCHAR(20),
   dir_id INT,
   FOREIGN KEY (dir_id) REFERENCES director(dir_id) ON DELETE CASCADE
);

CREATE TABLE movie_cast (
   act_id INT,
   mov_id INT,
   role VARCHAR(20),
   FOREIGN KEY (act_id) REFERENCES actor(act_id) ON DELETE CASCADE,
   FOREIGN KEY (mov_id) REFERENCES movies(mov_id) ON DELETE CASCADE
);

CREATE TABLE rating(
   mov_id INT,
   rev_stars INT,
   FOREIGN KEY (mov_id) REFERENCES movies(mov_id) ON DELETE CASCADE
);

---------------------------------------------------------------
-- 2. INSERT VALUES
---------------------------------------------------------------

INSERT INTO actor VALUES
(101,'RAHUL','M'),
(102,'ANKITHA','F'),
(103,'RADHIKA','F'),
(104,'CHETHAN','M'),
(105,'VIVAN','M');

INSERT INTO director VALUES
(201,'ANUP','918181818'),
(202,'HITCHCOCK','918181812'),
(203,'SHASHANK','918181813'),
(204,'STEVEN SPIELBERG','918181814'),
(205,'ANAND','918181815');

INSERT INTO movies VALUES
(1001,'MANASU',2017,'KANNADA',201),
(1002,'AAKASHAM',2015,'TELUGU',204),
(1003,'KALIYONA',2008,'KANNADA',201),
(1004,'WAR HORSE',2011,'ENGLISH',202),
(1005,'HOME',2012,'ENGLISH',205);

INSERT INTO movie_cast VALUES
(101,1002,'HERO'),
(101,1001,'HERO'),
(103,1003,'HEROINE'),
(103,1002,'GUEST'),
(104,1004,'HERO');

INSERT INTO rating VALUES
(1001,4),
(1002,2),
(1003,5),
(1004,4),
(1005,3);

---------------------------------------------------------------
-- 3. QUERIES
---------------------------------------------------------------

-- Q1) Titles of all movies directed by “Hitchcock”
SELECT mov_title
FROM movies
WHERE dir_id = (
    SELECT dir_id FROM director WHERE dir_name = 'HITCHCOCK'
);

-- Q2) Movie names where actors acted in 2 or more movies
SELECT m.mov_title
FROM movies m
JOIN movie_cast mc USING (mov_id)
WHERE mc.act_id IN (
      SELECT act_id
      FROM movie_cast
      GROUP BY act_id
      HAVING COUNT(mov_id) > 1
)
GROUP BY m.mov_title
HAVING COUNT(*) > 1;

-- Q3) Actors who acted before 2000 AND after 2020
SELECT DISTINCT a.act_name
FROM actor a
JOIN movie_cast mc USING (act_id)
JOIN movies m1 ON mc.mov_id = m1.mov_id
WHERE m1.mov_year < 2000
AND a.act_id IN (
    SELECT act_id
    FROM movie_cast
    JOIN movies m2 USING (mov_id)
    WHERE m2.mov_year > 2020
);

-- Q4) Movie titles & highest number of stars
SELECT mov_title, MAX(rev_stars) AS highest_rating
FROM movies
NATURAL JOIN rating
GROUP BY mov_title
ORDER BY mov_title;

-- Q5) Update ratings of movies directed by Steven Spielberg to 5
UPDATE rating
SET rev_stars = 5
WHERE mov_id IN (
    SELECT mov_id
    FROM movies
    JOIN director USING (dir_id)
    WHERE dir_name = 'STEVEN SPIELBERG'
);

---------------------------------------------------------------
-- END OF FILE
---------------------------------------------------------------
