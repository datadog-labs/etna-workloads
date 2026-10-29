CREATE TABLE t1(x, y, z AS (date()));
INSERT INTO t1(x,y) VALUES(1,2);
