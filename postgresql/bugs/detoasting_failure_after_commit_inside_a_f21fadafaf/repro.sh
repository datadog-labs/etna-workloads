psql -X -q <<'SQL'
create table test1(a int, b text);
alter table test1 alter column b set storage external;
insert into test1 values (1, repeat('foo', 2000));
SQL
( echo "select pg_advisory_lock(1);"; sleep 6; ) | psql -X -q -o /dev/null &
sleep 1
psql -X -q 2>&1 <<'SQL' | sed 's/value [0-9]* in pg_toast_[0-9]*/value N in T/' > out1.txt &
do $$ declare r record; begin
 insert into test1 values (2, repeat('bar', 3000));
 insert into test1 values (3, repeat('baz', 4000));
 for r in select test1.b from test1 loop
  delete from test1; commit;
  perform pg_advisory_lock(1);
  raise notice 'length(r) = %', length(r::text);
 end loop; end; $$;
SQL
sleep 2
psql -X -q -c "vacuum test1"
wait
cat out1.txt
