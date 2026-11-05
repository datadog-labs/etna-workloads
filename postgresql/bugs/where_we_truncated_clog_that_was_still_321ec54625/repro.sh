psql -X -q -c "create table t(a int)"
rm -f done.flag listener.out
( echo "listen s;"; echo "begin;"
  while [ ! -f done.flag ]; do sleep 0.2; done
  echo "commit;" ) | psql -X -q -a -f - > listener.out 2>&1 &
sleep 1
for i in 1 2 3; do psql -X -q -c "NOTIFY s, '$i'"; done
# consume > 1M xids (one CLOG segment) using subtransactions
psql -X -q -c "DO \$\$ BEGIN FOR i IN 1..1100000 LOOP BEGIN INSERT INTO t VALUES (1); EXCEPTION WHEN division_by_zero THEN NULL; END; END LOOP; END \$\$"
psql -X -q -c "select 1" > /dev/null
psql -X -q -c "alter database template0 allow_connections true"
for d in template1 postgres template0; do
  vacuumdb -f --freeze -d $d -q 2>&1 | head -3
done
touch done.flag
wait
grep -v '^$' listener.out | sed 's/PID [0-9]*/PID/'
rm -f done.flag listener.out
