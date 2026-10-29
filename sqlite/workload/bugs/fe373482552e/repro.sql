CREATE TABLE t0(c0);
INSERT INTO t0 VALUES ('1');
CREATE VIEW v0(c0) AS SELECT CASE WHEN 1 THEN json_patch('1', '1') END FROM t0 GROUP BY t0.c0;
SELECT * FROM v0 WHERE json_quote(v0.c0) != '1';
SELECT *, json_quote(y) FROM (SELECT +json('1') AS y) WHERE json_quote(y)='"1"';
