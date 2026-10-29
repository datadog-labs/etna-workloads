CREATE TABLE t1(x);
INSERT INTO t1 VALUES(NULL);
CREATE INDEX t1x ON t1(coalesce(x,pi()));
SELECT json_quote(coalesce(x,pi())) FROM t1 INDEXED BY t1x;
