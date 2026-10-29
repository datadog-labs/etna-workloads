"$SQLITE3" -batch -init /dev/null <<'SQL' 2>&1
.open test.db
ATTACH 'test.db2' AS aux;
CREATE TABLE main.t1(a, b);
CREATE TABLE aux.t2(c, d);
.connection 1
.open test.db
BEGIN; SELECT * FROM t1;
.connection 0
BEGIN;
INSERT INTO t1 VALUES(1, 2);
INSERT INTO t2 VALUES(1, 2);
COMMIT;
.connection 1
COMMIT;
.connection 0
COMMIT;
SELECT * FROM t1;
SQL
echo "exit=$?"
ls | grep mj
