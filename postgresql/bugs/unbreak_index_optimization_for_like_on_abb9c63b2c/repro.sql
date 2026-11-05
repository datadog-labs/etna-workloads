CREATE TABLE byteatest (a bytea PRIMARY KEY, b int);
SELECT * FROM byteatest WHERE a LIKE '%1%';
