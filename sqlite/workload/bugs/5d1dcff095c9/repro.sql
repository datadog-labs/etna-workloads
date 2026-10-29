.open file:m?mode=memory&cache=shared
CREATE TABLE t2(x, y);
INSERT INTO t2 VALUES(1, 2);
INSERT INTO t2 VALUES(3, 4);
.connection 1
.open file:m?mode=memory&cache=shared
.connection 0
BEGIN;
DELETE FROM t2;
.connection 1
SELECT * FROM t2;
.connection 0
COMMIT;
