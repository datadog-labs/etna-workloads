CREATE TABLE t1(a,b,c,d);
CREATE TABLE t2(a,b,c,d);
PRAGMA hard_heap_limit=86750;
SELECT row_number() OVER win FROM t1 WINDOW win AS (ORDER BY (SELECT percent_rank() OVER win2 FROM t2 WINDOW win2 AS (ORDER BY a)));
