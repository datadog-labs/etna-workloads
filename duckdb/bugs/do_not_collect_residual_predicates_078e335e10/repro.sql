.mode list
.nullvalue NULL
CREATE TABLE e1(x INTEGER);
CREATE TABLE e2(x INTEGER);
CREATE TABLE e3(x INTEGER);
CREATE TABLE e4(x INTEGER);
SELECT count(*)
FROM e1 LEFT JOIN e2 ON (e1.x = e2.x)
        RIGHT JOIN e3 ON (e1.x = e3.x AND e3.x > 0), e4
WHERE e4.x = e1.x;
