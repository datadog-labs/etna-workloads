d=$PWD/fpw_tmp; rm -rf $d; mkdir $d
psql -X -q -At <<SQL >/dev/null
create table t(a int);
checkpoint;
insert into t values (1);
SQL
f=$(psql -X -At -c "select pg_walfile_name(pg_switch_wal())")
pg_waldump --save-fullpage=$d -p $PGDATA/pg_wal $f >/dev/null 2>&1
ls $d | sed 's/[0-9A-F]\{8\}/H/g; s/\.[0-9][0-9]*/.N/g' | sort -u
rm -rf $d
