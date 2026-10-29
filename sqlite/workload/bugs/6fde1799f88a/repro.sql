CREATE TABLE t1(a, b, c, d);
INSERT INTO t1 VALUES(1, 2, 3, 4);
INSERT INTO t1 VALUES(5, 6, 7, 8);
INSERT INTO t1 VALUES(9, 10, 11, 12);
SELECT row_number() OVER win, rank() OVER win, dense_rank() OVER win,
 ntile(2) OVER win, first_value(d) OVER win, last_value(d) OVER win,
 nth_value(d,2) OVER win, lead(d) OVER win, lag(d) OVER win,
 max(d) OVER win, min(d) OVER win
FROM t1 WINDOW win AS (ORDER BY a);
