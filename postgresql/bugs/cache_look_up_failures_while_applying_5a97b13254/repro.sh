D=$PWD/subdata; S=$PWD/subsock; mkdir -p $S
rm -rf $D
initdb -D $D >/dev/null 2>&1
pg_ctl -D $D -o "-p 54999 -c unix_socket_directories=$S -c listen_addresses= -c wal_level=logical" -w -l $PWD/sub.log start >/dev/null
SP="psql -X -q -h $S -p 54999 -d postgres"
P="psql -X -q -At"
$P -c "alter system set wal_level=logical" >/dev/null
pg_ctl -D $PGDATA -w -l $PWD/pub.log restart >/dev/null 2>&1
$P -c "CREATE TABLE tab5 (a int NOT NULL, b int); CREATE UNIQUE INDEX tab5_a_idx ON tab5 (a); ALTER TABLE tab5 REPLICA IDENTITY USING INDEX tab5_a_idx; CREATE PUBLICATION pub FOR TABLE tab5;"
$SP -c "CREATE TABLE tab5 (a int NOT NULL, b int, c int) PARTITION BY LIST (a); CREATE TABLE tab5_1 PARTITION OF tab5 DEFAULT; CREATE UNIQUE INDEX tab5_a_idx ON tab5 (a); ALTER TABLE tab5 REPLICA IDENTITY USING INDEX tab5_a_idx; ALTER TABLE tab5_1 REPLICA IDENTITY USING INDEX tab5_1_a_idx;"
$SP -c "CREATE SUBSCRIPTION sub CONNECTION 'host=$PGHOST port=$PGPORT dbname=postgres' PUBLICATION pub"
sleep 3
$P -c "INSERT INTO tab5 VALUES (1,1); UPDATE tab5 SET a=2 WHERE a=1;"
sleep 2
$SP -At -c "SELECT a,b FROM tab5 ORDER BY 1"
$SP -c "ALTER TABLE tab5 DETACH PARTITION tab5_1; ALTER TABLE tab5_1 DROP COLUMN b; ALTER TABLE tab5_1 ADD COLUMN b int; ALTER TABLE tab5 ATTACH PARTITION tab5_1 DEFAULT"
$P -c "UPDATE tab5 SET a=3 WHERE a=2"
sleep 3
$SP -At -c "SELECT a,b,c FROM tab5 ORDER BY 1"
grep -c "terminated by signal\|cache lookup failed" $PWD/sub.log
$SP -c "DROP SUBSCRIPTION sub" >/dev/null
pg_ctl -D $D -m immediate stop >/dev/null
$P -c "DROP PUBLICATION pub; DROP TABLE tab5"
