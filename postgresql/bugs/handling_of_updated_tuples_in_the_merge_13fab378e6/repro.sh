psql -X -q -c "create table target(key int, val text); insert into target values (1,'a');"
( echo "begin;"; echo "update target set key=2, val='x' where key=1;"; sleep 3; echo "commit;" ) | psql -X -q -a >/dev/null 2>&1 &
sleep 1
psql -X -a -q 2>&1 <<'SQL'
begin isolation level repeatable read;
merge into target t using (select 1 as key) s on s.key=t.key
 when not matched then insert values (s.key,'ins')
 when matched then update set key=t.key+1;
commit;
SQL
wait
psql -X -q -c "select * from target order by 1,2"
