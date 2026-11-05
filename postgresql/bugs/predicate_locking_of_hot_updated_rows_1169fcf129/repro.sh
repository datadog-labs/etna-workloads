D=$PWD/tmp_repro; mkdir -p $D; rm -f $D/*
mkfifo $D/a $D/b
psql -X -q -c "create table test (i int primary key, t text)" -c "insert into test values (5,'apple'),(7,'pear'),(11,'banana')" -c "update test set t='pear_hot' where i=7"
psql -X -q -a < $D/a > $D/oa 2>&1 &
pa=$!
psql -X -q -a < $D/b > $D/ob 2>&1 &
pb=$!
exec 3>$D/a 4>$D/b
S="set enable_seqscan=off; set enable_bitmapscan=off;"
w() { echo "$2" >&$1; sleep 0.5; }
w 3 "$S"; w 4 "$S"
w 3 "begin isolation level serializable;"
w 4 "begin isolation level serializable;"
w 3 "select * from test where i in (5,7);"
w 4 "select * from test where i in (5,7);"
w 3 "update test set t='x1' where i=7;"
w 4 "update test set t='x2' where i=5;"
w 3 "commit;"
w 4 "commit;"
exec 3>&- 4>&-
wait $pa $pb
cat $D/oa $D/ob
rm -rf $D
