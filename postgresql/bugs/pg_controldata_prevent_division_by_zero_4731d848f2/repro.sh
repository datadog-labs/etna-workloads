D=$PWD/ctl_tmp_data
rm -rf $D
initdb -D $D >/dev/null 2>&1
f=$D/global/pg_control
size=$(wc -c < $f)
head -c $size /dev/zero > $f
pg_controldata $D 2>&1 | grep -i -E 'warning|WAL segment size|REDO WAL file'
echo "exit: $?"
rm -rf $D
