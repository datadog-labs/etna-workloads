CREATE TABLE t AS SELECT i, [i*3+1, i*3+2, i*3+3] AS l FROM range(100) r(i);
SELECT i, l::INT[3] = [298,299,300] FROM t WHERE i = 99;
