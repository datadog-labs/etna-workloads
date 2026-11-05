D=${TMPDIR:-/tmp}/rp$$; mkdir -p $D
psql -X -q -c "drop table if exists t; create table t(id int primary key, v text); insert into t values (1,'one');"
mkfifo $D/f
psql -X -q -a < $D/f > $D/out 2>&1 &
P=$!
exec 3> $D/f
echo "begin isolation level repeatable read; select count(*) from t;" >&3
sleep 1
psql -X -q -c "update t set v='two' where id=1"
echo "select * from t for key share;" >&3
echo "select * from t;" >&3
echo "commit;" >&3
exec 3>&-
wait $P
cat $D/out
rm -rf $D
