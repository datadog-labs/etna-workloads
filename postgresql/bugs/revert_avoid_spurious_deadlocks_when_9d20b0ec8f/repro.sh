D=$(mktemp -d -p "$PWD")
psql -X -q -c "drop table if exists tlu; create table tlu(id int primary key, name text); insert into tlu values(1,'a')"
s1() { echo 'begin; select id from tlu where id=1 for share;'; sleep 5; echo 'rollback;'; sleep 1; }
s2() { echo 'begin; select id from tlu where id=1 for update;'; sleep 8; echo 'rollback;'; }
s3() { echo 'begin; select id from tlu where id=1 for share;'; sleep 0.5; echo 'select id from tlu where id=1 for update;'; sleep 6; echo 'rollback;'; }
s1 | psql -X -q -t -A > $D/s1.out 2>&1 &
sleep 0.5
s2 | psql -X -q -t -A > $D/s2.out 2>&1 &
sleep 0.5
s3 | psql -X -q -t -A > $D/s3.out 2>&1 &
wait
for f in s1 s2 s3; do echo "== $f"; grep -v '^DETAIL\|^HINT\|^CONTEXT\|^Process\|^LINE' $D/$f.out | sed 's/^psql:.*ERROR/ERROR/'; done
rm -rf $D
psql -X -q -c "drop table tlu"
