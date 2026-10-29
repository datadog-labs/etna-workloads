CREATE TABLE t1(x, y, CHECK( date(x) BETWEEN '2017-07-01' AND '2017-07-31' ));
INSERT INTO t1(x,y) VALUES('now','two');
CREATE TABLE t600(a REAL CHECK( a<julianday('now') ));
INSERT INTO t600(a) VALUES(1.0);
INSERT INTO t600(a) VALUES(julianday('now')+10);
