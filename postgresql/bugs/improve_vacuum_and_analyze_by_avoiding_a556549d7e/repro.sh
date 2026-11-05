psql -X -q -c "DROP TABLE IF EXISTS vt; CREATE TABLE vt(a int); DROP ROLE IF EXISTS vr; CREATE ROLE vr;"
( psql -X -q -c "BEGIN; LOCK vt IN SHARE UPDATE EXCLUSIVE MODE; SELECT pg_sleep(4); COMMIT;" >/dev/null ) &
until [ "$(psql -X -At -c "select count(*) from pg_locks l join pg_class c on c.oid=l.relation where c.relname='vt' and l.mode='ShareUpdateExclusiveLock' and l.granted")" = 1 ]; do sleep 0.1; done
psql -X -a -q -c "SET ROLE vr" -c "SET lock_timeout='1s'" -c "VACUUM vt" -c "ANALYZE vt" 2>&1
wait
