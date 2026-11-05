psql -X -q -c "CREATE FUNCTION foofunc(d integer) RETURNS integer AS \$\$ SELECT 1; /* $(psql -X -At -c "select string_agg(md5(i::text),'') from generate_series(1,400) i") */ \$\$ LANGUAGE SQL"
TOAST=$(psql -X -At -c "select indexrelid::regclass from pg_index where indrelid=(select reltoastrelid from pg_class where oid='pg_proc'::regclass)")
# B holds a lock on pg_proc's toast index and creates an overloaded function
( echo "BEGIN; REINDEX INDEX $TOAST; SELECT pg_sleep(2);"
  echo "CREATE FUNCTION foofunc() RETURNS integer AS \$\$ SELECT 123 \$\$ LANGUAGE SQL; COMMIT;" ) | psql -X -q -o /dev/null &
sleep 1
# A builds catcache list for foofunc, blocks on toast lock during detoasting
psql -X -q -At -c "SELECT foofunc(1)" -c "SELECT foofunc()" 2>&1
wait
