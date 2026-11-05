psql -X -q -c "CREATE TABLE t(a int, CONSTRAINT u UNIQUE(a) DEFERRABLE INITIALLY DEFERRED)"
( psql -X -q -c "BEGIN ISOLATION LEVEL REPEATABLE READ" -c "SELECT 1" -c "SELECT pg_sleep(6)" >/dev/null 2>&1 ) &
sleep 1
( psql -X -q -c "REINDEX TABLE CONCURRENTLY t" >/dev/null 2>&1 ) &
# wait until reindex blocks on the old snapshot holder
for i in $(seq 1 50); do
  n=$(psql -X -At -c "SELECT count(*) FROM pg_locks WHERE locktype='virtualxid' AND NOT granted")
  [ "$n" -gt 0 ] && break
  sleep 0.1
done
psql -X -a -q <<'S'
BEGIN;
INSERT INTO t VALUES (1);
INSERT INTO t VALUES (1);
DELETE FROM t WHERE a=1;
INSERT INTO t VALUES (1);
COMMIT;
SELECT * FROM t;
S
wait
