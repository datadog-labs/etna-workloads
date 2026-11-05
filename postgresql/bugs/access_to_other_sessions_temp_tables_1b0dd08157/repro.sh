(printf "create temp table t as select 1 x;\nselect pg_sleep(6);\n" | psql -X -q >/dev/null 2>&1 &)
for i in $(seq 50); do
  n=$(psql -X -Atq -c "select count(*) from pg_class where relname='t' and relpersistence='t'")
  [ "$n" = 1 ] && break; sleep 0.2
done
psql -X -a -q 2>&1 <<'SQL'
select format('%I.t', n.nspname) as tn from pg_class c join pg_namespace n on n.oid=c.relnamespace where c.relname='t' and c.relpersistence='t' \gset
set enable_indexscan=off;
select * from :tn;
update :tn set x=2;
delete from :tn;
SQL
sleep 6
