"$SQLITE3" -batch -init /dev/null :memory: <<'SQL' 2>&1
.open file:repro_a.db?cache=shared
create table t4(a);
insert into t4 values(1);
BEGIN;
SELECT * FROM sqlite_master;
.connection 1
.open file:repro_a.db?cache=shared
PRAGMA journal_mode = truncate;
BEGIN;
UPDATE t4 SET a = 10 WHERE 0;
COMMIT;
PRAGMA lock_status;
SQL
echo "rc=$?"
