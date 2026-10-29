CREATE TABLE t2(x INTEGER PRIMARY KEY, a TEXT COLLATE nocase, b TEXT COLLATE rtrim);
CREATE INDEX t2a ON t2(a);
CREATE INDEX t2b ON t2(b);
INSERT INTO t2 VALUES(1,'abc','abc'),(2,'abC','abC'),(3,'abc ','abc '),(4,'ABC ','ABC ');
ANALYZE;
SELECT idx, stat FROM sqlite_stat1 WHERE tbl='t2' ORDER BY idx;
