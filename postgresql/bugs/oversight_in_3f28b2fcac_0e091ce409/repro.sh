D=$PWD/rtmp; rm -rf $D; mkdir -p $D
for n in pub sub; do
  initdb -D $D/$n >/dev/null
  printf "wal_level=logical\nlisten_addresses=''\nunix_socket_directories='$D'\n" >> $D/$n/postgresql.conf
done
echo "port=5441" >> $D/pub/postgresql.conf
echo "port=5442" >> $D/sub/postgresql.conf
pg_ctl -D $D/pub -l $D/pub.log -w start >/dev/null
pg_ctl -D $D/sub -l $D/sub.log -w start >/dev/null
P="psql -X -q -h $D -d postgres"
$P -p 5441 -c "CREATE TABLE t1(a int)" -c "CREATE PUBLICATION pb FOR TABLE t1;"
$P -p 5442 -c "CREATE TABLE t1(a int)" -c "CREATE SUBSCRIPTION sb CONNECTION 'host=$D port=5441 dbname=postgres' PUBLICATION pb;"
for i in $(seq 100); do
  [ "$($P -p 5442 -Atc "select count(*) from pg_subscription_rel where srsubstate='r'")" = 1 ] && break; sleep 0.2
done
$P -p 5442 -c "
CREATE FUNCTION f() RETURNS trigger AS \$\$ BEGIN BEGIN RAISE EXCEPTION 'x'; EXCEPTION WHEN OTHERS THEN RETURN NEW; END; RETURN NEW; END; \$\$ LANGUAGE plpgsql;
CREATE TRIGGER tr AFTER INSERT ON t1 FOR EACH ROW EXECUTE FUNCTION f();
ALTER TABLE t1 ENABLE ALWAYS TRIGGER tr;"
Q="SELECT remote_lsn FROM pg_replication_origin_status os, pg_subscription s WHERE os.external_id='pg_'||s.oid AND s.subname='sb'"
L=$($P -p 5442 -Atc "$Q")
$P -p 5441 -c "INSERT INTO t1 VALUES (1);"
for i in $(seq 100); do
  [ "$($P -p 5442 -Atc "select count(*) from t1")" = 1 ] && break; sleep 0.2
done
sleep 1
echo "advanced:"
$P -p 5442 -Atc "SELECT remote_lsn > '$L' FROM pg_replication_origin_status os, pg_subscription s WHERE os.external_id='pg_'||s.oid AND s.subname='sb'"
$P -p 5442 -c "drop subscription sb" >/dev/null 2>&1
pg_ctl -D $D/sub -m immediate stop >/dev/null
pg_ctl -D $D/pub -m immediate stop >/dev/null
