psql -X -q -c "create table p(a int) partition by range(a); create table c partition of p for values from (0) to (10); create index pi on p(a);"
( psql -X -q -c "begin; lock table c in access share mode; select pg_sleep(4); commit;" >/dev/null ) &
sleep 1
( psql -X -q -c "drop index pi;" ) &
sleep 1.5
psql -X -At -c "select c.relname, l.mode, l.granted from pg_locks l join pg_class c on c.oid=l.relation where c.relname in ('p','pi','c','c_a_idx') and l.mode='AccessExclusiveLock' order by 1,3"
wait
