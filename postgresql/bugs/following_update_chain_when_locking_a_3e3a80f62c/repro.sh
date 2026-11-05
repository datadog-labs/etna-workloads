D=$PWD/rtmp.$$; mkdir -p $D
Q="psql -X -q -At"
$Q <<'SQL'
create table t(id int primary key);
do $$ declare i int; tid tid; begin
  for i in 1..5000 loop
    insert into t values (i) returning ctid into tid;
    if tid = '(1,1)' then return; end if;
  end loop; end $$;
SQL
mkfifo $D/f1 $D/f2
$Q < $D/f1 > /dev/null 2>&1 &
exec 3> $D/f1
echo "begin; update t set id = 10000 where id = 1;" >&3
sleep 1
$Q < $D/f2 > $D/s2.out 2>&1 &
exec 4> $D/f2
echo "begin; select id from t where id = 1 for update;" >&4
sleep 1
PID=$($Q -c "select pid from pg_stat_activity where wait_event_type='Lock' and datname=current_database()")
kill -STOP $PID
echo "rollback;" >&3
sleep 1
$Q -c "vacuum (index_cleanup on) t"
$Q -c "insert into t values (10001) returning ctid"
kill -CONT $PID
sleep 1
# is the unrelated re-inserted tuple locked by the other session?
$Q -c "select id from t where id = 10001 for update nowait" 2>&1 | sed 's/^.*ERROR/ERROR/'
echo "commit;" >&4
exec 3>&- 4>&-
wait
rm -rf $D
