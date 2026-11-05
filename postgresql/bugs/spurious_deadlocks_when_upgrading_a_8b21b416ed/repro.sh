D=$PWD/tmp_repro
rm -rf $D; mkdir $D
P="psql -X -q -At"
$P -c "create table tlu(id int primary key, name text); insert into tlu values (1,'a');"
mkfifo $D/f1 $D/f2 $D/f3
$P < $D/f1 > $D/o1 2>&1 &
$P < $D/f2 > $D/o2 2>&1 &
$P < $D/f3 > $D/o3 2>&1 &
exec 3>$D/f1 4>$D/f2 5>$D/f3
echo "begin; select id from tlu where id=1 for share;" >&3
sleep 0.5
echo "begin; select id from tlu where id=1 for update;" >&4
sleep 1
echo "begin; select id from tlu where id=1 for share;" >&5
sleep 0.5
echo "select id from tlu where id=1 for update;" >&5
sleep 3
echo "rollback;" >&3
sleep 1.5
echo "rollback;" >&5
sleep 0.5
echo "rollback;" >&4
sleep 0.5
exec 3>&- 4>&- 5>&-
wait
for s in 1 2 3; do echo "== session $s"; grep -v '^$' $D/o$s; done
rm -rf $D
