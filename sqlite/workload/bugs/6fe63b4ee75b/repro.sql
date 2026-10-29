CREATE TABLE t1(a);
INSERT INTO t1 VALUES(1);
SELECT count(*) FROM dbstat WHERE aggregate = NULL;
SELECT aggregate=1 FROM dbstat WHERE aggregate = 5;
