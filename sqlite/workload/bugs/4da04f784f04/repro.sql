CREATE TABLE t3(x);
INSERT INTO t3 VALUES(1);
CREATE TABLE t4(y, z);
CREATE INDEX t4i ON t4(y, ifnull(z, '!!!'));
SELECT ifnull(z, '!!!') FROM t3 LEFT JOIN t4 ON (x=y);
