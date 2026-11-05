psql -X -q -c "create table tg(key int, status text, val text);
insert into tg values (1,'s1','x');
create function trg() returns trigger language plpgsql as \$\$ begin return new; end \$\$;
create trigger t before update on tg for each row execute function trg();"
( psql -X -q -c "begin; update tg set status='s2', val=val||'u'; select pg_sleep(3); commit;" >/dev/null 2>&1 ) &
sleep 1
psql -X -q -c "merge into tg t using (select 1 as key) s on s.key=t.key
 when matched and status='s1' then update set status='s2', val=t.val||' w1'
 when matched and status='s2' then update set status='s3', val=t.val||' w2';" 2>&1 | grep -c "server closed\|terminated\|ERROR" 
wait
sleep 2
psql -X -q -c "select * from tg" 2>&1 | head -5
