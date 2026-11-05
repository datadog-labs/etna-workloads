CREATE TABLE base_tbl (a int PRIMARY KEY, b int);
CREATE TABLE ref_tbl (a int PRIMARY KEY);
CREATE VIEW rw_view1 AS SELECT * FROM base_tbl b WHERE EXISTS(SELECT 1 FROM ref_tbl r WHERE r.a = b.a) WITH CHECK OPTION;
EXPLAIN (costs off) INSERT INTO rw_view1 VALUES (5);
EXPLAIN (costs off) UPDATE rw_view1 SET a = a + 5;
