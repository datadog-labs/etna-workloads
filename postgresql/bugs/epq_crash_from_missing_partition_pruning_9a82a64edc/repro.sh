psql -X -q -c "create table pt (a int, b int) partition by range (a);
create table pt1 partition of pt for values from (0) to (10);
create table pt2 partition of pt for values from (10) to (20);
insert into pt values (1,0),(11,0);"
(psql -X -q <<'S1'
begin;
update pt set b = b + 1 where a = 1;
select pg_sleep(3);
commit;
S1
) &
sleep 1
psql -X -q <<'S2' 2>&1 | grep -v -i -e 'server closed' -e 'terminated abnormally' -e 'before or while' -e 'connection to server' -e 'reset'
set plan_cache_mode to force_generic_plan;
prepare epd as delete from pt where a = $1;
execute epd(1);
select 'done';
S2
wait
sleep 2
psql -X -q -c "select count(*) from pt" 2>&1 | grep -v -i -e 'server' -e 'connection' -e 'FATAL'
