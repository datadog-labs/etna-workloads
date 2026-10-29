CREATE TABLE t1(a);
CREATE VIEW v2(c) AS
    WITH x AS (
      WITH y AS (
         WITH z AS(SELECT * FROM t1)
         SELECT * FROM v2
      ) SELECT a
    ) SELECT * from t1;
ALTER TABLE t1 RENAME COLUMN a TO b;
SELECT sql FROM sqlite_schema WHERE name='t1';
INSERT INTO t1 VALUES(55);
SELECT * FROM v2;
