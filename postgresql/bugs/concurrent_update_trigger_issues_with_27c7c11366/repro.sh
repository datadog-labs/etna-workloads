psql -X -q -c "create table t(k int, b int); insert into t values (1,50);
create function trg() returns trigger language plpgsql as \$\$ begin return new; end \$\$;
create trigger t_bu before update on t for each row execute function trg();"
psql -X -q -c "begin; update t set b = b + 10 where k = 1; select pg_sleep(3); commit;" >/dev/null &
sleep 1
psql -X -a -q -c "with m as (merge into t using (select 1 as k) s on s.k = t.k when matched then update set b = t.b * 2 returning t.*) select * from m;" 2>&1 | grep -v '^server closed\|^connection\|^This\|^	' | head -5
wait
psql -X -q -c "select * from t" 2>&1 | head -5
