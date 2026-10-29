CREATE TABLE t0(c0 TEXT, c1 INT);
INSERT INTO t0 VALUES ('1', 10);
CREATE INDEX i0 ON t0(c1) WHERE c0=json_quote(1);
SELECT * FROM t0 WHERE (c0=json_quote(1) AND json_array(c0)='[1]');
