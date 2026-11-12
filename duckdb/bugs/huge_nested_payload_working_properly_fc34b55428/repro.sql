CREATE TABLE t AS SELECT i, [[CASE WHEN (i+j)%3=0 THEN [] ELSE range(i%50) END for j in range(i%7)]] AS l FROM range(100000) r(i);
SELECT count(DISTINCT l) FROM t;
SELECT count(*) FROM t a JOIN t b USING (i) WHERE a.l=b.l;
SELECT count(DISTINCT [[x for x in h] for h in l]) FROM t;
