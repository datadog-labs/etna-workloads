.dbconfig defensive off
CREATE VIRTUAL TABLE t USING fts3(x);
WITH c(n) AS (SELECT 1 UNION ALL SELECT n+1 FROM c WHERE n<2000)
INSERT INTO t SELECT group_concat('word'||(n*100+k),' ') FROM c, (SELECT 1 k UNION SELECT 2) GROUP BY n%2;
CREATE TABLE r(blockid INTEGER PRIMARY KEY, block BLOB);
INSERT INTO r SELECT blockid, block FROM t_segments;
SELECT count(*) FROM r;
PRAGMA writable_schema=ON;
UPDATE sqlite_schema SET type='view', rootpage=0, sql='CREATE VIEW t_segments AS SELECT blockid, block FROM r' WHERE name='t_segments';
PRAGMA schema_version=12345;
PRAGMA writable_schema=OFF;
SELECT type FROM sqlite_schema WHERE name='t_segments';
SELECT count(*) FROM t WHERE t MATCH 'word100001';
