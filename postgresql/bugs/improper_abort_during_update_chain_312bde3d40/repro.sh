psql -X -q -c "create table dont_forget(value int); insert into dont_forget values (1)"
rm -f s1.fifo s1.out s2.fifo s2.out; mkfifo s1.fifo s2.fifo
psql -X -q -t -A < s1.fifo > s1.out 2>&1 &
exec 3> s1.fifo
psql -X -q -t -A < s2.fifo > s2.out 2>&1 &
exec 4> s2.fifo
echo "begin; select 'locked' from dont_forget for key share;" >&3
while ! grep -q locked s1.out; do sleep 0.1; done
echo "begin; update dont_forget set value = 2; select 'updated';" >&4
while ! grep -q updated s2.out; do sleep 0.1; done
echo "commit;" >&3
exec 3>&-
psql -X -q -t -A -c "select * from dont_forget for update" > s3.out 2>&1 &
sleep 2
echo "commit;" >&4
exec 4>&-
wait
cat s3.out
rm -f s1.fifo s1.out s2.fifo s2.out s3.out
