.mode list
.nullvalue NULL
CREATE TABLE t(s VARCHAR);
INSERT INTO t VALUES ('a'), (NULL);
SELECT * FROM t WHERE s ^@ nullif(NULL::VARCHAR, s);
