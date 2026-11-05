CREATE TABLE tbl (c1 int, c2 int, c3 int, c4 box, UNIQUE(c1,c2) INCLUDE(c3,c4));
INSERT INTO tbl SELECT x, 2*x, NULL, NULL FROM generate_series(1,10) AS x;
SET enable_seqscan = off;
explain (costs off) select * from tbl where (c1,c2,c3) < (2,5,1);
select * from tbl where (c1,c2,c3) < (2,5,1);
