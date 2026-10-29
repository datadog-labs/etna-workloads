CREATE TABLE j1(a);
SELECT * FROM j1 WHERE (select min(a) FROM j1) IN (?, ?, ?);
