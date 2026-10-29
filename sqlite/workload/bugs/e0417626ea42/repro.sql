CREATE VIRTUAL TABLE t1 USING fts4(prefix=0);
INSERT INTO t1 VALUES('Twas Mulga Bill, from Eaglehawk, ');
SELECT count(*) FROM t1_segdir;
