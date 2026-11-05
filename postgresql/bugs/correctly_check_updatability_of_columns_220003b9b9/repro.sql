CREATE TABLE t (a int);
CREATE VIEW v AS SELECT a, a+1 AS s FROM t;
INSERT INTO v (s, a) VALUES (default, 1);
