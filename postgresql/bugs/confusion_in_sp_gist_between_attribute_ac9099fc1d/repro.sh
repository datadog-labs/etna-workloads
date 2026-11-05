D=$(dirname "$0")
BIN=$(dirname "$(command -v psql)")
gcc -shared -fPIC -I"$BIN/../include/server" -o ./spgn.so "$D/spgist_name_ops.c" || exit 1
sed -e "/^.echo/d" -e "s#MODULE_PATHNAME#$PWD/spgn#" "$D/spgist_name_ops--1.0.sql" > ./spgn_load.sql
psql -X -a -q <<SQL 2>&1
\i ./spgn_load.sql
create table t(f1 name, f2 integer, f3 text);
create index on t using spgist(f1) include(f2, f3);
insert into t select proname, case when length(proname)%2=0 then pronargs end, prosrc from pg_proc;
vacuum analyze t;
set enable_seqscan=off; set enable_bitmapscan=off;
select count(*), min(f1), max(f1) from t where f1 > 'binary_upgrade_set_n' and f1 < 'binary_upgrade_set_p';
SQL
