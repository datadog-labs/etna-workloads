d=$PWD/rt_$$; mkdir -p $d
psql -X -q -c "select lo_create(424242)" >/dev/null
pg_dump -Fc -Z gzip -d postgres -f $d/x.dump 2>&1
pg_restore -f $d/out.sql $d/x.dump 2>&1 | head -3
echo "restore rc=$?"
grep -c 424242 $d/out.sql
psql -X -q -c "select lo_unlink(424242)" >/dev/null
rm -rf $d
