CREATE TABLE src (a int, b int, c int, d int);
CREATE TABLE tgt (a int, b int, c int, d int);
CREATE TABLE ref (ab int, cd int);
EXPLAIN (verbose, costs off)
MERGE INTO tgt t
USING (SELECT *, (SELECT count(*) FROM ref r
                   WHERE r.ab = s.a + s.b
                     AND r.cd = s.c - s.d) cnt
         FROM src s) s
ON t.a = s.a AND t.b < s.cnt
WHEN MATCHED AND t.c > s.cnt THEN
  UPDATE SET (b, c) = (SELECT s.b, s.cnt);
