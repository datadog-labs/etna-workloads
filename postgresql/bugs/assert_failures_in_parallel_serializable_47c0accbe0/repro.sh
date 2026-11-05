D=${TMPDIR:-/tmp}/rp$$; mkdir -p $D
psql -X -q -c "create table foo as select generate_series(1,100)::int a; create index on foo(a); alter table foo set (parallel_workers=2)"
mkfifo $D/f1 $D/f2
psql -X -q -t -A <$D/f1 >$D/o1 2>&1 &
psql -X -q -t -A <$D/f2 >$D/o2 2>&1 &
exec 3>$D/f1 4>$D/f2
echo "begin isolation level serializable;" >&3
cat >&4 <<S
begin isolation level serializable read only;
set parallel_setup_cost=0; set parallel_tuple_cost=0; set min_parallel_index_scan_size=0;
set parallel_leader_participation=off; set enable_seqscan=off;
S
sleep 1
echo "select count(*) from foo;" >&3; sleep 1
echo "select count(*) from foo;" >&4; sleep 1
echo "commit;" >&3; sleep 1
echo "select count(*) from foo;" >&4; sleep 1
echo "commit;" >&4; sleep 1
exec 3>&- 4>&-
wait
sleep 2
cat $D/o1 $D/o2 | sed 's/^.*server closed.*/CRASH/;s/^.*terminated abnormally.*/CRASH/' | grep -v '^$'
psql -X -q -t -c "select 'alive'" 2>&1 | sed 's/.*recovery.*/x/' | head -1
rm -rf $D
