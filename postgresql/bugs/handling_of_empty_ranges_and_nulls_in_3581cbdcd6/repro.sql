CREATE EXTENSION pageinspect;
CREATE TABLE t (a int);
CREATE INDEX ti ON t USING brin (a) WITH (pages_per_range=1);
INSERT INTO t VALUES (NULL);
INSERT INTO t VALUES (1);
SELECT allnulls, hasnulls, value FROM brin_page_items(get_raw_page('ti', 2), 'ti');
SET enable_seqscan=off;
SET enable_indexscan=off;
SELECT count(*) FROM t WHERE a IS NULL;
