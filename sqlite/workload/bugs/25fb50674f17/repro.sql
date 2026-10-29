CREATE VIRTUAL TABLE ft USING fts5(a, b, c);
CREATE VIRTUAL TABLE t2 USING fts5vocab('ft','row');
CREATE VIRTUAL TABLE t3 USING fts5vocab('ft','row');
BEGIN;
INSERT INTO ft(b) VALUES('x y');
SELECT t2.term, t3.term FROM t2, t3;
