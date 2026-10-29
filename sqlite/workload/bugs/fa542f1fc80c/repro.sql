.open file:shr6?mode=memory&cache=shared
CREATE TABLE t1(a,b);
.connection 1
.open file:shr6?mode=memory&cache=shared
.connection 2
.open file:shr6?mode=memory&cache=shared
.connection 3
.open file:shr6?mode=memory&cache=shared
.connection 1
BEGIN;
.connection 2
BEGIN;
SELECT * FROM t1;
.connection 1
INSERT INTO t1 VALUES(1,2);
.connection 3
BEGIN;
ROLLBACK;
SELECT * FROM t1;
