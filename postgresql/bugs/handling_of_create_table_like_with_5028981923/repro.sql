CREATE TABLE p1 (a int, b int);
CREATE TABLE p2 (x int, c int, d int GENERATED ALWAYS AS (c * 2) STORED);
CREATE TABLE ch () INHERITS (p1, p2);
INSERT INTO ch (a,b,x,c) VALUES (1,2,3,10);
SELECT * FROM ch;
