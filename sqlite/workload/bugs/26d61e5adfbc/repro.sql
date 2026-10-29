CREATE TABLE t1(a, b, c);
CREATE VIEW v0 AS
  WITH p AS ( SELECT 1 FROM t1 ),
       g AS ( SELECT 1 FROM p, t1 )
  SELECT 1 FROM g;
ALTER TABLE t1 RENAME TO t2;
SELECT sql FROM sqlite_schema WHERE name='v0';
