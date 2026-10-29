CREATE TABLE t1(x,y);
SELECT row_number(x) OVER () FROM t1;
