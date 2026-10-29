CREATE TABLE t(a TEXT);
INSERT INTO t VALUES('abc'),('xbc'),('abd');
.parameter set @p 'ab%'
SELECT a FROM t WHERE a LIKE @p;
