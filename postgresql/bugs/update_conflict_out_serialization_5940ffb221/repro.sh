D=$PWD/rtmp.$$; mkdir -p $D
psql -X -q -c "create table txn0(id int primary key, val text); create table txn1(id int primary key, val text);"
for s in foo bar trouble; do mkfifo $D/$s; psql -X -q <$D/$s >$D/$s.out 2>&1 & done
exec 3>$D/foo 4>$D/bar 5>$D/trouble
w() { sleep 1; }
echo "BEGIN ISOLATION LEVEL SERIALIZABLE;" >&3
echo "BEGIN ISOLATION LEVEL SERIALIZABLE;" >&4
echo "BEGIN ISOLATION LEVEL SERIALIZABLE;" >&5
echo "SELECT * FROM txn0 WHERE id = 42;" >&3; w
echo "INSERT INTO txn0 SELECT 42, 'bar_insert';" >&4; w
echo "INSERT INTO txn1 SELECT 7, 'foo_insert';" >&3; w
echo "COMMIT;" >&3; w
echo "UPDATE txn1 SET val = 'x' WHERE id = 7;" >&5; w
echo "SELECT * FROM txn1 WHERE id = 7;" >&4; w
echo "COMMIT;" >&4; w
echo "ABORT;" >&5; w
exec 3>&- 4>&- 5>&-
wait $(jobs -p) 2>/dev/null
echo "--- bar:"; grep -E "ERROR|rows|row\)" $D/bar.out
rm -rf $D
psql -X -q -c "drop table txn0, txn1"
