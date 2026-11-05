PGOPTIONS="-c allow_in_place_tablespaces=on" psql -X -q -c "CREATE TABLESPACE regress_ts LOCATION ''" 2>&1
pg_dumpall -g 2>&1 | grep 'CREATE TABLESPACE'
psql -X -q -c "DROP TABLESPACE regress_ts" 2>&1
exit 0
