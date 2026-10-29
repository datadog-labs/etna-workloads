CREATE TABLE t2(x TEXT);
CREATE INDEX i2 ON t2(x);
INSERT INTO t2 VALUES('''abc'),('''bcd'),('''ax'),('abc');
SELECT * FROM t2 WHERE x LIKE '''a%' ORDER BY x;
