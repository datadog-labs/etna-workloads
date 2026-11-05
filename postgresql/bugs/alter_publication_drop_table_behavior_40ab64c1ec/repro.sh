D=$PWD/tmp_cluster
rm -rf $D
initdb -D $D -A trust >/dev/null
P=54329
pg_ctl -D $D -o "-c wal_level=logical -c listen_addresses='' -c unix_socket_directories=$D -c port=$P" -l $D/log -w start >/dev/null
export PGHOST=$D PGPORT=$P
psql -X -a -q postgres <<'SQL'
create table t(a int);
create publication p for table t;
select 1 from pg_create_logical_replication_slot('s','pgoutput');
insert into t values (1);
alter publication p drop table t;
insert into t values (2);
select count(*) as n_inserts from pg_logical_slot_get_binary_changes('s',NULL,NULL,'proto_version','1','publication_names','p') where get_byte(data,0)=73;
SQL
pg_ctl -D $D -m immediate stop >/dev/null
rm -rf $D
