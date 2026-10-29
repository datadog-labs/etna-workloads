CREATE TABLE t1(a INT, b TEXT, c INT, d INT);
INSERT INTO t1(a,b,c,d) VALUES
  (1, '{"x":1}', 12,  3),
  (1, '{"x":2}',  4,  5),
  (1, '{"x":1}',  6, 11),
  (2, '{"x":1}', 22,  3),
  (2, '{"x":2}',  4,  5),
  (3, '{"x":1}',  6,  7);
CREATE INDEX t1x ON t1(a, d, b->>'x', c);
SELECT a, SUM(1), SUM(CASE WHEN b->>'x'=1 THEN 1 END), SUM(c), SUM(CASE WHEN b->>'x'=1 THEN c END)
  FROM t1 WHERE d BETWEEN 0 and 10 GROUP BY a;
