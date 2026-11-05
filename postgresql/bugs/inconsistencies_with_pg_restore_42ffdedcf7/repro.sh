D=$PWD/rt_tmp; mkdir -p $D
psql -X -q -c "create schema s; create table s.t(a int); create index si on s.t(a); insert into s.t select generate_series(1,10); analyze s.t;"
pg_dump -Fc --statistics -f $D/d.dump postgres
echo schema; pg_restore --statistics-only --schema s -f - $D/d.dump | grep -c 'pg_restore_relation_stats'
echo table; pg_restore --statistics-only --table t --schema s -f - $D/d.dump | grep -c 'pg_restore_relation_stats'
echo index; pg_restore --statistics-only --index si --schema s -f - $D/d.dump | grep -c 'pg_restore_relation_stats'
rm -rf $D
