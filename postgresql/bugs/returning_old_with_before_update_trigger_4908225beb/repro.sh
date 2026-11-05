psql -X -q -c "create table t(k int primary key, d text); insert into t values (1,'a');
create function trg() returns trigger language plpgsql as 'begin return new; end';
create trigger t_b before update on t for each row execute function trg();"
( psql -X -q -c "begin; update t set d = d || '-s1' where k=1; select pg_sleep(2); commit;" >/dev/null ) &
sleep 0.7
psql -X -q -c "update t set d = d || '-s2' where k=1 returning old.d as old_d, new.d as new_d;"
wait
