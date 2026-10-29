.dbconfig defensive off
CREATE VIRTUAL TABLE t1 USING fts4(a, b, c, d, e,f,g,h,i,j,k,l,m,n,o,p,q,r);
INSERT INTO t1 VALUES('X Y', '2', '3', '4', '5', '6', '7', '8', '9', '0','a','b','c','d','e','f','g','h');
UPDATE t1_docsize SET size=x'88' WHERE docid=1;
SELECT quote(matchinfo(t1, 'l')) FROM t1 WHERE t1 MATCH 'X Y';
DROP TABLE t1;
CREATE VIRTUAL TABLE t1 USING fts4(a,b,c,d);
INSERT INTO t1 VALUES('one two','three four','five six','seven eight');
UPDATE t1_stat SET value=x'' WHERE id=0;
SELECT quote(matchinfo(t1,'a')) FROM t1 WHERE t1 MATCH 'one two';
