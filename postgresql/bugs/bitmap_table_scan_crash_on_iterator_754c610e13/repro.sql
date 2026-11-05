SET enable_seqscan = off;
SET enable_indexscan = off;
CREATE TEMP TABLE rescan_bhs (a INT);
INSERT INTO rescan_bhs VALUES (1), (2);
CREATE INDEX ON rescan_bhs (a);
SELECT * FROM rescan_bhs t1 LEFT JOIN rescan_bhs t2 ON t1.a IN
  (SELECT a FROM rescan_bhs t3 WHERE t2.a > 1);
