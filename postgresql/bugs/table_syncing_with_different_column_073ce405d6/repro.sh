D=$PWD/rp_tmp; rm -rf $D; mkdir $D
export PGHOST=$D PGPORT=54711
initdb -D $D/p -A trust >/dev/null 2>&1
initdb -D $D/s -A trust >/dev/null 2>&1
pg_ctl -D $D/p -o "-c wal_level=logical -c listen_addresses='' -k $D -p 54711" -w -l $D/p.log start >/dev/null
pg_ctl -D $D/s -o "-c listen_addresses='' -k $D -p 54712" -w -l $D/s.log start >/dev/null
psql -X -q -p 54711 postgres -c "CREATE TABLE tab_mixed (a int primary key, b text)" -c "INSERT INTO tab_mixed VALUES (1,'foo')" -c "CREATE PUBLICATION pub FOR TABLE tab_mixed"
psql -X -q -p 54712 postgres -c "CREATE TABLE tab_mixed (c text, b text, a int primary key)" -c "CREATE SUBSCRIPTION sub CONNECTION 'host=$D port=54711 dbname=postgres' PUBLICATION pub" 2>&1 | grep -v NOTICE
for i in $(seq 1 15); do
  n=$(psql -X -At -p 54712 postgres -c "select count(*) from pg_subscription_rel where srsubstate='r'")
  [ "$n" = 1 ] && break
  sleep 1
done
psql -X -p 54712 postgres -c "select c,b,a from tab_mixed"
psql -X -At -p 54712 postgres -c "select count(*) from pg_subscription_rel where srsubstate='r'"
psql -X -q -p 54712 postgres -c "ALTER SUBSCRIPTION sub DISABLE" -c "ALTER SUBSCRIPTION sub SET (slot_name=NONE)" -c "DROP SUBSCRIPTION sub" >/dev/null 2>&1
pg_ctl -D $D/s -m immediate stop >/dev/null; pg_ctl -D $D/p -m immediate stop >/dev/null
rm -rf $D
