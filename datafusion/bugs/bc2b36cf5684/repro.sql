CREATE TABLE table1 (a INT, b INT, c INT, d INT) AS VALUES (1, 10, 100, 1000), (2, 20, 200, 2000);
SELECT * EXCEPT(a, b, c, d) FROM table1;
SELECT * EXCEPT(a, b, c, d) FROM table1 LIMIT 1;
SELECT * EXCLUDE(a, b, c, d) FROM table1 WHERE a = 1;
