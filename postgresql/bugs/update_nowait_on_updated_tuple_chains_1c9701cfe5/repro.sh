psql -X -q -c "create table foo(id int primary key, data text not null); insert into foo values (1,'x');"
(
  echo "select pg_advisory_lock(0);"
  sleep 2
  echo "update foo set data=data; begin; update foo set data=data; select pg_advisory_unlock(0);"
  sleep 6
  echo "commit;"
) | psql -X -q >/dev/null 2>&1 &
sleep 1
psql -X -q -c "set lock_timeout='2s'" -c "select * from foo where pg_advisory_lock(0) is not null for update nowait" 2>&1
wait
