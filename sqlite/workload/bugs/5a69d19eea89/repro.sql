CREATE TABLE t2(k,v);
CREATE TRIGGER r2 AFTER INSERT ON t2 BEGIN
  UPDATE t2 SET (k,v)= (
     (WITH cte1(a) AS ( SELECT 1 FROM ( SELECT * FROM t2 ) )
     SELECT a FROM cte1
  ), 1);
END;
ALTER TABLE t2 RENAME TO t2x;
SELECT sql FROM sqlite_schema WHERE type='trigger';
