psql -X -q -c "drop table if exists pt; create table pt (a int, b int, c text) partition by list (a); create table pt1 partition of pt for values in (1); create table pt2 partition of pt for values in (2); insert into pt values (1,0,'x'),(2,0,'y');"
(echo "begin; update pt set b = b + 1 where a = 1;"; sleep 3; echo "commit;") | psql -X -q >/dev/null 2>&1 &
sleep 1
psql -X -q -c "delete from pt where a = (select 1);" 2>&1 | grep -v -e '^$' | sed 's/.*server closed.*/CRASH/;s/.*terminat.*/CRASH/' | head -1
wait
sleep 2
psql -X -q -c "select * from pt order by a" 2>&1 | head -5
