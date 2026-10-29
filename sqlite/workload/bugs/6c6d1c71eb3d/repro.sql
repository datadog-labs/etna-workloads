PRAGMA auto_vacuum = 0;
PRAGMA page_size = 1024;
CREATE TABLE t1(x);
INSERT INTO t1 VALUES(hex(randomblob(2000)));
SELECT pageno, pgoffset FROM dbstat;
