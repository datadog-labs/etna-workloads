CREATE TABLE t1(x INTEGER, y INTEGER);
INSERT INTO t1 VALUES(1,2),(3,4),(5,6),(7,8),(9,10);
SELECT lead(y) OVER win, lead(y,2) OVER win, lead(y,3,'default') OVER win FROM t1 WINDOW win AS (ORDER BY x);
