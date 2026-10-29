CREATE TABLE t6(a,b,c,d,e,f,g,h);
INSERT INTO t6 VALUES(1,2,3,4,5,6,7,8);
.auth ON
UPDATE t6 SET rowid=rowid+100;
.auth OFF
SELECT rowid, * FROM t6;
